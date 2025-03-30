import json
import boto3
from ortools.constraint_solver import routing_enums_pb2
from ortools.constraint_solver import pywrapcp

def lambda_handler(event, context):
    client = boto3.client('location')
    
    # Extraer datos del evento
    locaciones_array = event['locaciones_array']
    
    # Preparar coordenadas para la solicitud de AWS
    departure_positions = [[float(loc['lon']), float(loc['lat'])] for loc in locaciones_array]

    # Depuración de entrada 
    #print("Departure Positions: ", departure_positions)
    
    # Obtener la matriz de distancias utilizando AWS Location Service -----------------------------------
    response = client.calculate_route_matrix(
        CalculatorName='calculadora-rutas-para-sys',
        DeparturePositions=departure_positions,
        DestinationPositions=departure_positions,
        TravelMode='Car'
    )
    
    distance_matrix = []
    for row in response['RouteMatrix']:
        # Depuración de cada fila 
        #print("Row: ", json.dumps(row, indent=2)) 
        distance_matrix.append([cell['Distance'] for cell in row])
    
    # Optimización de la ruta usando OR-Tools -------------------------------------------------------------
    def create_data_model():
        return {
            'distance_matrix': distance_matrix,
            'num_vehicles': 1,
            'depot': 0  # Índice del punto de origen
        }
    
    def print_solution(manager, routing, solution):
        route = []
        index = routing.Start(0)
        while not routing.IsEnd(index):
            route.append(manager.IndexToNode(index))
            index = solution.Value(routing.NextVar(index))
        return route
    
    # Crear el modelo de datos
    data = create_data_model()

    # Depurar modelo de datos 
    print("Data Model: ", json.dumps(data, indent=2))
    
    # Crear el gestor del enrutamiento
    manager = pywrapcp.RoutingIndexManager(len(data['distance_matrix']), data['num_vehicles'], data['depot'])
    
    # Crear el modelo de enrutamiento
    routing = pywrapcp.RoutingModel(manager)
    
    # Crear y registrar una función de distancia
    def distance_callback(from_index, to_index):
        from_node = manager.IndexToNode(from_index)
        to_node = manager.IndexToNode(to_index)
        return data['distance_matrix'][from_node][to_node]
    
    transit_callback_index = routing.RegisterTransitCallback(distance_callback)
      
    # Configurar los parámetros de búsqueda
    search_parameters = pywrapcp.DefaultRoutingSearchParameters()
    search_parameters.first_solution_strategy = routing_enums_pb2.FirstSolutionStrategy.PATH_CHEAPEST_ARC
    search_parameters.local_search_metaheuristic = routing_enums_pb2.LocalSearchMetaheuristic.GUIDED_LOCAL_SEARCH 
    search_parameters.time_limit.seconds = 30
    
    # Depurar parámetros de búsqueda 
    #print("Search Parameters: ", search_parameters)

    # Resolver el problema 
    try: 
        solution = routing.SolveWithParameters(search_parameters) 
    except Exception as e: 
        return { 
            'statusCode': 500, 
            'body': json.dumps({'error': 'Excepción durante SolveWithParameters: {}'.format(str(e))}) 
        }
    
    # Reordenar el array de locaciones según el orden optimizado
    if solution:
        route_indices = print_solution(manager, routing, solution)
        
        # Depurar route_indices 
        print("route_indices: ", route_indices)
        
        optimized_locaciones_array = [locaciones_array[i] for i in route_indices]
        return {
            'statusCode': 200,
            'body': json.dumps(optimized_locaciones_array)
        }

    return {
        'statusCode': 500,
        'body': json.dumps({'error': 'No se pudo encontrar una solución óptima'})
    }
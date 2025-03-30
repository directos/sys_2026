import json
import boto3
from itertools import permutations

def lambda_handler(event, context):
    client = boto3.client('location')
    
    # Extraer datos del evento
    locaciones_array = event['locaciones_array']
    
    # Preparar coordenadas para la solicitud de AWS
    departure_positions = [[float(loc['lon']), float(loc['lat'])] for loc in locaciones_array]

    # Depuración de entrada 
    #print("Departure Positions: ", departure_positions)

    # Obtener la matriz de distancias utilizando AWS Location Service ------------------------------------

    response = client.calculate_route_matrix(
        CalculatorName='calculadora-rutas-sys-here',
        DeparturePositions=departure_positions,
        DestinationPositions=departure_positions,
        TravelMode='Car'
    )
    
    # Construir la matriz de distancias
    distance_matrix = []
    for row in response['RouteMatrix']:
        distance_matrix.append([cell['Distance'] if cell else float('inf') for cell in row])
    
    # Verificar la matriz
    #print("Distance Matrix:", json.dumps(distance_matrix, indent=2))

    # Si queremos devolver solamente la distance_matrix: 
    """
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
            "Access-Control-Allow-Headers": "Content-Type"
        },
        "body": json.dumps({
            "distance_matrix": distance_matrix
        })
    }
    """
    # Optimización de la ruta usando itertools ------------------------------------------------------------
    
    # Puntos y punto inicial
    points = list(range(len(distance_matrix)))  # Usar índices en lugar de IDs
    start_point = points[0]  # Comenzar desde el primer punto
    other_points = points[1:]  # Excluye el punto inicial

    # Función para calcular la distancia total de un camino sin regreso al punto inicial
    def calculate_path_distance_no_return(path, matrix):
        distance = 0
        for i in range(len(path) - 1):
            distance += matrix[path[i]][path[i + 1]]
        return distance

    # Encontrar el camino de menor distancia sin regresar al punto inicial
    min_distance = float("inf")
    best_path = None

    # Generar todas las permutaciones de los puntos restantes
    for perm in permutations(other_points):
        path = [start_point] + list(perm)
        distance = calculate_path_distance_no_return(path, distance_matrix)
        if distance < min_distance:
            min_distance = distance
            best_path = path

    # Transformar el camino en IDs originales
    result_path = [locaciones_array[i]['id'] for i in best_path]

    # Response -------------------------------------------------------------------------------------------

    # Resultado
    #print("Camino más corto:", result_path)
    #print("Distancia total:", min_distance)

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
            "Access-Control-Allow-Headers": "Content-Type"
        },
        "body": json.dumps({
            "shortest_path": result_path,
            "total_distance": min_distance
        })
    }
import json
import boto3

def lambda_handler(event, context):
    client = boto3.client('location')
    
    # Extraer datos del evento
    locaciones_array = event['locaciones_array']
    
    # Preparar coordenadas para la solicitud de AWS
    departure_positions = [[float(loc['lon']), float(loc['lat'])] for loc in locaciones_array]

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
    
    # Si queremos devolver solamente la distance_matrix: 
    """
    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "https://funerariaeleden.com",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
            "Access-Control-Allow-Headers": "Content-Type"
        },
        "body": json.dumps({
            "distance_matrix": distance_matrix
        })
    }
    """
    # Optimización de la ruta usando algoritmo simple -----------------------------------------------------
    
    def find_route_from_origin(origin_index):
        num_points = len(distance_matrix)
        visited = [False] * num_points          # Array para marcar puntos visitados
        route = [origin_index]                  # Comenzamos la ruta desde el origen
        visited[origin_index] = True            # Marcamos el origen como visitado

        current_index = origin_index            # Índice del punto actual
        total_distance = 0                      # Inicializamos la distancia total

        for _ in range(1, num_points):
            next_index = -1
            min_distance = float('inf')

            # Buscamos el siguiente punto más cercano no visitado
            for j in range(num_points):
                if not visited[j] and distance_matrix[current_index][j] < min_distance:
                    min_distance = distance_matrix[current_index][j]
                    next_index = j

            if next_index != -1:
                visited[next_index] = True      # Marcamos el siguiente punto como visitado
                route.append(next_index)        # Agregamos a la ruta
                total_distance += min_distance  # Actualizamos la distancia total
                current_index = next_index      # Actualizamos el índice actual

        return route, total_distance            # Devolvemos la ruta ordenada y la distancia total

    # Encontrar la ruta comenzando desde el origen
    origin_index = 0  # Establecemos el índice de origen (punto 0)
    best_path, total_distance = find_route_from_origin(origin_index)

    # Transformar el camino en los IDs originales --------------------------------------------------------
    result_path = [locaciones_array[i]['id'] for i in best_path]

    # Response -------------------------------------------------------------------------------------------

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "https://funerariaeleden.com",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
            "Access-Control-Allow-Headers": "Content-Type"
        },
        "body": json.dumps({
            "shortest_path": result_path,
            "total_distance": total_distance
        })
    }
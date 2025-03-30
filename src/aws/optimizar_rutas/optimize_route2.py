import json
import boto3

def lambda_handler(event, context):
    # Crear cliente para Amazon Location Service
    client = boto3.client('location')
    
    # Extraer datos del evento
    origen = event['origen']  # Coordenadas de origen (ejemplo: [lon, lat])
    clientes = event['clientes']  # Lista de clientes con coordenadas

    # Crear listas de posiciones de salida
    departure_positions = [origen] + [client['Cli_geolocation'] for client in clientes]  # Incluir origen

    # Calcular la matriz de rutas
    response = client.calculate_route_matrix(
        CalculatorName='calculadora-rutas-para-sys',  # Reemplazar con el nombre de tu calculadora
        DeparturePositions=departure_positions,
        DestinationPositions=departure_positions,  # Usar la misma lista para destinos
        TravelMode='Car'  # Modo de viaje
    )
    
    # Procesar resultados para obtener la ruta optimizada
    route_info = response['RouteMatrix']
    
    optimized_route = []  # Aquí se almacenará el orden optimizado
    for i in range(len(route_info)):
        optimized_route.append({
            'from': departure_positions[i],
            'to': departure_positions[i + 1] if i + 1 < len(departure_positions) else None,
            'duration': route_info[i]['DurationSeconds'],
            'distance': route_info[i]['DistanceMeters']
        })
    
    return {
        'statusCode': 200,
        'body': json.dumps(optimized_route)
    }
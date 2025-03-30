import json
import boto3

def lambda_handler(event, context):
    # Crear cliente para Amazon Location Service
    client = boto3.client('location')
    
    # Extraer datos del evento
    origen = event['origen']  # Coordenadas de origen (ejemplo: [lon, lat])
    destino = event['destino']  # Coordenadas de destino (ejemplo: [lon, lat])
    clientes = event['clientes']  # Lista de clientes con coordenadas

    # Crear listas de posiciones de salida y destino
    departure_positions = [origen] + [client['Cli_geolocation'] for client in clientes]  # Incluir origen
    destination_positions = [destino] + [client['Cli_geolocation'] for client in clientes]  # Incluir destino

    # Calcular la matriz de rutas
    response = client.calculate_route_matrix(
        CalculatorName='calculadora-rutas-para-sys',  # Reemplazar con el nombre de tu calculadora
        DeparturePositions=departure_positions,
        DestinationPositions=destination_positions,
        TravelMode='Car'  # Modo de viaje
    )
    
    # Procesar resultados para obtener la ruta optimizada
    route_info = response['RouteMatrix']
    
    optimized_route = []  # Aquí se almacenará el orden optimizado
    for i in range(len(route_info)):  # Usar índices enteros para iterar
        for j in range(len(route_info[i])):  # Usar índices enteros para acceder a las rutas
            route = route_info[i][j]
            optimized_route.append({
                'from': departure_positions[i],
                'to': destination_positions[j],
                'duration': route['DurationSeconds'],
                'distance': route['Distance'],
            })
        
    return {
        'statusCode': 200,
        'body': json.dumps(optimized_route)
    }
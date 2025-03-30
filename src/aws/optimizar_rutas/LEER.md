# AWS API Gateway para Lambda

Vamos al servicio AWS Lambda y escribimos el archivo lambda_function.py con el código de nuestra fn.

*Podemos hacerlo en VSC y después lo ponemos en AWS Lambda.

A nuestra fn Lambda le pusimos el nombre "optimizeRoute".

## Instalar dependencias

Esta fn de py tiene una dependencia: boto3. Por eso, podemos usar la misma capa de la fn que hicimos para transferir archivos csv.

## Generar calculadora de rutas


Ref: https://docs.aws.amazon.com/es_es/location/latest/developerguide/calculate-route-matrix.html

1. En el servicio "Amazon Location Service" > Manage resources> Mapas, lugares, rutas > Rutas > Crear route calculator
Proveedor: "Here" (porque soporta hasta 350 direcciones; en cambio "Esri" solo 20)

2. Agregamos permiso para nuestra calculadora. 
Vamos a AWS Management Console > Roles > select "optimizeRoute-role-tnck3bjn" > Permissions tab...
"Add permissions" then "Create inline policy" 
y en el tab JSON copiamos esta política:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "geo:CalculateRouteMatrix",
            "Resource": "arn:aws:geo:us-east-1:275352248033:route-calculator/calculadora-rutas-sys-here"
        }
    ]
}
```
Le ponemos un nombre. Ej: "calculadora-rutas-sys-here"
Click "Create policy"

3. Probamos nuestra fn Lambda

## API Gateway

Vamos al servicio API Gateway. 

1. Btn "Crear API"
2. Seguimos los pasos para crear la nueva API, con el nombre "MiApi-optimizarRutas"
3. Creamos el recurso "/optimizar"
4. Le agregamos el método POST y en "Integración" lo enlazamos a nuestra fn Lambda "optimizeRoute"
5. Vamos a nuestro nuevo recurso POST, y en la cejilla Pruebas hacemos una prueba básica.

Para la prueba usamos estos datos Json:
```json
{
    "locaciones_array": [
        {"id": "4882", "lat": "8.4924781", "lon": "-82.8509914"},
        {"id": "6013", "lat": "8.647242", "lon": "-82.9410984"},
        {"id": "3870", "lat": "8.5517175", "lon": "-82.8377031"},
        {"id": "4616", "lat": "8.6399408", "lon": "-83.1857516"},
        {"id": "2692", "lat": "8.6877328", "lon": "-83.06993"}
    ]
}
```

## Habilitar CORS

Probablemente no hacía falta "habilitar CORS" en nuestra API. Pero lo hicimos así:

1. Vamos a nuestro recurso "/optimizar"
2. Clic en btn "Habilitar CORS"
3. Completamos los campos
4. Clic en btn "Implementar API" (esto es necesario para que los cambios surtan efecto)

Aquí el sistema crea un método llamado "OPTIONS". Es decir, ahora tenemos dos métodos: POST y OPTIONS

Para que funcione el CORS debemos hacer clic en el btn "Implementar API" en los tres recursos:
1. /optimizar
2. OPTIONS
3. POST

Ref: 
- https://repost.aws/questions/QUVeIoo4jaRjaSAUpaIfhP7w/api-gateway-cors-issue-using-js-fetch
- https://docs.aws.amazon.com/es_es/apigateway/latest/developerguide/how-to-cors-console.html
- https://docs.aws.amazon.com/es_es/apigateway/latest/developerguide/how-to-cors.html

## Pruebas

Para hacer las pruebas, usamos los datos Json (arriba). Hicimos las pruebas en este orden:

1. En nuestra fn Lambda "optimizeRoute"
2. En nuestra API "MiApi-optimizarRutas"
3. Desde nuestro frontend (VSC), con la ext Thunder client:
POST a: https://6izw9fmn59.execute-api.us-east-1.amazonaws.com/prod/optimizar
solo con los dos headers por defecto que pone Thunder
y el Body copiando el Json. Este fue el response:

```json
{
  "statusCode": 200,
  "headers": {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
    "Access-Control-Allow-Headers": "Content-Type"
  },
  "body": "{\"shortest_path\": [\"4882\", \"3870\", \"6013\", \"2692\", \"4616\"], \"total_distance\": 74.213}"
}
```

### Response:

Ej: Con la matriz de ejemplo (arriba), enviamos el array desordenado:

- Array = cuesta[0] ---> neily[1] ---> canoas[2] ---> golfifo[3] ---> rioclaro[4]

Y obtenemos este resultado ordenado (son los contrato_id ordenados según la ruta óptima):

`RESPONSE OK: [4882, 3870, 6013, 2692, 4616]`

- Ruta optimizada = cuesta[0]  --->  canoas[2]  --->  neily[1]  --->  rioclaro[4]  --->  golfifo[3]

Total_distance = 7.96 + 19.54 + 17.31 + 29.40   =  74.21 km

## COSTOS

Ref: https://aws.amazon.com/es/location/pricing/

### PRECIOS:

Item "Calcular la matriz de ruta":
* Precio por cada 1000 elementos de la matriz = 0.50 USD

Es decir: 0.0005 x elemento
Es decir: en un aruta de 100 clientes la matriz tendría 10,000 elementos (100 orígenes x 100 destinos). Calcular eso costaría $0.0005 x 10,000 = $5

### ESTIMADO:

Si tenemos...
- 4 cobradores, cada uno con 100 clientes por día
- $5 x 4 = $20 x 30 días = $600 por mes
- O lo que es lo mismo: 4 agentes x 10,000 elementos x 30 días = 1,200,000 elementos
- TOTAL:  1,200,000 x $0.0005 = $600

`$600 USD/mes`

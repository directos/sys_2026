# AWS Lambda

Vamos al servicio AWS Lambda y escribimos el archivo lambda_function.py con el código de nuestra fn.

*Podemos hacerlo en VSC y después lo ponemos en AWS Lambda.

### Instalar dependencias

Esta fn de py tiene dos dependencias: requests y boto3. 

En Windows: 

1. Creamos una carpeta
2. Vamos a esa carpeta
3. Instalamos esas dependencias, indicando que serán para x86_64:

```bash
pip install request boto3 --platform manylinux2014_x86_64 -t . --only-binary=:all:
```
Ahora, comprimimos la carpeta, asegurándonos de que tenga esta estructura interna:

```bash
layer_content.zip
└ python
    └ lib
        └ python3.13
            └ site-packages
                └ requests
                └ <other_dependencies>
                └ ...
```
> Ref: https://docs.aws.amazon.com/lambda/latest/dg/packaging-layers.html

### Capa de Lambda

Subimos el zip a S3 (temporalmente) para cargarlo de ahí a la capa de Lambda.
copiamos su URL

Vamos a Lambda > Layers ... creamos una nueva layer ... 
pegamos su URL
Opciones: 
- arquitectura = x86_64
- runtimes = Amazon Linux 2023
copiamos la ARN de la capa, para copiarla a continuación:

Vamos a la fn Lambda y agregamos la nueva capa a la fn, usando su ARN.


# S3

Después de crear el bucket de S3, vamos al bucket > Permisos

### Bloquear acceso público

Desactivar la opción principal. Y seleccionamos estas sub-opciones:

- Bloquear el acceso público a buckets y objetos concedido a través de nuevas listas de control de acceso (ACL)
- Bloquear el acceso público a buckets y objetos concedido a través de políticas de bucket y puntos de acceso públicas nuevas

*Es posible que primero tengamos que desactivar todo. Seguidamente crear la política. Y finalmente regresar aquí para seleccionar estas dos opciones.

### Política de bucket

Creamos o editamos una nueva política, con estas opciones (mediante json):

```json
 {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::sysbak-db/*"
        }
    ]
}
```
# Amazon EventBridge (Cron)

1. Creamos una nueva "Regla"

2. Y le configuramos la frecuencia, como si fuera un Cronjob. Ej: 

```bash
0 * * * ? *
```
3. La asociamos a un destino: nuestra fn Lambda
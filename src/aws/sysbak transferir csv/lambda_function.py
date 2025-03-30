import requests
import boto3
from bs4 import BeautifulSoup
import os

def lambda_handler(event, context):
    # URL del directorio donde están los archivos .csv y .txt
    url = 'https://funerariaeleden.com/sys/backend/bak/'
    
    # Configura tu bucket de S3
    BUCKET_NAME = 'sysbak-db'
    
    # Función para obtener archivos de la URL dada
    def get_files_from_url(url):
        response = requests.get(url)
        response.raise_for_status()  # Lanza un error si la solicitud falla
        
        # Procesar el contenido HTML para extraer enlaces a archivos
        files = []
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Encuentra todos los enlaces a archivos en la página
        for link in soup.find_all('a'):
            file_url = link.get('href')
            if file_url and (file_url.endswith('.csv') or file_url.endswith('.txt')):  # Filtra por extensión
                full_url = url + file_url  # Construye la URL completa
                files.append(full_url)
        
        return files
    
    # Función para subir archivos a S3
    def upload_to_s3(file_url):
        s3_client = boto3.client('s3')
        
        # Obtiene el nombre del archivo desde la URL
        file_name = os.path.basename(file_url)
        
        # Descarga el archivo
        response = requests.get(file_url)
        
        # Comprueba si la descarga fue exitosa
        if response.status_code == 200:
            # Sube el archivo a S3
            s3_client.put_object(Bucket=BUCKET_NAME, Key=file_name, Body=response.content)
            print(f"Archivo {file_name} subido a S3.")
        else:
            print(f"Error al descargar {file_name}: {response.status_code}")
    
    # Obtener todos los archivos desde la URL
    files = get_files_from_url(url)
    
    # Subir cada archivo a S3
    for file in files:
        upload_to_s3(file)
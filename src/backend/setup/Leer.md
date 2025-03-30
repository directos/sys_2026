# Backend de Sys

Este capítulo describe los pasos necesarios para instalar el backend del proyecto utilizando Composer.

## Requisitos previos

Antes de comenzar, asegúrate de tener lo siguiente instalado en tu sistema:
- PHP (versión compatible con el proyecto).
- Composer (administrador de dependencias para PHP).

## Pasos de instalación y config inicial

1. **Creamos la carpeta 'backend'**  
  Nos movemos a la carpeta principal del proyecto y creamos una carpeta llamada 'backend': `sys/backend`

2. **Instalar dependencias con Composer**  
  Ejecuta el siguiente comando para instalar las dependencias del proyecto:
  ```bash
  composer init
  composer install
  ```
3. **Crear archivo `index.php`**  
    Dentro de la carpeta `backend`, crea un archivo llamado `index.php` con el siguiente contenido:  
  ```php
    <?php
    echo "Soy tu API de Sys";
  ```

4. **Crear el server de backend local**
Nos movemos a la carpeta principal del proyecto para crear el server de backend local:
```bash
  cd .. 
  php -S localhost:8080 -t backend
```
Ahora podemos ver el response del backend usando el navegador en `http://localhost:8080`

5. **Instalamos Bramus-Router**

Este paquete lo usaremos en el backend para las rutas de la api. Ejecutaremos los siguientes comandos en /backend. Y después hacemos un composer install para que todo se reorganice (se instalen las dependencias o se integren al vendor):
```bash
  composer require bramus/router ~1.6 
  composer install
```

6. **Instalamos el ORM**

El ORM que usaremos es RedBeanPHP:

- Vamos al website del proveedor, y descargamos esta opción: `Download RedBeanPHP 5 all-drivers`
- La guardamos en /backend/lib/


3. **Configurar variables de entorno**  
  Copia el archivo de ejemplo `.env.example` y renómbralo como `.env`:
  ```bash
  cp .env.example .env
  ```
  Luego, edita el archivo `.env` para configurar las variables necesarias, como la conexión a la base de datos.

4. **Generar la clave de la aplicación**  
  Ejecuta el siguiente comando para generar una clave única para la aplicación:
  ```bash
  php artisan key:generate
  ```

5. **Migrar la base de datos**  
  Si el proyecto utiliza una base de datos, ejecuta las migraciones:
  ```bash
  php artisan migrate
  ```

6. **Iniciar el servidor de desarrollo**  
  Finalmente, inicia el servidor de desarrollo para verificar que todo funcione correctamente:
  ```bash
  php artisan serve
  ```

## Notas adicionales

- Si encuentras problemas durante la instalación, revisa la documentación oficial de Composer o los requisitos específicos del proyecto.
- Asegúrate de tener permisos adecuados para ejecutar los comandos en tu entorno.

¡Con esto, el backend debería estar instalado y listo para usarse!
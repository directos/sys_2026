# Setup del proyecto

Este documento describe los pasos necesarios para configurar el proyecto **Sys** en un entorno Docker LAMP. 

## Requisitos previos

- Docker y Docker Compose instalados en tu sistema. (https://docker.com)
- XAMPP instalado en tu sistema. (https://www.apachefriends.org). Para tener un ejecutable de PHP.
- Node.js instalado en tu sistema. (https://nodejs.org)
- VSC instalado en tu sistema.

## Pasos iniciales

**Clonar el repositorio**  
  ```bash
  git clone github.com/directos/docker-lamp
  cd docker-lamp
  ```

**Crear directorio de sys**

Si no existe, crearlo dentro de www

**Configurar el archivo `.env`**  
  Copia el archivo de ejemplo `.env.example` y renómbralo como `.env`. Luego, ajusta las variables según sea necesario.

  ```bash
  cp .env.example .env
  ```

**Construir y levantar los contenedores**  
Ejecuta el siguiente comando para construir y levantar los servicios Docker:

  ```bash
  docker-compose up -d
  ```

**Configurar la base de datos**  
Importa el archivo SQL inicial si es necesario:

**Acceder al proyecto**  
Abre tu navegador:
- Raiz del proyecto en el docker: `http://localhost`
- PhpMyAdmin: `http://localhost:8080`
- Backend: `http://localhost/sys/backend/`
- Frontend: `http://localhost/sys/frontend/`

## Comandos útiles

- **Levantar los contenedores**  
```bash
docker-compose up -d
```
- **Detener los contenedores**  
```bash
docker-compose down
```
- **Reiniciar los contenedores**  
```bash
docker-compose restart
```

## Notas adicionales

- Asegúrate de que los puertos necesarios no estén en uso antes de iniciar los contenedores.
- Consulta la documentación oficial de Docker si encuentras problemas.

# Backend

Este capítulo describe los pasos necesarios para instalar el backend del proyecto, utilizando Composer.

## Requisitos previos

Antes de comenzar, asegúrate de tener lo siguiente instalado en tu sistema:
- PHP (versión compatible con el proyecto). Esto lo hemos resuelto instalando XAMPP en nuestro sistema.
- Composer (administrador de dependencias para PHP).

## Pasos de instalación y config inicial

**Creamos la carpeta 'backend'**  
  Nos movemos a la carpeta principal del proyecto y creamos una carpeta llamada 'backend': `sys/backend`

**Instalar dependencias con Composer**  
  En la carpeta sys/backend ejecutamos el siguiente comando para instalar las dependencias del proyecto:
  ```bash
  composer init
  composer install
  ```
**Crear archivo `index.php`**  
    En la carpeta sys/backend, creamos un archivo llamado `index.php` con el siguiente contenido:  
  ```php
    <?php
    echo "Soy tu API de Sys";
  ```
**Instalamos Bramus-Router**

Este paquete lo usaremos en el backend para las rutas de la api. Ejecutaremos los siguientes comandos en /backend. Y después hacemos un composer install para que todo se reorganice (se instalen las dependencias o se integren al vendor):
```bash
  composer require bramus/router ~1.6 
  composer install
```

**Instalamos el ORM**

El ORM que usaremos es RedBeanPHP:

- Vamos al website del proveedor, y descargamos esta opción: `Download RedBeanPHP 5 all-drivers`
- La guardamos en /backend/lib/


**Configurar variables de entorno**  

Copia el archivo de ejemplo `.env.example` y renómbralo como `.env`:
```bash
  cp .env.example .env
```
Luego, edita el archivo `.env` para configurar las variables necesarias, como la conexión a la base de datos.

*Nota: Es posible que en el entorno local debamos ir a phpMyAdmin, y crear un nuevo usuario para la BD del proyecto. En la BD > Privilegios > Nuevo

# Frontend

Este capítulo describe los pasos necesarios para instalar el frontend del proyecto, utilizando Node.js.

**Creamos la carpeta 'backend'**  
  Nos movemos a la carpeta principal del proyecto y creamos una carpeta llamada 'backend': `sys/frontend`

**Iniciamos NPM**  
Vamos a la carpera wwww/frontend. Esto iniciará NPM y creará el archivo package.json:
```bash
  npm init -y
  npm install
```

Otros componentes:

```bash
npm install webpack
npm install --save-dev terser webpack 
npm install --save-dev html-minimizer-webpack-plugin 
npm install --save-dev css-minimizer-webpack-plugin 
npm install --save-dev mini-css-extract-plugin
npm install --save-dev style-loader
```

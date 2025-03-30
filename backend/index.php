<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/lib/RedBeanPHP5_7_4/rb.php';

use Bramus\Router\Router;
use Dotenv\Dotenv;

// Cargar variables de entorno desde .env encontrato en este mismo directorio
$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->safeLoad(); // Usamos safeLoad para evitar errores si .env no existe

// Configuración de la base de datos usando variables de entorno
$db_host = $_ENV['DB_HOST']; // $db_host = $_ENV['DB_HOST'] ?: 'db';
$db_name = $_ENV['DB_NAME'];
$db_user = $_ENV['DB_USER'];
$db_pass = $_ENV['DB_PASS'];

try {
    R::setup("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);

    if (!R::testConnection()) {
        throw new Exception("No se pudo conectar a la base de datos... Host: $db_host | DB: $db_name | User: $db_user");
    }
} catch (Exception $e) {
    die('Error de conexión: ' . $e->getMessage());
}

$router = new Router();

// Cargar las rutas desde el archivo dedicado
require __DIR__ . '/src/Routes/web.php';

$router->run();
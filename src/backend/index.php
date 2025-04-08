<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

require_once __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/lib/RedBeanPHP5_7_4/rb.php';

use Bramus\Router\Router;
use Dotenv\Dotenv;
use Sys\Backend\Routes\Web;
use Sys\Backend\Routes\Auth;

// Cargar variables de entorno desde .env:
$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->safeLoad(); // Usamos safeLoad para evitar errores si .env no existe

// Configuración de la base de datos usando variables de entorno:
$db_host = $_ENV['DB_HOST']; // $db_host = $_ENV['DB_HOST'] ?: 'db';
$db_name = $_ENV['DB_NAME'];
$db_user = $_ENV['DB_USER'];
$db_pass = $_ENV['DB_PASS'];

// Definimos una excepción personalizada para errores de conexión a la base de datos:
class DatabaseConnectionException extends Exception {}

try {
    R::setup("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);

    if (!R::testConnection()) {
        throw new DatabaseConnectionException("No se pudo conectar a la base de datos... Host: $db_host | DB: $db_name | User: $db_user");
    }
} catch (DatabaseConnectionException $e) {
    die('Error de conexión: ' . $e->getMessage());
}

// Registramos las rutas:
$router = new Router();
    Web::register($router);
    Auth::register($router);
$router->run();

<?php

namespace Sys\Backend\Routes;

use Bramus\Router\Router;
use Sys\Backend\Controllers\SucursalController;
use Sys\Backend\Controllers\UsuarioController;

class Web
{
    public static function register(Router $router)
    {
        $router->get('/', function () {
            echo "Welcome to Sys API!";
        });
        
        $router->get('/sucursales', [SucursalController::class, 'getAll']);
        $router->get('/sucursales/(\d+)', [SucursalController::class, 'getById']);
        $router->get('/usuarios', [UsuarioController::class, 'getAll']);
        $router->get('/usuarios/(\d+)', [UsuarioController::class, 'getById']);
    }
}

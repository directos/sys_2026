<?php

use Xt\Backend\Controllers\SucursalController;
use Xt\Backend\Controllers\UsuarioController;

$router->get('/', function () {
    echo "Yo solo soy el router";
});

$router->get('/sucursales', [SucursalController::class, 'getAll']);
$router->get('/sucursales/(\d+)', [SucursalController::class, 'getById']);
$router->get('/usuarios', [UsuarioController::class, 'getAll']);
$router->get('/usuarios/(\d+)', [UsuarioController::class, 'getById']);

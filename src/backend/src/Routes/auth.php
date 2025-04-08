<?php

namespace Sys\Backend\Routes;

use Bramus\Router\Router;
use Sys\Backend\Controllers\AuthController;

class Auth
{
    public static function register(Router $router)
    {
        $router->post('/login', [AuthController::class, 'login']);
        $router->post('/validate-token', [AuthController::class, 'validateToken']);
    }
}

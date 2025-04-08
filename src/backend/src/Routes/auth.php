<?php

namespace Sys\Backend\Routes;

use Bramus\Router\Router;
use Sys\Backend\Controllers\AuthController;

class Auth
{
    public static function register(Router $router)
    {
        $authController = new AuthController();

        // Ruta para el login:
        $router->post('/login', function () use ($authController) {
            echo $authController->login();
        });

        $router->post('/validate-token', [AuthController::class, 'validateToken']);
    }
}

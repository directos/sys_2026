<?php

namespace Xt\Backend\Controllers;

use Xt\Backend\Models\Usuario;
use Xt\Backend\Traits\HeaderTrait;

class UsuarioController
{
    use HeaderTrait;

    public static function getAll()
    {
        self::setHeaders();
        $usuarios = Usuario::findAll();
        echo json_encode($usuarios);
    }

    public static function getById($id)
    {
        self::setHeaders();
        $usuario = Usuario::findById($id);
        if ($usuario->id) {
            echo json_encode($usuario);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'Usuario no encontrado']);
        }
    }
}

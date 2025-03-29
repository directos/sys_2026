<?php

namespace Xt\Backend\Controllers;

use R;
use Xt\Backend\Models\Sucursal;
use Xt\Backend\Traits\HeaderTrait;

class SucursalController
{
    use HeaderTrait;

    public static function getAll()
    {
        self::setHeaders();
        $sucursales = Sucursal::findAll();
        echo json_encode(R::exportAll($sucursales));
    }

    public static function getById($id)
    {
        self::setHeaders();
        $sucursal = Sucursal::findById($id);
        if ($sucursal->id) {
            echo json_encode($sucursal);
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'Sucursal no encontrada']);
        }
    }
}

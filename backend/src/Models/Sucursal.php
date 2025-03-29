<?php

namespace Xt\Backend\Models;

use R;

class Sucursal
{
    public static function findAll()
    {
        return R::findAll('sucursales');
    }

    public static function findById($id)
    {
        return R::load('sucursales', $id);
    }
}

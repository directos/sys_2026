<?php

namespace Xt\Backend\Models;

use R;

class Usuario
{
    public static function findAll()
    {
        return R::findAll('usuarios');
    }

    public static function findById($id)
    {
        return R::load('usuarios', $id);
    }
}

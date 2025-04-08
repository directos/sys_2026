<?php

namespace Sys\Backend\Models;

use R;

class Usuario
{
    public static function findAll()
    {
        // Usa la conexión global de RedBeanPHP
        return R::findAll('usuarios');
    }

    public static function findById($id)
    {
        // Usa la conexión global de RedBeanPHP
        return R::load('usuarios', $id);
    }

    public static function findByUsername($username)
    {
        // Usa la conexión global de RedBeanPHP para consultas personalizadas
        $user = R::findOne('usuarios', 'usuario = ?', [$username]);
        return $user ? $user->export() : null;
    }
}

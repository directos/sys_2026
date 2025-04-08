<?php

namespace Sys\Backend\Traits;

trait HeaderTrait
{
    protected static function setHeaders()
    {
        // Obtener el origen de la solicitud
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';

        // Obtener el dominio del servidor
        $serverDomain = $_SERVER['REQUEST_SCHEME'] . '://' . $_SERVER['HTTP_HOST'];

        // Verificar si el origen coincide con el dominio del servidor
        if ($origin === $serverDomain) {
            header('Access-Control-Allow-Origin: ' . $origin);
        } else {
            header('Access-Control-Allow-Origin:'); // No permitir otros orígenes
        }

        header('Content-Type: application/json');
    }
}

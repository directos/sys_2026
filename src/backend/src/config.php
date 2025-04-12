<?php

namespace Sys\Backend;

class Config
{
    public static function get()
    {
        return [
            'db' => [
                'host' => $_ENV['DB_HOST'] ?? 'localhost',
                'name' => $_ENV['DB_NAME'] ?? 'funera20_sys2026',
                'user' => $_ENV['DB_USER'] ?? 'funera20_admin',
                'pass' => $_ENV['DB_PASS'] ?? 'a1d2m3i4n5s6y7s8',
            ],
            'app' => [
                'env' => $_ENV['APP_ENV'] ?? 'production',
                'debug' => filter_var($_ENV['APP_DEBUG'] ?? false, FILTER_VALIDATE_BOOLEAN),
            ],
            'jwt' => [
                'secret' => $_ENV['JWT_SECRET'] ?? 'miLlaveSecretaParaSys20120420',
            ],
            'utc_local' => 21600,
        ];
    }
}

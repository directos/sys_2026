<?php

namespace Sys\Backend\Controllers;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Sys\Backend\Models\Usuario;

class AuthController
{
    private $secretKey;

    public function __construct()
    {
        $this->secretKey = getenv('JWT_SECRET');
    }

    public function login($username, $password)
    {
        $usuarioModel = new Usuario();
        $user = $usuarioModel->findByUsername($username);

        if (!$user || !password_verify($password, $user['password'])) {
            http_response_code(401);
            return json_encode(['error' => 'Credenciales inválidas']);
        }

        $payload = [
            'iss' => 'http://localhost', // Emisor
            'aud' => 'http://localhost', // Audiencia
            'iat' => time(),             // Tiempo de emisión
            'exp' => time() + 3600,      // Expiración (1 hora)
            'data' => [
                'id' => $user['id'],
                'username' => $user['usuario']
            ]
        ];

        $jwt = JWT::encode($payload, $this->secretKey, 'HS256');

        return json_encode(['token' => $jwt]);
    }

    public function validateToken($token)
    {
        try {
          // Devolvemos el token decodificado:
          return JWT::decode($token, new Key($this->secretKey, 'HS256'));
        
        } catch (\Exception $e) {
            http_response_code(401);
            return json_encode(['error' => 'Token inválido']);
        }
    }
}

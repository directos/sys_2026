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
        $this->secretKey = $_ENV['JWT_SECRET'];
    }

    public function login()
    {
        $input = json_decode(file_get_contents('php://input'), true);
        $username = $input['usuario'];
        $password = $input['password'];

        // Buscar el usuario en la base de datos
        $usuarioModel = new Usuario();
        $user = $usuarioModel->findByUsername($username);

        // Verificar credenciales
        if (!$user || !password_verify($password, $user['password'])) {
            http_response_code(200); // Código de error 401: Unauthorized
            return json_encode(['message' => 'Credenciales inválidas']);
        }

        // Crear el payload del token JWT
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

        // Generar el token JWT:
        $jwt = JWT::encode($payload, $this->secretKey, 'HS256');

        // Responder con el token:
        http_response_code(200); // Código de éxito 200: OK
        return json_encode([
            'success' => true,
            'token' => $jwt
        ]);
        
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

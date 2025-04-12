<?php

namespace Sys\Backend\Controllers;

use Firebase\JWT\JWT;
use Firebase\JWT\Key;
use Sys\Backend\Models\Usuario;
use Sys\Backend\Config;

class AuthController
{
    private $secretKey;
    private $config;

    public function __construct()
    {
        $this->config = Config::get(); // Almacenar toda la configuración
        $this->secretKey = $this->config['jwt']['secret'];
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
            setcookie('SYS_TOKEN', '', time()-1, '/'); // Borrar la cookie del token
            http_response_code(401); // Código de error 401: Unauthorized
            return json_encode(['message' => 'Credenciales inválidas']);
        }

        // Si las credenciales son válidas, continuamos...
        $token_exp = strtotime('tomorrow midnight') + $this->config['utc_local']; // Expiración del token a la medianoche

        // Crear el payload del token JWT
        $payload = [
            'iss' => 'http://localhost', // Emisor
            'aud' => 'http://localhost', // Audiencia
            'iat' => time(),             // Tiempo de emisión
            'exp' => $token_exp,         // Expiración
            'data' => [
                'usuario_id'     => intval($user['id']),
                'usuario'        => $user['usuario'],
                'pila'           => $user['nombre_pila'],
                'nombre'         => $user['nombre'],
                'apellidos'      => $user['apellidos'],
                'generoa'        => $user['genero'] == 'm' ? 'o' : 'a',
                'vista'          => $user['vista'],
                'sabor'          => $user['sabor'],
                'rol_principal'  => $user['rol_principal'],
                'rol_gerente'    => $user['rol_gerente'] == 1 ? true : false,
                'rol_gestor'     => $user['rol_gestor'] == 1 ? true : false,
                'rol_supervisor' => $user['rol_supervisor'] == 1 ? true : false,
                'rol_admin'      => $user['rol_admin'] == 1 ? true : false,
                'rol_agenda'     => $user['p_agenda'] == 1 ? true : false,
                'rol_amaster'    => $user['p_amaster'] == 1 ? true : false,
                'rol_eliminar'   => $user['p_eliminar'] == 1 ? true : false,
                'rol_dev'        => $user['rol_dev'] == 1 ? true : false,
                'p_facturar'     => $user['p_facturar'] == 1 ? true : false,
                'p_eliminar'     => $user['p_eliminar'] == 1 ? true : false,
                'sucursal_id'    => intval($user['sucursal_id']),
                'mensaje'        => $user['mensaje'] != '' ? $user['mensaje'] . ' ' : '',
                'sys_habla'      => $user['sys_habla'] == 1 ? true : false,
            ]
        ];

        // Generar el token JWT:
        $token = JWT::encode($payload, $this->secretKey, 'HS256');

        // Guardar el token en el cliente:
        setcookie('SYS_TOKEN', $token, $token_exp, '/');

        // Responder con el token:
        http_response_code(200); // Código de éxito 200: OK
        return json_encode([
            'success' => true,
            'token' => $token,
            'usuario' => $user['usuario'],
            'vista' => $user['vista'],
            'sabor' => $user['sabor'],
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

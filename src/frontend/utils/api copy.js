/*********************************************************************************
(C)2025 Orlando Arteaga & Shasling Pamela.
Fn del sistema para enviar requests a la bd.
*********************************************************************************/

import axios from 'axios';
import { isLocalhost, dirBackend, extBackend, urlLogin } from './config.js';
import { generarToken, getCookie, delCookie } from './token.js';
import { Modal_app } from './utiles.js';

let USUARIO_vista;
try {
    USUARIO_vista = JSON.parse(localStorage.getItem('USUARIO')).vista;
} catch {
    USUARIO_vista = 'pendiente';
}

export function Api(datax) {
    return new Promise(async (resolve, reject) => {
        let url, accion;
        const metodo = datax.metodo ? datax.metodo : 'POST';

        // Construimos la URL de la API
        if (datax && datax.api && datax.api.includes("./")) {
            url = datax.api + extBackend;
        } else {
            url = '../' + dirBackend + datax.api + extBackend;
        }

        try {
            accion = Object.keys(datax.data)[0].replace('accion_', '');
        } catch (err) {
            accion = 'api ';
        }

        // Si estamos en localhost (dev) y no hay un token, creamos uno de prueba
        try {
            let sys_token = getCookie('SYS_TOKEN');
            if (isLocalhost && !sys_token) {
                let token = '',
                    tiempo_now = parseInt(Date.now() / 1000),
                    payload = {
                        iat: tiempo_now,
                        exp: tiempo_now + 64800,
                        iss: 'localhost',
                        usuario_id: 7,
                        user: 'pamela',
                        pila: 'pamelita',
                        nombre: 'Pamela',
                        apellidos: 'Alfaro Araya',
                        genero: 'a',
                        vista: 'desktop',
                        sabor: 'admin',
                        rol_principal: 'admin',
                        rol_gerente: true,
                        rol_gestor: false,
                        rol_supervisor: true,
                        rol_admin: true,
                        rol_agenda: false,
                        rol_amaster: false,
                        rol_dev: true,
                        p_facturar: true,
                        sucursal_id: 1,
                        mensaje: 'estamos en localhost.',
                    };

                token = generarToken(payload);
                document.cookie = `SYS_TOKEN=${token}; expires=${payload.exp}; path=/`;
            }
        } catch (err) {
            console.log('Error en localhost @ api.js: [' + accion + '] ' + err);
        }

        // Hacemos la llamada a la API usando Axios
        try {
            const response = await axios({
                url,
                method: metodo,
                headers: {
                    'Content-Type': 'application/json',
                    // 'Authorization': `Bearer ${sys_token}`, // Descomenta si necesitas enviar el token
                },
                data: datax.data,
            });

            resolve(response.data); // Resolvemos con los datos de la respuesta
        } catch (err) {
            console.error('Error en la llamada a la API:', err);

            // Manejo de errores
            if (USUARIO_vista === 'desktop') {
                let titulo, mensaje;

                if (err.message.includes('abort')) {
                    titulo = 'Api: abortando';
                    mensaje = `Se abortó la consulta a la BD porque abandonaste la sección. Si lo hiciste intencionalmente no te preocupes, puedes continuar normalmente.`;
                } else if (err.message.includes('timeout')) {
                    titulo = 'Api: tiempo agotado';
                    mensaje = `El servidor no logró enviarte la data a tiempo. Puedes volver a intentarlo o comunicarte con Soporte si el problema persiste.`;
                } else if (err.response && err.response.status === 500) {
                    titulo = 'Api: error 500';
                    mensaje = `Se presentó un problema temporal. Puedes comunicarte con Soporte si el problema persiste.`;
                } else {
                    titulo = 'Api: error';
                    mensaje = `Ocurrió un error: ${err.message}. Por favor, revisa los resultados o vuelve a intentarlo.`;
                }

                Modal_app.color = 'warning';
                Modal_app.titulo = titulo;
                Modal_app.mensaje = mensaje;
                Modal_app.mostrar();
            }

            reject(err.message);
        }
    });
}

export function Abortar(codigo) {
    window.location.href = urlLogin + '?' + codigo;
    delCookie('SYS_TOKEN');
    return false;
}
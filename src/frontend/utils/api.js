/*********************************************************************************
(C)2025 Orlando Arteaga & Shasling Pamela.
Fn del sistema para enviar requests a la bd.
*********************************************************************************/

import axios from 'axios';
//import { isLocalhost, dirBackend, extBackend, urlLogin } from './config.js';
import { generarToken, getCookie, delCookie } from './token.js';
//import { Modal_app } from './utiles.js';

let USUARIO_vista;
try {
    USUARIO_vista = JSON.parse(localStorage.getItem('USUARIO')).vista;
} catch {
    USUARIO_vista = 'pendiente';
}

export function Api(datax) {
    return new Promise((resolve, reject) => {
        const executeApiCall = async () => {
            const backendUrl = process.env.BACKEND_URL; // Leemos la variable de entorno
            const url = `${backendUrl}/${datax.api}`;
            const metodo = datax.metodo ? datax.metodo : 'GET';
            const accion = Object.keys(datax.data)[0].replace('accion_', '') || 'api';

            // Hacemos la llamada a la API usando Axios
            try {
                const response = await axios({
                    url,
                    method: metodo,
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    data: datax.data,
                });
                resolve(response.data);
            } catch (err) {
                console.error('Error en la llamada a la API:', err);

                // Manejo de errores
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

                console.warn(titulo + ': ' + mensaje);
                reject(new Error(err.message));
            }
        };

        executeApiCall();
    });
}

export function Abortar(codigo) {
    window.location.href = urlLogin + '?' + codigo;
    delCookie('SYS_TOKEN');
    return false;
}
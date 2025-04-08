/*********************************************************************************
(C)2021 Orlando Arteaga & Shasling Pamela.
Fn genéricas de apoyo al sistema.
*********************************************************************************/

import * as en from './enums.js';
import { dirBackend, extBackend } from './config.js';

const timezone_offset = new Date().getTimezoneOffset()/60;

// Fn global para ejecutar tanto en Escritorio como en Movil:
$(document).ready(function () {
    // Ejecutamos con refuerzo a los X segundos (por si la velocidad del dispositivo es más lenta):
    Acciones_globales_al_inicio();
    setTimeout(function () { Acciones_globales_al_inicio(); }, 10000); 
    setTimeout(function () { Acciones_globales_al_inicio(); }, 30000);  
    setTimeout(function () { Acciones_globales_al_inicio(); }, 60000);  

    // Fn:
    function Acciones_globales_al_inicio() {
        // Al hacer clic sobre cualquier elemento del dom:
        /*$(document).on('click', 'body *', function () {
            try {
                $(this).find('[data-toggle="tooltip"]').tooltip('hide');    // $(this) = el elemento donde se hizo el clic.
                $('[data-toggle="tooltip"]').tooltip('hide');               // Ocultamos todos los tooltips posibles.
            } catch {
                // No hacemos nada. 
            }
        });*/

        // Para desactivar el autofill de los inputs:
        $('input').attr('autocomplete', 'off');
    }
});

// Para enviar un mensaje automático por Whatsapp:
export function enviarWhatsapp(telefono, mensaje) {
    return new Promise(function (resolve, reject) {
        // Ajax directo:
        $.ajax({
            url: '../' + dirBackend + 'back_wa' + extBackend,
            method: 'POST',
            data: {
                accion_enviar_mensaje_por_whastapp: 'true',
                telefono: telefono,
                mensaje: mensaje
            },
            beforeSend: function () { 
                console.log("Enviando mensaje por WhatsApp al número " + telefono + " ..."); 
            },
            success: function (response) {
                let resultado = response.includes('5') ? 'Exitoso' : 'Fallido'; // "5" es un enum de CAMPANA_ESTATUS en el backend.
                console.log(resultado);
                resolve(resultado);
            },
            error: function (err) {
                reject(err);
            },
            //timeout: 5000 // Enviamos el request pero no nos quedamos esperando el response, por eso renunciamos a los 5 segundos.
        });        
    });
}

// Calcula espacio libre en localStorage:
export function calcularLocalStorage() {
    let resultado,
        storage_total = 1024 * 1024 * 5,
        storage_used = unescape(encodeURIComponent(JSON.stringify(localStorage))).length,
        storage_free = storage_total - storage_used,
        factor = 0.000001; // Para llevar el deploy de bits en MB (aprox).

    console.log("LocalStorage, MB (Total|Used|Free): " + storage_total + " " + storage_used + " " + storage_free);
    $('.storage-free').html("Storage <sup>(MB)</sup>: " + (storage_total * factor).toFixed(2) + "<span class= | " + (storage_used * factor).toFixed(2) + " | " + (storage_free * factor).toFixed(2));

    resultado = {
        total: bytesToSize(storage_total),
        used: bytesToSize(storage_used),
        free: bytesToSize(storage_free)
    };

    return resultado;
}

// Calcula espacio libre en localStorage:
export function calcularSessionStorage() {
    let resultado,
        espacio_total = 1024 * 1024 * 5,
        espacio_usado = unescape(encodeURIComponent(JSON.stringify(sessionStorage))).length,
        espacio_libre = espacio_total - espacio_usado,
        factor = 0.000001; // Para llevar el deploy de bits en MB (aprox).

    resultado = {
        espacio_total: bytesToSize(espacio_total),
        espacio_usado: bytesToSize(espacio_usado),
        espacio_libre: bytesToSize(espacio_libre),
        espacio_usado_xcien: (espacio_usado * 100 / espacio_total).toFixed(1),
        espacio_libre_xcien: (espacio_libre * 100 / espacio_total).toFixed(1),
    };

    // Escribimos resultados:
    console.log('sessionStorage', resultado);
    $('.storage-free').html('Session storage:');
    $('.storage-izq').text(resultado.espacio_usado_xcien + '%');
    $('.storage-der').text(resultado.espacio_libre_xcien + '%');
    $('.storage-centro').text(resultado.espacio_total);
    $('#bar-storage').css('width', resultado.espacio_usado_xcien + '%').attr('aria-valuenow', resultado.espacio_usado_xcien);
    // Cambiamos el color de la barra según el % de espacio usado:
    $('#bar-storage').removeClass('bg-danger bg-warning bg-success');
    if (resultado.espacio_usado_xcien > 80) $('#bar-storage').addClass('bg-danger');
    else if (resultado.espacio_usado_xcien > 50) $('#bar-storage').addClass('bg-warning');
    else $('#bar-storage').addClass('bg-success');
}

// Calcular espacio de almacenamiento con la API StorageManager, de indexexDB:
export async function calcularStorage() {
    let resultado = {
        espacio_total: 0,
        espacio_usado: 0,
        espacio_libre: 0,
        porcentaje_usado: 0,
        porcentaje_libre: 0,
    }
    if ('storage' in navigator && 'estimate' in navigator.storage) {
        const { usage, quota } = await navigator.storage.estimate();
        
        resultado.espacio_total = bytesToSize(quota);
        resultado.espacio_usado = bytesToSize(usage);
        resultado.espacio_libre = bytesToSize(quota - usage);
        resultado.porcentaje_usado = ((usage / quota) * 100).toFixed(1);
        resultado.porcentaje_libre = (100 - resultado.porcentaje_usado).toFixed(1);

        // Tratamos los porcentajes:
        resultado.porcentaje_usado = parseInt(resultado.porcentaje_usado) == 0 ? 0.1 : resultado.porcentaje_usado;
        resultado.porcentaje_libre = parseInt(resultado.porcentaje_libre) == 100 ? 99.9 : resultado.porcentaje_libre;
    
        // Escribimos en el dom del navbar agendas móviles:
        console.log('indexedDB', resultado);
        try {
            $('.app-storage').text(resultado.porcentaje_libre.toFixed(1) + '%');
        } catch (err) {
            $('.app-storage').text('99%');
        }
    } else {
        console.warn('La API StorageManager de indexedDB no está disponible.');
    }
}

/**
 * Convierte bytes a una cadena de tamaño legible por humanos.
 * @param {number} bytes - El número de bytes a convertir.
 * @returns {string} La cadena de tamaño legible por humanos.
 */
export function bytesToSize(bytes) {
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
    if (bytes === 0) {
      return '0 Bytes';
    }
    let i = Math.floor(Math.log(bytes) / Math.log(1024));
    return `${(bytes / Math.pow(1024, i)).toFixed(2)} ${sizes[i]}`;
}

/**
 * Inserta un archivo HTML en otra página HTML.
 * @param {string} dir_base - El directorio base al que pertenecen los archivos a incluir.
 */
export function incluirHtmlFiles(dir_base = '') {
    const includes = $('[data-include]'); // Selector de todos los elementos data-include.

    // Recorremos todos los elementos y, si está vacío, le cargamos su archivo correspondiente:
    $.each(includes, function () {
        if ($(this).is(':empty')) {
            let file = `${dir_base}${$(this).data('include')}`;
            $(this).load(`${file}`); // $(this).load(`${file}?${Date.now()}`); // Para evitar el cacheo, le agregamos la fecha now como versión.
        }
    });
}

/**
 * Objeto para mostrar un modal con un mensaje al usuario.
 */
export const Modal_app = {
    color: 'dark',
    titulo: 'Título',
    mensaje: 'Este es el mensaje',
    spinner: false,

    /**
     * Muestra el modal con el mensaje.
     */
    mostrar: function () {
        this._actualizarModal();
        $('#modal-app-mensaje').appendTo("body").modal('show');
    },

    /**
     * Oculta el modal con el mensaje.
     */
    ocultar: function () {
        $('#modal-app-mensaje').find('.bi-info-circle-fill').removeClass('text-danger, text-warning, text-info, text-success, text-dark'); // Quitamos todos los class de color del ícono.
        $('#modal-app-mensaje').modal('hide');
    },

    /**
     * Actualiza el contenido del modal con los valores actuales de las propiedades del objeto.
     */
    _actualizarModal: function () {
        // Agregamos el class de color correspondiente:
        if (this.color == 'danger') $('#modal-app-mensaje').find('.bi-info-circle-fill').addClass('text-danger');
        else if (this.color == 'warning') $('#modal-app-mensaje').find('.bi-info-circle-fill').addClass('text-warning');
        else if (this.color == 'info') $('#modal-app-mensaje').find('.bi-info-circle-fill').addClass('text-info');
        else if (this.color == 'success') $('#modal-app-mensaje').find('.bi-info-circle-fill').addClass('text-success');
        else $('#modal-app-mensaje').find('.bi-info-circle-fill').addClass('text-dark');

        // Mostramos u ocultamos el spinner:
        if (this.spinner == true) $('#modal-app-mensaje').find('.modal-app-spinner').removeClass('d-none');
        else $('#modal-app-mensaje').find('.modal-app-spinner').addClass('d-none');

        // Escribimos los textos:
        $('#modal-app-mensaje').find('.titulo').text(this.titulo);
        $('#modal-app-mensaje').find('.mensaje').html(this.mensaje);
        $('#modal-app-mensaje').find('.btn-modal-cerrar').attr('data-tracker', this.mensaje.replace(/<.*?>/g, "")); // Para quitar todos los pares '<>' del texto, si los hay, para el tracker.
    }
};
// Evento clic en el botón 'Cerrar' (lo sacamos de la fn anterior para que no se creen varios eventos click en el mismo botón):
$('#modal-app-mensaje').find('.btn-modal-cerrar').on('click', function () {
    sessionStorage.setItem('i_btn_modal_cerrar', true);
})

/*  VERIFICA LA CONEXIÓN
    a internet. Útil cuando vamos a realizar un query a la BD:                  */
export function VerificarConexion() {
    if (navigator.onLine) {
        console.log("Verificando conexión: estado normal");
    } else {
        console.warn("Verificando conexión: no hay conexión");
        $('#modal-alerta-conexion').modal('show');    // Lanzamos el modal, declarado en /js/index.js
    }
}

/*  VERIFICA SI UN FILE O IMAGEN EXISTE                                         */
export async function File_existe(file_url) {
    try {
        const response = await fetch(file_url, { method: 'HEAD' });
        return response.status == 200;
    } catch (error) {
        console.warn("Error al validar archivo " + file_url + ": " + error)
        return false;
    }
}

/*  PREVIENE DOBLE-CLIC
    Ref: stackoverflow.com/questions/11621652
    Uso: $('#button').on('click', export function () {
            if (isDoubleClicked($(this))) return;
            ...                                                                 */
export function isDoubleClicked(element) {
    // Si el btn ya recibió un clic, return TRUE para indicar que este clic no se permitió:
    if (element.data("isclicked")) return true;

    // Lo deja marcado por 1 segundo:
    element.data("isclicked", true);
    setTimeout(function () { element.removeData("isclicked"); }, 1000);

    // Return FALSE para indicar que este clic fue permitido:
    return false;
}

/*  FORMATO CON COMAS
    Para dar formato a los números con separación de miles con comas.
    Si lleva signo, agregará '+' ó '-' según corresponda.
    Ej: ponerComas(100)  ... "100"
        ponerComas(1000) ... "1,000"                                                                
        ponerComas(Funeraria) ... "Funeraria"                                                       */
export function ponerComas(numero, signo = false) {
    if (parseInt(numero) > 0 || parseInt(numero) < 0) {
        let resultado = numero.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        if (signo) {
            if (signo == '+') {                 // Si signo es '+' agrega por fuerza el signo positivo:
                resultado = '+' + resultado;
            } else if (signo == '-') {          // Si signo es '-' agrega por fuerza el signo negativo:
                resultado = '-' + resultado;
            } else {                            // Si signo es '?' agrega signo según el valor del número (positivo o negativo):
                resultado = numero > 0 ? '+' + resultado : resultado;
            }
        }
        return resultado;
    } else {
        return "0.00";
    }
}

/*  Para ponerle un signo al inicio
    Uso: ponerSigno(10, '+')    --->  '+10'                                                         */
export function ponerSigno(numero, signo = false) {
    let resultado = parseInt(numero);
    if (parseInt(numero) > 0 || parseInt(numero) < 0) {
        if (signo) {
            if (signo == '+') {                 // Si signo es '+' agrega por fuerza el signo positivo:
                resultado = '+' + resultado;
            } else if (signo == '-') {          // Si signo es '-' agrega por fuerza el signo negativo:
                resultado = '-' + resultado;
            } else {                            // Si signo es '?' agrega signo según el valor del número (positivo o negativo):
                resultado = numero > 0 ? '+' + resultado : resultado;
            }
        }
    }
    return resultado;
}

/*  Para ponerle un icono según sea positivo o negativo
    Uso: signoIcono(10)    --->  '+10'                                                         */
export function signoIcono(numero, color_positivo = 'green') {
    let color_negativo = color_positivo == 'green' ? 'red' : 'green',
        resultado = '';

    // Establecemmos el color de los signos:
    color_positivo = color_positivo == 'green' ? 'text-success' : 'text-danger';
    color_negativo = color_negativo == 'green' ? 'text-success' : 'text-danger';

    // Establecemos el icono según el signo:
    resultado = numero > 0 ? '<i class="bi bi-arrow-up-short ' + color_positivo + '"></i>' : '<i class="bi bi-arrow-down-short ' + color_negativo + '"></i>';
    resultado = numero == 0 ? '<i class="bi bi-arrow-right-short"></i>' : resultado;

    return resultado;
}

/*  QUITAR LAS COMAS DE UN STRING
    para usar número en cálculo o en update
    Ej: "10,000"  -->  "10000"      en este caso "numero" es en realidad un string                  */
export function quitarComas(numero) {
    //numero_nuevo = numero.replace(/,/g, '');
    numero = numero + ' '; // Para convertirlo en string y así evitar error en el replace.
    // Quitamos todas las comas y todos los puntos:
    let numero_nuevo = (numero && numero.trim() != '') ? numero.replace(/,/g, '').replace(/\./g, '').trim() : 0;   
    return numero_nuevo;
}

/*  QUITAR LOS SLASH DE UN STRING
    Ej: "87654321 / 89765432"  -->  "87654321 89765432"                                             */
export function quitarSlash(frase) {
    //numero_nuevo = numero.replace(/,/g, '');
    let nueva_frase = frase.replace(/[/ ]+/g, ' ').trim();
    //.replaceAll('\\/','').trim();
    return nueva_frase;
}

/*  TRUNCAR FRASE 
    Trunca un string a los n caracteres, y le agrega un texto "add" al final, ej "..."
    Uso: frase_truncada = truncar(frase_original, 10);                                              */
export function truncar(frase, max, add = '') {
    let frase_truncada = (typeof frase === 'string' && frase.length > max ? frase.substring(0, max) + add : frase);
    return frase_truncada;
}

/* Saber si una frase contiene caracteres repetidos al menos n veces.
   Uso: let resultado = tieneCaracteresRepetidos('11111111', 6);
   resultado: true                                                                                 */
export const tieneCaracteresRepetidos = (frase, cuantos) => {
    const chars = {};
    for (const char of frase) {
        chars[char] = (chars[char] || 0) + 1;
    }
    let frase_array = Object.entries(chars).filter(char => char[1] >= cuantos).map(char => char[0]);
    return (frase_array.length > 0);
}

/* Saber si una frase contiene una secuancia numérica.
   Uso: tieneSecuenciaNumerica('1234567'); resultado: true
        tieneSecuenciaNumerica('1357912'); resultado: false                                       */
export function tieneSecuenciaNumerica(frase) {
    let pattern = '0123456789012345789';
    return !(pattern.indexOf(frase) == -1);
}

/* Saber si una frase es un isograma, es decir, si algún caracter se repite.
   Uso: let resultado = esIsograma('abca'); resultado: true
        let resultado = esIsograma('abcd'); resultado: false                                       */
export function esIsograma(str) {
    return /(.).*\1/.test(str);    // !/(.).*\1/.test(str);
}

/*  FORMATO 000000 (ZERO PADDING)
    Para dar formato a un número de contrato, con ceros delante.
    Ej: 3   ... "03"   (usando size = 2)    ... "003"   (usando size = 3)
        101 ... "101"  (usando size = 3)    ... "0101"  (usando size = 4)
    @ numero    Número que llega para transormar agregándole ceros
    @ size      Cantidad de caracteres                                                              */
export function ponerCeros(numero, size) {
    numero = numero ? numero.toString().trim() : 0;
    let ceros_numero = numero;
    if (numero.length < size) {
        while (ceros_numero.length < size) ceros_numero = "0" + ceros_numero;
        return ceros_numero;
    } else {
        return numero;
    }
}

/*  QUITAR CEROS AL INICIO
    Elimina los ceros al inicio de un string                                                        */
export function quitarCeros_inicio(numero) {
    numero = numero ? numero.toString().trim() : 0;
    numero = numero.replace(/^0+/, '');
    return numero;
}

/*  QUITAR TODOS LOS CEROS
    Elimina todos los ceros de un string                                                            */
export function quitarCeros_todos(frase) {
    return frase.replaceAll('0', '');
}

/*  QUITAR ÚLTIMOS 3 CARACTERES DE UNA PALABRA O FRASE
    para mostrar en pantalla. Ej:
    2019-05-01 00:00:00  -->  "2019-05-01 00:00"     (usando size = 3)                                                                 
    2019-05-01           -->  "2019-05"              (usando size = 3)
    @ frase    Frase para transormar quitándole caracteres al final
    @ size     Cantidad de caracteres a remover                                                     */
export function quitarChar(frase, size) {
    if (frase && frase != "") {
        let frase_nueva;
        if (!size) {
            size = 0;
        } else {
            size = (size * -1);
        }
        frase_nueva = frase.slice(0, size);
        return frase_nueva;
    } else {
        return;
    }
}

/*  DEVUELVE LOS PRIMEROS n CARACTERES DE UN STRING
    para mostrar en pantalla. Ej:
    "Pamela"  -->  "Pam"
    @ frase    Frase para transormar dejando los caracteres del inicio
    @ size     Cantidad de caracteres a conservar 
*/
export function primerosChar(frase, size) {
    if (frase) {
        let frase_nueva = frase.substring(0, size);
        return frase_nueva;
    } else {
        return;
    }
}

/*  DEVUELVE LOS ULTIMOS n CARACTERES DE UN STRING
    para mostrar en pantalla. Ej:
    "Pamela"  -->  "mela"                                               */
export function ultimosChar(frase, n) {
    if (frase) {
        let frase_nueva = frase.substr(frase.length - n);
        return frase_nueva;
    } else {
        return;
    }
}

/*  DEVUELVE EL ULTIMO CARACTER DE UN STRING
    para mostrar en pantalla. Ej:
    "Pamela"  -->  "a"
    @ frase    Frase para transormar dejando los caracteres del inicio
*/
export function ultimoChar(frase) {
    if (frase) {
        let u_char = frase[frase.length - 1];
        return u_char;
    } else {
        return;
    }
}

/*  QUITAR EL SEGUNDO APELLIDO
    para mostrar en pantalla. Ej:
    'Pamela Alfaro Araya'   --> 'Pamela Alfaro'                                                     */
export function quitar2doApellido(frase) {
    frase = frase ? frase.trim() : '';
    let palabras = frase.split(" ").length,
        lastIndex = frase.lastIndexOf(" "),
        frase_nueva = '';

    if (palabras > 1) {
        frase_nueva = frase.substring(0, lastIndex);
    } else {
        frase_nueva = frase;
    }

    return frase_nueva;
}

/*  QUITAR LOS APELLIDOS
    Deja solo el primer nombre
    para mostrar en pantalla. Ej:
    'Pamela Alfaro Araya'   --> 'Pamela'                                                            */
export function soloNombre(frase) {
    let nombre = frase && frase != "" ? frase.split(' ')[0] : '';
    return nombre;
}

/*  N. APELLIDO
    Deja solo la inicial del primer nombre y el primer apellido
    Ej: 'Pamela Alfaro Araya'   --> 'P. Alfaro'                                                     */
export function nApellido(frase) {
    frase = frase ? frase.trim() : '';
    let palabras = frase.split(' '),
        lastIndex = palabras.length - 1,
        nombre = frase[0] + '. ',
        apellido = palabras[lastIndex - 1],
        resultado = '';

    if (frase.includes('Oficina') || frase.includes('Sucursal')) resultado = 'Oficinas';    // Patch para algunos resultados.
    else resultado = lastIndex == 0 ? frase : nombre + apellido;    // Si no hay apellido, devuelve la frase completa; ej: 'BCR'

    return resultado;
}

/*  EXTRAER SOLO LOS NÚMEROS DE UNA PALABRA O FRASE
    para mostrar en pantalla. Ej:
    2019-05-01 00:00:00  -->  "201905010000"                                                                 
    id-12345             -->  "12345"
    @ frase    Frase para transormar dejando solamente los números                                  */
export const soloNumeros = frase =>
    String(frase).replace(/[^\d]+/g, '').trim();

/*  EXTRAER UNA PARTE DE UNA FRASE
    para mostrar en pantalla. Ej:
    "1 - Pamela Alfaro"  -->  "Pamela Alfaro"                                                                 
    @ frase    Frase para transformar dejando solamente los números                                 */
export function parteFrase(frase) {
    let resultado = '';
    if (frase && frase.length && frase.length > 0 && frase != '') {
        resultado = frase.split('-')[1].trim();
    }
    return resultado;
}

/*  SABER SI CHAR ES NÚMERO
    Uso: esNumero('1')
    Result: true (en caso contratio es false)                                                       */
export function esNumero(char) {
    let resultado = /^\d+$/.test(char);
    return resultado;
}

/*  SABER SI CHAR ES LETRA
    Uso: esLetra('a')
    Result: true (en caso contratio es false)                                                       */
export function esLetra(char) {
    let resultado = /^\d+$/.test(char);
    return !resultado;
}

/*  HACER MAYÚSCULA LA PRIMERA LETRA DE UNA FRASE
    para mostrar en pantalla. Ej:
    "un millón"  -->  "Un millón"                                                                 
    @ frase    Frase para transformar haciendo mayúscula su primera letra                           */
export function primeraMayuscula(frase) {
    let resultado = '';
    if (frase && frase.length && frase.length > 0 && frase != '') {
        resultado = frase[0].toUpperCase() + frase.slice(1);
    }
    return resultado;
}

/*  HACER MAYÚSCULAS LA PRIMERA LETRA DE CADA PALABRA
    Ej: "VLADIMIR PÉREZ"  --->  "Vladimir Pérez"                                                                 
    @ frase    Frase original que será transformada                                                 */
export function primerasMayusculas(frase) {
    let palabras_sin_cambio = ['de', 'en', 'el', 'y'],                                          // Palabras que no queremos tratar.
        splitFrase = frase[0].toUpperCase() + frase.slice(1).toLowerCase();                     // Primera letra mayúscula y el resto minúsculas.
    splitFrase = splitFrase.split(' ');                                                     // Para dividir la frase en palabras.
    for (let i = 0; i < splitFrase.length; i++) {                                               // Vamos repasando cada palabra por separado.
        if (!palabras_sin_cambio.includes(splitFrase[i])) {                                     // Si no es ninguna palabra que queremos excluir, lo hacemos.
            splitFrase[i] = splitFrase[i].charAt(0).toUpperCase() + splitFrase[i].substring(1); // Llevamos a mayúscula la primera letra de cada palabra.
        }
    }
    return splitFrase.join(' ');
}

/*  HACER MAYÚSCULA UNA FRASE
    para mostrar en pantalla. Ej:
    "un millón"  -->  "UN MILLÓN"                                                                 
    @ frase    Frase para transformar haciendo todo en mayúsculas                                   */
export function Mayusculas(frase) {
    let resultado = '';
    if (frase && frase.length && frase.length > 0 && frase != '') {
        frase.toUpperCase();
    }
    return resultado;
}

/*  COMPARA EL % DE SIMILITUD ENTRE DOS FRASE
    Uso: similarity('Stack Overflow','Stack Ovrflw') ---> returns 0.8571428571428571                
    Ref: stackoverflow.com/questions/10473745                                                       */
export function similarity(s1, s2) {
    let longer = s1;
    let shorter = s2;
    if (s1.length < s2.length) {
        longer = s2;
        shorter = s1;
    }
    let longerLength = longer.length;
    if (longerLength == 0) {
        return 1.0;
    }
    return (longerLength - editDistance(longer, shorter)) / parseFloat(longerLength);
}
export function editDistance(s1, s2) {
    s1 = s1.toLowerCase();
    s2 = s2.toLowerCase();

    let costs = new Array();
    for (let i = 0; i <= s1.length; i++) {
        let lastValue = i;
        for (let j = 0; j <= s2.length; j++) {
            if (i == 0)
                costs[j] = j;
            else {
                if (j > 0) {
                    let newValue = costs[j - 1];
                    if (s1.charAt(i - 1) != s2.charAt(j - 1))
                        newValue = Math.min(Math.min(newValue, lastValue),
                            costs[j]) + 1;
                    costs[j - 1] = lastValue;
                    lastValue = newValue;
                }
            }
        }
        if (i > 0)
            costs[s2.length] = lastValue;
    }
    return costs[s2.length];
}

/**
 * Calcula la edad a partir de la fecha de nacimiento hasta hoy (o hasta fecha2).
 * @param {string} fechaNacimiento - La fecha de nacimiento en formato de cadena.
 * @param {string} [fechaActual] - La fecha actual en formato de cadena (opcional).
 * @returns {string} La edad calculada con la unidad correspondiente.
 */
export function calcularEdad(fechaNacimiento, fechaActual) {
    const hoy = fechaActual ? new Date(fechaActual) : new Date();
    const fechaNac = new Date(fechaNacimiento);
    const unDiaEnMs = 1000 * 60 * 60 * 24;
    const unMesEnDias = 30.44;
    let edad = hoy.getFullYear() - fechaNac.getFullYear();
    const meses = hoy.getMonth() - fechaNac.getMonth();
    const esMismoMesYDia = meses === 0 && hoy.getDate() < fechaNac.getDate();
    const ajusteEdad = esMismoMesYDia ? -1 : meses < 0 ? -1 : 0;
    edad += ajusteEdad;
    if (edad < 1) {
        const dias = Math.floor((hoy - fechaNac) / unDiaEnMs);
        if (dias < 30) {
            return `${dias} días`;
        } else {
            const meses = Math.floor(dias / unMesEnDias);
            return `${meses} meses`;
        }
    } else {
        return `${edad} años`;
    }
}

export function esUltimoDiaDelMes() {
    const fechaActual = new Date();
    const ultimoDiaDelMes = new Date(fechaActual.getFullYear(), fechaActual.getMonth() + 1, 0);
    return fechaActual.getDate() === ultimoDiaDelMes.getDate();
}

export function esPenultimoDiaDelMes() {
    const fechaActual = new Date();
    const ultimoDiaDelMes = new Date(fechaActual.getFullYear(), fechaActual.getMonth() + 1, 0);
    const penultimoDiaDelMes = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), ultimoDiaDelMes.getDate() - 1);
    return fechaActual.getDate() === penultimoDiaDelMes.getDate();
}

/*  RANDOM INT ENTRE MIN Y MAX                                                                      */
export function getRandom(min, max) {
    return Math.random() * (max - min) + min;
}

/* Genera un hash aleatorio, para cualquier cosa
   Uso: mi_hash = getHash();                                                                        */
export function getHash() {
    let mi_hash = Math.random().toString(36).slice(2);
    return mi_hash;
}

/*  OBTIENE FECHA Y HORA DEL SISTEMA EN FORMATO "YYYY-MM-DD HH:mm:ss"
    es decir, a formato estandar internacional y MySQL                                               */
export function FechaHora() {
    let fechahora = new Date();                                                     // Fecha y hora del sistema
    fechahora.setHours(fechahora.getHours() - timezone_offset);              // Le restamos la diferencia (en CR son 6 horas) para hacerla hora local de CR
    fechahora = fechahora.toISOString().replace(/T/, ' ').replace(/\..+/, '');      // Convertimos a formato: YYYY-MM-DD HH:mm:ss
    return (fechahora);
}

/* Devuelve hora:minutos pm de una fecha dada */
export function Devuelve_hora_minutos(fecha) {
    fecha = new Date(fecha);
    let hora = fecha.getHours();
    let minutos = fecha.getMinutes();
    let ampm = hora >= 12 ? 'pm' : 'am';
    hora = hora % 12;
    hora = hora ? hora : 12; // the hour '0' should be '12'
    minutos = minutos < 10 ? '0' + minutos : minutos;
    let strTime = hora + ':' + minutos + ' ' + ampm;
    return strTime;
}

/*  HORA EN AM/PM                                                                                    */
export function Hora_ampm(hora) {
    let hora_hora = '',
        hora_minutos = '',
        hora_completa,
        am_pm = 'pm';

    try {
        hora_hora = parseInt(hora.split(':')[0].trim());
        hora_minutos = hora.split(':')[1].trim();
        if (hora_hora < 12) {
            am_pm = 'am'
        } else if (hora_hora > 12) {
            hora_hora = hora_hora - 12;
        }
        hora_completa = hora_hora + ':' + hora_minutos + ' ' + am_pm;
    } catch (err) {
        hora_completa = '';
    }
    return hora_completa;
}

/*  CANTIDAD DE DÍAS DESDE UNA FECHA"
    Uso: Dias_ago();                                                                                 */
export function Dias_ago(startDate) {
    startDate = new Date(startDate).toString('yyyy-MM-dd');
    let endDate = new Date().toString('yyyy-MM-dd'),
        timeDiff = (new Date(startDate)) - (new Date(endDate)),
        days = timeDiff / (1000 * 60 * 60 * 24);

    let resultado = isNaN(days) ? '?' : Math.abs(days);
    return resultado;
}

/* CAMBIA AL MES SIGUIENTE
   Ej: 2012-04-20 --> 2012-05-20                                                                    */
export function Cambia_a_mes_siguiente(fecha) {
    let nueva_fecha = '';
    try {
        let yyyy = fecha.split('-')[0].trim();
        let mm = fecha.split('-')[1].trim();
        let dd = fecha.split('-')[2].trim();
        let mes_siguiente = parseInt(mm) + 1;

        if (mes_siguiente == 13) {
            mes_siguiente = 1;
            yyyy = parseInt(yyyy) + 1;
        }

        nueva_fecha = yyyy + "-" + ponerCeros(mes_siguiente, 2) + "-" + dd;
    } catch (err) {
        nueva_fecha = '';
    }
    return nueva_fecha;
}

/* CAMBIA FECHA A MES ANTERIOR
Ej: 2012-04-20 --> 2012-03-20 */
export function Cambia_a_mes_anterior(fecha) {
    let nueva_fecha = '';
    try {
        let yyyy = fecha.split('-')[0].trim();
        let mm = fecha.split('-')[1].trim();
        let dd = fecha.split('-')[2].trim();
        let mes_anterior = parseInt(mm) - 1;

        if (mes_anterior == 0) {
            mes_anterior = 12;
            yyyy = parseInt(yyyy) - 1;
        }

        nueva_fecha = yyyy + "-" + ponerCeros(mes_anterior, 2) + "-" + dd;
    } catch (err) {
        nueva_fecha = '';
    }
    return nueva_fecha;
}

/* FIX 30 DE FEBRERO
Ej: 2025-02-30 --> 2025-02-28 */
export function Fix_30febrero(fecha) {
    let nueva_fecha = '';
    try {
        let yyyy = fecha.split('-')[0].trim();
        let mm = fecha.split('-')[1].trim();
        let dd = fecha.split('-')[2].trim();
        let ultimo_dia = new Date(yyyy, mm, 0).getDate();
        nueva_fecha = yyyy + "-" + mm + "-" + (dd > ultimo_dia ? ultimo_dia : dd);
    }
    catch (err) {
        nueva_fecha = '';
    }
    return nueva_fecha;
}

/*  TRATA LA FECHA Y LA DEVUELVE EN FORMATO MYSQL-DATE
    Ej:     20-04-2012      -->     2012-04-20   es decir, la convierte.
            2012-04-20      -->     2012-04-20   es decir, la deja tal cual             */
export function FechaMysql(fecha) {
    let nueva_fecha = '';
    if (fecha && fecha != '' & fecha != '0000-00-00') {
        fecha = fecha.trim();
        if (fecha.indexOf("-") > 2) {     // Si el dato llega en forma  'abr-2012' ó '2012-04-20' ...
            nueva_fecha = new Date(fecha).addHours(timezone_offset).toString('yyyy-MM-dd');
        } else {    // Si el dato llega en forma '20-04-2012' ...
            try { nueva_fecha = Fecha_yyyymmdd(fecha); } catch (err) { nueva_fecha = ''; }
        }
    }
    return nueva_fecha;
}

/* CONVIERTE FECHA EN FORMATO "YYYY-MM-DD HH:mm:ss"
   es decir, a formato estandar internacional para MySQL                                            */
export function Fecha_yyyymmddh(fecha) {
    fecha.setHours(fecha.getHours() + timezone_offset);                      // Le restamos 6 horas para hacerla hora local de CR
    let nueva_fecha = fecha.toISOString().replace(/T/, ' ').replace(/\..+/, '');    // Convertimos a formato: YYYY-MM-DD HH:mm:ss
    return (nueva_fecha);
}

/* CONVIERTE FECHA EN FORMATO "YYYY-MM-DD"
   es decir, a formato estandar internacional para MySQL                                            
   Ej:          20-04-2012      -->     2012-04-20                                                  */
export function Fecha_yyyymmdd(fecha) {
    let solo_fecha, 
        nueva_fecha = '';

    // Por si la fecha llega en forma '2012-04-20' o '2012-04-20 00:00:00':
    try {
        solo_fecha = fecha.split(' ')[0].trim() ? fecha.split(' ')[0].trim() : '0000-00-00' // Para dejar solo la fecha, sin hora. 
    // Por si la fecha llega en forma new(date):
    } catch (err) {
        console.warn("Catch @ Fecha_yyyymmdd");
        solo_fecha = fecha.toString('yyyy-MM-dd');
    }

    try {
        let A = solo_fecha.split('-')[0].trim(), // dd/yyyy
            B = solo_fecha.split('-')[1].trim(), // mm
            C = solo_fecha.split('-')[2].trim(); // yyyy/dd

        if (A.length == 4) {                                // Si la primera cifra tiene 4 char, comienza por el año.
            nueva_fecha = A + '-' + B + '-' + C;
        } else if (C.length == 4) {                          // Si la tercera cifra tiene 4 char, termina por el año.
            nueva_fecha = C + '-' + B + '-' + A;
        }
    } catch (err) { console.warn("Catch @ Fecha_yyyymmdd: " + err); }

    return nueva_fecha;
}
/*export function Fecha_yyyymmdd(fecha) {
    try { fecha = fecha.toString('dd-MM-yyyy'); } catch(err) { console.warn("Catch @ Fecha_yyyymmdd"); }
    let nueva_fecha = '';
    try {
        let dd = fecha.split('-')[0].trim();
        let mm = fecha.split('-')[1].trim();
        let yyyy = fecha.split('-')[2].trim();
        nueva_fecha = yyyy + "-" + mm + "-" + dd;
    } catch(err) {
        nueva_fecha = '';
    }
    return nueva_fecha;
}*/

/*  CONVIERTE FECHA EN FORMATO "DD-MM-YYYY HH:mm:ss"
    para escribir la fecha en pantalla y recibos                                                     
    Uso:    Fecha_ddmmyyyy(2012-04-20) -->  20-04-2012                                              */
export function Fecha_ddmmyyyy(fecha, con_hora=false, con_ampm=false) {
    let yyyymmdd = fecha.split(' ')[0].trim() ? fecha.split(' ')[0].trim() : '0000-00-00',
        hora, yyyy, mm, dd;

    yyyy = yyyymmdd.split('-')[0].trim();
    mm = yyyymmdd.split('-')[1].trim();
    dd = yyyymmdd.split('-')[2].trim();

    if (con_hora == true && con_ampm == true) {
        try {
            hora = fecha.split(' ')[1].trim() ? quitarChar(fecha.split(' ')[1].trim(), 3) : '00:00';
        } catch (err) {
            hora = '00:00';
        }
        hora = Hora_ampm(hora);
    }

    if (hora && hora != "" && con_hora == true) {
        hora = " " + hora;
    } else {
        hora = "";
    }

    return (dd + "-" + mm + "-" + yyyy + hora);
}

// Convierte fecha en yyyy-mm:
export function Fecha_yyyymm(fecha) {
    let yyyymmdd = fecha.split(' ')[0].trim() ? fecha.split(' ')[0].trim() : '0000-00-00',
        yyyy = yyyymmdd.split('-')[0].trim(),
        mm = yyyymmdd.split('-')[1].trim();

    return (yyyy + "-" + mm);
}

/*  CONVIERTE FECHA EN FORMATO "MMM-YYYY"
    para escribir la fecha en pantalla y recibos
    @extendido = true/false       -->    Enero/Ene                                                   
    Uso... fecha = '2019-04-01'   -->   'Abril-2019'                                               */
export function Fecha_mmmyyyy(fecha, extendido = false) {
    try { fecha = fecha.toString('yyyy-MM-dd'); } catch (err) { console.log("Catch @ Fecha_mmmyyyy"); }
    let yyyy = fecha.split('-')[0].trim(),
        mmm = parseInt(fecha.split('-')[1].trim());
    mmm = extendido ? en.MESES[mmm].mes : en.MESES[mmm].min;
    return (mmm + "-" + yyyy);
}

// Convierte fecha en formato "MMM":
export function Fecha_mes(fecha) {
    let mmm = parseInt(fecha.split('-')[1].trim());
    mmm = en.MESES[mmm].mes;
    return (mmm);
}

/*  CONVIERTE FECHA EN FORMATO "dd de MMM, YYYY"
    para escribir la fecha en pantalla y recibos
    @abreviado = true/false       -->    escribe la hora o no.
    Uso... fecha = '2019-04-20'   -->   '20 de abril, 2019'   
    ó... '2019-04-20 11:30:00'  -->  '20 de abril, 2019, 11:30 PM'  (to-do)                        */
export function Fecha_larga(fecha_argumento, con_hora, year_en_letras) {
    let resultado,
        fecha_larga,
        fecha = fecha_argumento.split(' ')[0].trim(),
        hora = fecha_argumento.split(' ')[1].trim(),
        yyyy = fecha.split('-')[0].trim(),
        dd = parseInt(fecha.split('-')[2].trim()),
        mmm = parseInt(fecha.split('-')[1].trim());
    mmm = en.MESES[mmm].mes;

    yyyy = year_en_letras ? numeroALetras(parseInt(yyyy)) : yyyy;
    fecha_larga = (dd + " de " + mmm + " de " + yyyy).toLowerCase();
    resultado = con_hora ? fecha_larga + ', ' + Hora_ampm(hora) : fecha_larga;
    return (resultado);
}

/*  CONVIERTE FECHA EN FORMATO "20 de abril 2019"
    para escribir la fecha en cierres y planillas                                               
    Uso: Fecha_extensa(2019-04-20)  --->  20 de abril 2019                                          */
export function Fecha_extensa(fecha_argumento) {
    let resultado;
    if (fecha_argumento != '-') {
        let fecha = fecha_argumento.split(' ')[0].trim(),
            yyyy = fecha.split('-')[0].trim(),
            dd = parseInt(fecha.split('-')[2].trim()),
            mmm = parseInt(fecha.split('-')[1].trim());
        mmm = en.MESES[mmm].mes;

        resultado = (dd + " de " + mmm + " " + yyyy).toLowerCase();
    } else {
        resultado = '?';
    }

    return (resultado);
}

/*  CONVIERTE FECHA EN FORMATO "20/abr"
    para escribir la fecha en calendario                                               
    Uso: Fecha_ddmmm(2019-04-20)  --->  20/abr                                                      */
export function Fecha_ddmmm(fecha_argumento) {
    let resultado;
    if (fecha_argumento != '-') {
        let fecha = fecha_argumento.split(' ')[0].trim(),
            dd = parseInt(fecha.split('-')[2].trim()),
            mmm = parseInt(fecha.split('-')[1].trim());
        mmm = en.MESES[mmm].min;

        resultado = (dd + "/" + mmm).toLowerCase();
    } else {
        resultado = '?';
    }

    return (resultado);
}

/*  EXTRAE SOLO LA HORA                                                                             */
export function Solo_hora(fecha_argumento) {
    let hora = fecha_argumento.split(' ')[1]; // .trim()
    return Hora_ampm(hora);
}

/*  DEVELVE LA DIFERENCIA ENTRE DOS FECHAS, EN D:H:M                                                 */
export function Tiempo_diff(startDate) {
    let antes = new Date(startDate),
        ahora = new Date(),
        diffMs = (antes - ahora),                                       // milisegundos entre antes y ahora.
        diffDays = Math.ceil(diffMs / 86400000),                        // días
        diffHrs = Math.ceil((diffMs % 86400000) / 3600000),             // horas
        diffMins = Math.ceil(((diffMs % 86400000) % 3600000) / 60000),  // minutos
        dias, horas, minutos, resultado = '';

    // Tratamos resultados:
    dias = diffDays < 0 ? diffDays == -1 ? Math.abs(diffDays) + ' día ' : Math.abs(diffDays) + ' días ' : '';
    horas = diffHrs < 0 ? diffHrs == -1 ? Math.abs(diffHrs) + ' hora ' : Math.abs(diffHrs) + ' horas ' : '';
    minutos = diffMins < 0 ? diffMins == -1 ? Math.abs(diffMins) + ' minuto' : Math.abs(diffMins) + ' minutos' : ' 0 minutos';
    if (Math.abs(diffMs) < 3600000 && diffMins >= 0) minutos = 'menos de 1 minuto';  // Si hace menos de 1 hora (3600000 ms).  
    resultado = dias + horas + minutos;

    return resultado;
}

/*  DEVUELVE LOS DÍAS DE DIFERENCIA ENTRE DOS FECHAS                                                */
export function Dias_diff(fecha1, fecha2) {
    let fecha_ini = new Date(fecha1),
        fecha_fin = new Date(fecha2),
        diffTime = Math.abs(fecha_fin - fecha_ini),                 // en milisegundos.
        diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));     // en días.

    return diffDays;
}

/*  CALCULA LOS MINUTOS:SEGUNDOS TRANSCURRIDOS ENTRE DOS TIEMPOS                                    */
export function Tiempo_transcurrido(tiempo_ini, tiempo_fin) {
    let seconds = (tiempo_fin - tiempo_ini) / 1000,
        minutos, segundos;

    minutos = Math.floor(seconds / 60);
    minutos = ponerCeros(minutos, 2);
    segundos = seconds - minutos * 60;
    segundos = Math.ceil(segundos);
    //segundos = ponerCeros(segundos, 2);

    //return minutos + ':' + segundos;
    return parseInt(segundos);
}

/*  CALCULA SEGUNDOS BRUTOS ENTRE DOS TIEMPOS                                    
    Ej: response = 1800 (quiere decir 1800 segundos transcurridos)                                  */
export function Segundos_transcurridos(tiempo_ini, tiempo_fin) {
    let t_ini = new Date(tiempo_ini),
        t_fin = new Date(tiempo_fin),
        seconds = (t_fin - t_ini) / 1000;
    return parseInt(seconds);
}

/*  Calcula los minutos transcurridos entre dos tiempos                                             */
export function Minutos_transcurridos(tiempo_ini, tiempo_fin) {
    let t_ini = new Date(tiempo_ini),
        t_fin = new Date(tiempo_fin),
        segundos = (t_fin - t_ini) / 1000,
        minutos = Math.floor(segundos / 60);
    return parseInt(minutos);
}

/*  CALCULA LA DIFERENCIA ENTRE DOS en.MESES 
    Uso: Meses_diferencia(mes_ini, mes_fin)   return (int)                                          */
export function Meses_diferencia(d1, d2) {
    return d2.getMonth() - d1.getMonth() + (12 * (d2.getFullYear() - d1.getFullYear()));
}

/*  SUMA n MESES A UNA FECHA DADA  
    Uso: sumaMeses(fecha_actual, cant_meses_a_sumar);                                                                 */
export function sumaMeses(dt, n) {
    return new Date(dt.setMonth(dt.getMonth() + n));      // Recordar que en el constructor 'Date' de js es un array de meses, es decir... 0=enero, 1=febrero, y sucesivamente. Por eso da la "apariencia" que el resultado es 1 mes menos.
}

/*  RESTA n MESES A UNA FECHA DADA  
    Uso: restaMeses(fecha_actual, cant_meses_a_restar);                                                                 */
export function restaMeses(dt, n) {
    return new Date(dt.setMonth(dt.getMonth() - n));      // Recordar que en el constructor 'Date' de js es un array de meses, es decir... 0=enero, 1=febrero, y sucesivamente. Por eso da la "apariencia" que el resultado es 1 mes menos.
}

/*  RESTA n DIAS A UNA FECHA DADA  
    Uso: restaDias(fecha_actual, cant_dias_a_restar);                                                                 */
export function restaDias(dt, n) {
    return new Date(dt.setDate(dt.getDate() - n));
}  

/*  SUMA n DIAS A UNA FECHA DADA  
    Uso: sumaDias(fecha_actual, cant_dias_a_restar);                                                                 */
export function sumaDias(dt, n) {
    return new Date(dt.setDate(dt.getDate() + n));
}

/*  ESPERAR N SEGUNDOS
    Usado en non-production                                                                     */
export const Segundos_delay = seg => new Promise(res => setTimeout(res, seg * 1000));

/*  TRAER EL ID (KEY) DE UN ENUM A PARTIR DE SU VALOR
    Usando una función para ello, no mutando el 'prototype'.
    Uso ... console.log("en.RECIBO_ESTATUS_Cancelado: " + getKey(en.RECIBO_ESTATUS, 'Cancelado'));    */
export function getKey(objeto, valor) {
    return Object.keys(objeto).find(key => objeto[key] === valor);
}

/*  CHECK SI UNA VARIABLE ES OBJECT O ARRAY
    Uso... esArray(variable)    Response = tru o false:                                         
           esObject(variable)                                                                   */
export const esArray = function (a) {
    return (!!a) && (a.constructor === Array);
};
export const esObject = function (a) {
    return (!!a) && (a.constructor === Object);
};

/*  ENCONTRAR EL MÍNIMO Y EL MÁXIMO VALOR DE UN KEY-VALUE DENTRO DE UN ARRAY
    Uso...  recibo_monto_menor = MinMax_array('min', recibos_array, 'Monto_recibo');            */
export function MinMax_array(mathFunc, array, property) {
    return Math[mathFunc].apply(array, array.map(function (item) {
        return item[property];
    }));
}

/*  QUITAR DUPLICADOS DE ARRAY, SEGÚN EL VALOR DUPLICADO QUE BUSCAMOS
    Por ej, si queremos quitar los items que tengan el mismo Contrato_id:
    Uso... nuevo_array = sin_duplicados_array(array, a => a.Contrato_id);                         
        Esta fn removerá el valor duplicado ya existente y conservará el último en llegar      
        Si deseamos conservar el valor ya existente y remover el último en llegar, 
        debemos usar "Set". Ref: stackoverflow.com/questions/9229645                            */
export function Sin_duplicados_array(array, key) {
    return [
        ...new Map(
            array.map(x => [key(x), x])
        ).values()
    ];
}

/* Quitar duplicados de un array de valores:
   Uso... nuevo_array = array.filter(Valores_unicos);                                            */
export function Valores_unicos(value, index, self) {
    return self.indexOf(value) === index;
}

/*  APPEND OBJ A UN ARRAY DE OBJS
    Para lograr que el array-de-obj mantenga su orden, tal como se van abregando elementos.
    Uso... newArray = appendObjTo(miArray, newObj)                                              */
export function appendObjTo(miArray, newObj) {
    const frozenObj = Object.freeze(newObj);
    return Object.freeze(miArray.concat(frozenObj));
}

/* Prepend valor a un array
   Uso... newArray = prependToArray(valor, mi_array)                                            */
export function prependToArray(valor, array) {
    let nuevo_array = array ? array.slice() : [];
    nuevo_array.unshift(valor);
    return nuevo_array;
}

/*  MOVER A POSICIÓN DENTRO DEL DOM
    Desplazarse hasta la posición de un elemento del dom.
    Uso: Mover_a_pos('#div-contrato-existente-resultados');                                     */
export function Vamos_a_pos(selector) {
    let $target = $(selector);
    $('html, body').animate({ scrollTop: $target.offset().top }, 100);
}

/*  CHECK SI UN ELEMENTO YA EXISTE EN EL DOM
    code de: stackoverflow.com/questions/16149431
    Uso: (puede ser un elemento cualquiera, ej: 'body')
    checkElementExists('div#tabla-clientes_filter').then((element) => {
        // Hacer lo que quiera ahora que el elemneto está allí...
        // ej: console.info(element);
    });                                                                                         */
function rafAsync() {
    return new Promise(resolve => {
        requestAnimationFrame(resolve); //faster than set time out
    });
}
export function checkElementExists(selector) {
    if (document.querySelector(selector) === null) {
        return rafAsync().then(() => checkElementExists(selector));
    } else {
        return Promise.resolve(true);
    }
}

/*  LIMPIAR LOS INPUTS DE FORM
    Uso: Limpiar_form('#div-element-id');                                                       */
export function Limpiar_form(selector, desabilitar=false) {
    console.log('Limpiando inputs dentro de ' + selector);

    try {
        $(':input', selector)
            .not(':radio, :button, :submit, :reset') // :hidden   ... también incluíamos los ocultos, pero entonces no lo hacía en los otros tabs del contrato.
            .prop('disabled', false)
            .prop('selected', false)
            .prop('checked', false)
            .val('');
        $(selector + ' > tbody > tr > td[contenteditable="true"]').text(''); // Para limpiar los <td> que son editables.
        if (desabilitar) Deshabilitar_form(selector); // Para deshabilitar los inputs.
    } catch (err) {
        console.log("...no lo hizo. Err: " + err);
    }
}

/*  DESHABILITAR FORM
    Uso: Desabilitar_form( $('#div-element') );                                                 */
export function Deshabilitar_form(selector) {
    console.log('Deshabilitando el form ' + selector);

    try {
        $(':input', selector)
            .not(':button, :submit, :reset, :hidden')
            .prop('disabled', true);
    } catch (err) {
        console.log("...no lo hizo. Err: " + err);
    }
}

/* HABILITAR FORM
    Uso: Habilitar_form( $('#div-element') );                                                     */
export function Habilitar_form(selector) {
    console.log('Habilitando el form ' + selector);

    try {
        $(':input', selector)
            .not(':button, :submit, :reset, :hidden')
            .prop('disabled', false);
    } catch (err) {
        console.log("...no lo hizo. Err: " + err);
    }
}

/*  CONTADOR CON ANIMACIÓN
    Uso: Contanimado('elemId', inicio, final, duracion)                                         */
export function Contanimado(id, start, end, duration) {
    start = start ? start : 0;
    end = end ? end : 100000;
    let range = end - start,
        current = start,
        increment = end > start ? 1 : -1,
        stepTime = Math.abs(Math.floor(duration / range)),
        obj = document.getElementById(id);

    if (obj && obj != '') {
        let timer = setInterval(function () {
            current += increment;
            obj.innerHTML = ponerComas(current);
            if (current == end) {
                clearInterval(timer);
            }
        }, stepTime);
    }
}

/*  AGRUPA UN ARRAY POR UN KEY-VALUE                                                            */
export function groupBy(xs, f) {
    return xs.reduce((r, v, i, a, k = f(v)) => ((r[k] || (r[k] = [])).push(v), r), {});
}


/*  GUARDA UN ARCHIVO HTML                                                           
    Uso: Guardar_file('test.txt', 'Hello world!');                                              */
export function Guardar_file(filename, text) {
    let pom = document.createElement('a');
    pom.setAttribute('href', 'data:text/html;charset=utf-8,' + encodeURIComponent(text));
    pom.setAttribute('download', filename);

    if (document.createEvent) {
        let event = document.createEvent('MouseEvents');
        event.initEvent('click', true, true);
        pom.dispatchEvent(event);
    }
    else {
        pom.click();
    }
}

/* Para efecto btn-neon temporal:
   Por ej, un btn de guardar adquiere temporalmente un efectode neon verde
   @boton: objeto <button> 
   @clase: class original que tiene el btn, para quitarla y volverla a poner al final           */
export function Efecto_neon_success(boton, clase) {
    let tiempo = 3000;  // tiempo en milisegundos para volver a la clase original.
    boton.blur();
    boton.removeClass(clase).addClass('btn-success efecto-neon-success');
    setTimeout(function () {
        boton.removeClass('btn-success efecto-neon-success').addClass(clase);
    }, tiempo);
}

/*  CONVERTIR NÚMEROS A LETRAS
    Código MIT de gist.github.com/alfchee/e563340276f89b22042a                              
    Modificado por Orlando Arteaga para este proyecto.                                          */
export let numeroALetras = (function () {

    function Unidades(num) {

        switch (num) {
            case 1:
                return 'un';
            case 2:
                return 'dos';
            case 3:
                return 'tres';
            case 4:
                return 'cuatro';
            case 5:
                return 'cinco';
            case 6:
                return 'seis';
            case 7:
                return 'siete';
            case 8:
                return 'ocho';
            case 9:
                return 'nueve';
        }

        return '';
    } //Unidades()

    function Decenas(num) {

        let decena = Math.floor(num / 10);
        let unidad = num - (decena * 10);

        switch (decena) {
            case 1:
                switch (unidad) {
                    case 0:
                        return 'diez';
                    case 1:
                        return 'once';
                    case 2:
                        return 'doce';
                    case 3:
                        return 'trece';
                    case 4:
                        return 'catorce';
                    case 5:
                        return 'quince';
                    default:
                        return 'dieci' + Unidades(unidad);
                }
            case 2:
                switch (unidad) {
                    case 0:
                        return 'veinte';
                    default:
                        return 'veinti' + Unidades(unidad);
                }
            case 3:
                return DecenasY('treinta', unidad);
            case 4:
                return DecenasY('cuarenta', unidad);
            case 5:
                return DecenasY('cincuenta', unidad);
            case 6:
                return DecenasY('sesenta', unidad);
            case 7:
                return DecenasY('setenta', unidad);
            case 8:
                return DecenasY('ochenta', unidad);
            case 9:
                return DecenasY('noventa', unidad);
            case 0:
                return Unidades(unidad);
        }
    } //Unidades()

    function DecenasY(strSin, numUnidades) {
        if (numUnidades > 0)
            return strSin + ' y ' + Unidades(numUnidades)

        return strSin;
    } //DecenasY()

    function Centenas(num) {
        let centenas = Math.floor(num / 100);
        let decenas = num - (centenas * 100);

        switch (centenas) {
            case 1:
                if (decenas > 0)
                    return ('ciento ' + Decenas(decenas)).trim();
                return 'cien';
            case 2:
                return ('doscientos ' + Decenas(decenas)).trim();
            case 3:
                return ('trescientos ' + Decenas(decenas)).trim();
            case 4:
                return ('cuatrocientos ' + Decenas(decenas)).trim();
            case 5:
                return ('quinientos ' + Decenas(decenas)).trim();
            case 6:
                return ('seiscientos ' + Decenas(decenas)).trim();
            case 7:
                return ('setecientos ' + Decenas(decenas)).trim();
            case 8:
                return ('ochocientos ' + Decenas(decenas)).trim();
            case 9:
                return ('novecientos ' + Decenas(decenas)).trim();
        }

        return Decenas(decenas).trim();
    } //Centenas()

    function Seccion(num, divisor, strSingular, strPlural) {
        let cientos = Math.floor(num / divisor)
        let resto = num - (cientos * divisor)

        let letras = '';

        if (cientos > 0)
            if (cientos > 1)
                letras = Centenas(cientos) + ' ' + strPlural;
            else
                letras = strSingular;

        if (resto > 0)
            letras += '';

        return letras.trim();
    } //Seccion()

    function Miles(num) {
        let divisor = 1000;
        let cientos = Math.floor(num / divisor)
        let resto = num - (cientos * divisor)

        //let strMiles = Seccion(num, divisor, 'un mil', 'mil');
        let strMiles = Seccion(num, divisor, 'mil', 'mil');
        let strCentenas = Centenas(resto);

        if (strMiles == '')
            return strCentenas.trim();

        return (strMiles + ' ' + strCentenas).trim();
    } //Miles()

    function Millones(num) {
        let divisor = 1000000;
        let cientos = Math.floor(num / divisor)
        let resto = num - (cientos * divisor)

        //let strMillones = Seccion(num, divisor, 'un millón de', 'millones de');
        let strMillones = Seccion(num, divisor, 'un millón', 'millones');
        let strMiles = Miles(resto);

        if (strMillones == '')
            return strMiles.trim();

        return (strMillones + ' ' + strMiles).trim();
    } //Millones()

    return function NumeroALetras(num, currency) {
        currency = currency || {};
        let data = {
            numero: num,
            enteros: Math.floor(num),
            centavos: (((Math.round(num * 100)) - (Math.floor(num) * 100))),
            letrasCentavos: '',
            letrasMonedaPlural: '',
            letrasMonedaSingular: '',
            letrasMonedaCentavoPlural: '',
            letrasMonedaCentavoSingular: ''
            /*letrasMonedaPlural: currency.plural || '    Colones',
            letrasMonedaSingular: currency.singular || 'Colón',
            letrasMonedaCentavoPlural: currency.centPlural || 'Céntimos',
            letrasMonedaCentavoSingular: currency.centSingular || 'Céntimo'*/
        };

        if (data.centavos > 0) {
            data.letrasCentavos = 'CON ' + (function () {
                if (data.centavos == 1)
                    return (Millones(data.centavos) + ' ' + data.letrasMonedaCentavoSingular).trim();
                else
                    return (Millones(data.centavos) + ' ' + data.letrasMonedaCentavoPlural).trim();
            })();
        }

        if (data.enteros == 0)
            return ('CERO ' + data.letrasMonedaPlural + ' ' + data.letrasCentavos).trim();
        if (data.enteros == 1)
            return (Millones(data.enteros) + ' ' + data.letrasMonedaSingular + ' ' + data.letrasCentavos).trim();
        else
            return (Millones(data.enteros) + ' ' + data.letrasMonedaPlural + ' ' + data.letrasCentavos).trim();
    };

})();

/*  EXPRESIONES Y SINTAXIS ÚTILES EN ESTE SISTEMA ---------------------------------------------------------------------

    Estructura básica del Ajax para este sistema:
        let console_leyenda = "MODULO - Proceso; actividad para el id " + dato_id;
        $.ajax({
            api: 'back-00_nombre_archivo'
            type: 'POST',
            data: {
                accion_etc_etc: 'true',
                dato_1: dato_1
            },
            dataType: 'json',
            beforeSend: function() {
                console.log(console_leyenda + " ...");
            },
            success: function(dataPHP){
                if(!$.trim(dataPHP) || !dataPHP.length || dataPHP == null || dataPHP == 'null' || dataPHP =='' || dataPHP.includes("error")) {
                    console.log(console_leyenda + ", sin resultados!");
                } else if (dataPHP == '0') {
                    console.log(console_leyenda + ", hubo un error");
                } else {
                    let resultados = JSON.parse(dataPHP);
                    console.log(console_leyenda + ": " + resultados);
                }
            }
        });

    Estructura de una fn promesa:
        function Nombre_de_la_fn(parametro_1) {
            return new Promise(function (resolve, reject) {
                // Código de la fn...
                .
                .
                .
                resolve(resultado_de_la_fn); // Es como un return, pero de una promise; ó:
                reject(error); // Si hay un error podemos rechazar la promesa y devolver un error
            } // del return new promise
        }

    Llamar a una fn promesa:
        Nombre_de_la_fn(parametro_1).then(function (resultado_de_la_fn) {
            if (resultado_de_la_fn) {
                //Código a ejecutar después de recibir el resultado...
            } else {
                console.log('Hubo un error en la fn');
            }
        });

    Para mostrar contenido de Array de forma amigable:
        JSON.stringify(arreglo_array, null, 4)

    Obtener solo un item específico de un obj en sessioStorage:
        let contrato_id = JSON.parse(sessionStorage.getItem('contrato_obj')).id

    Merge de dos objetos. Ej: 'recibo_info' + 'contrato_info':
        recibo_info = { ...recibo_info, ...contrato_info };        

    Línea horizontal bootstrap:
        <hr class="my-4">

    Div-to-div:
        <div class="div-to-div-wrapper">
            <div class="div-to-div-1 text-left" style="width:40%"></div>
            <div class="div-to-div-2 text-right" style="width:60%"></div>
        </div> // del div-wrapper

    Div in line:
        <div class="div-in-line">hola</div>
        <div class="div-in-line">hola</div>
        <div class="div-in-line">hola</div>
            CSS:
                .div-in-line {
                    width: 33%;
                    height: 10px;
                    background: gray;
                    cursor: pointer;
                    float:left;
                    margin:2px;
                }

    Para remover todo el contenido de una tabla:
        $("#tabla-id tr").remove();
    
    Igual al anterior, pero no remueve la primera fila (de encabezados):
        $('#tabla-id').find("tr:gt(0)").remove(); 

    Limpiando las opciones anteriores del Select, menos la primera:
        $('.select-class').find('option:not(:first)').remove();

    Enums:
        en.MESES[i];                --> 'Enero' (si i==1)
        ut.getKey(en.MESES,'Enero');   --> 1
    
    Lib:
        Datejs: github.com/datejs/Datejs
        LocalStorageDB: github.com/knadh/localStorageDB
        DataTables: datatables.net
    
    En html...
        Espacio: &nbsp;
        Bullet: &bull;
        Dash: &mdash;

    SessionStorage:
        sessionStorage.setItem('Primer_recibo_id', primer_recibo_id);   ó   sessionStorage.setItem('Primer_recibo_obj', JSON.stringify(primer_recibo_obj));
        sessionStorage.getItem('Primer_recibo_id');     ó       let Contrato = $.parseJSON(sessionStorage.getItem('c_Contrato_obj'));
        sessionStorage.removeItem('Primer_recibo_id'); 
        if (sessionStorage.getItem('Salida_info') === null) { ...

    Función anónima:
        (function() {
            .
            .
            .
        })();

    Rótulo "En desarrollo", que susamos en una página en proceso de dev:
        <span class="watermark" style="top:300px !important;">EN DESARROLLO</span>


*/
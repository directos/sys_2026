/*********************************************************************************
(C)2023 Orlando Arteaga & Shasling Pamela.
Fn para uso del token vía cookie.
*********************************************************************************/

/* Leemos una cookie por nombre                                                 
Uso: sys_token = getCookie('SYS_TOKEN');                                     */
export function getCookie(cname) {
    let name = cname + "=";
    let decodedCookie = decodeURIComponent(document.cookie);
    let ca = decodedCookie.split(';');
    for (let i = 0; i < ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) == ' ') { c = c.substring(1); }
        if (c.indexOf(name) == 0) { return c.substring(name.length, c.length); }
    }
    return null;
}

// Eliminar cookie:
export function delCookie(name) {
    document.cookie = name + '=; Path=/; Expires=Thu, 01 Jan 1970 00:00:01 GMT;';
}

// Validar token (y aprovechamos para guardar 'usuario' en localStorage):
export function validarToken(token_name) {
    const token = getCookie(token_name);
    let resultado = false;

    if (token) {
        // Decodificamos el token:
        const token_decoded = jwt_decode(token);

        // Si el token es válido:
        if (token_decoded.exp > parseInt(Date.now()) / 1000) {

            // Recabamos algunos detos del SO del usuario:
            const sistema_info = Sistema_info();
            
            // Actualizamos el obj:
            const USUARIO = {
                id: token_decoded.usuario_id,
                user: token_decoded.user,
                pila: token_decoded.pila,
                nombre: token_decoded.nombre,
                apellidos: token_decoded.apellidos,
                generoa: token_decoded.generoa,
                sabor: token_decoded.sabor,
                rol_principal: token_decoded.rol_principal,
                rol_dev: token_decoded.rol_dev,
                rol_admin: token_decoded.rol_admin,
                rol_gestor: token_decoded.rol_gestor,
                rol_gerente: token_decoded.rol_gerente,
                rol_supervisor: token_decoded.rol_supervisor,
                rol_agenda: token_decoded.rol_agenda,
                rol_amaster: token_decoded.rol_amaster,
                p_facturar: token_decoded.p_facturar,
                p_eliminar: token_decoded.p_eliminar,
                sucursal_id: token_decoded.sucursal_id,
                browser: sistema_info.browser_name + ' (' + sistema_info.browser_version + ' by ' + sistema_info.browser_vendor + ')',
                os: sistema_info.os_name + ' (' + sistema_info.os_version + ', ' + sistema_info.browser_platform + ')',
                screen: sistema_info.screen,
                mensaje: token_decoded.mensaje || '',
                version: token_decoded.version || '000',
                vista: token_decoded.vista,
                sys_habla: token_decoded.sys_habla == 0 ? false : true,
            }

            // Almacenamos data del USUARIO logeado:
            localStorage.setItem('USUARIO', JSON.stringify(USUARIO));
            //if (USUARIO.rol_supervisor == true) localStorage.setItem('Rol_supervisor', true); // OJO: Este permiso queda en el dispositivo, incluso si el supervisor se loguea con otro usuario después.
            console.log('USUARIO logueado con token:', USUARIO);
            return true;
        }
    }

    console.log('Token inválido');
    return resultado;
}

// Generar un token local, ambiente testing:
// Ref: stackoverflow.com/questions/67432096
export function generarToken(payload) {
    const mi_key = 'miLlaveSecretaParaSys#20120420!'
    const HMACSHA256 = (stringToSign, secret) => "not_implemented"
    const header = {
        "alg": "HS256",
        "typ": "JWT",
        //"kid": "token-de-prueba-en-ambiente-dev"
    }
    const encodedHeaders = btoa(JSON.stringify(header))
    const encodedPlayload = btoa(JSON.stringify(payload))
    const signature = HMACSHA256(`${encodedHeaders}.${encodedPlayload}`, mi_key)
    const encodedSignature = btoa(signature)
    const jwt = `${encodedHeaders}.${encodedPlayload}.${encodedSignature}`
    console.log({ jwt })
    return jwt;
}

// Recolecta info del sistema operativo, etc:
// Inspirado en medium.com/creative-technology-concepts-code/detect-device-browser-and-version-using-javascript-8b511906745, Kim T. 
function Sistema_info() {
  let module = {
      options: [],
      header: [navigator.platform, navigator.userAgent, navigator.appVersion, navigator.vendor, window.opera],
      dataos: [
          { name: 'Windows Phone', value: 'Windows Phone', version: 'OS' },
          { name: 'Windows', value: 'Win', version: 'NT' },
          { name: 'iPhone', value: 'iPhone', version: 'OS' },
          { name: 'iPad', value: 'iPad', version: 'OS' },
          { name: 'Kindle', value: 'Silk', version: 'Silk' },
          { name: 'Android', value: 'Android', version: 'Android' },
          { name: 'PlayBook', value: 'PlayBook', version: 'OS' },
          { name: 'BlackBerry', value: 'BlackBerry', version: '/' },
          { name: 'Macintosh', value: 'Mac', version: 'OS X' },
          { name: 'Linux', value: 'Linux', version: 'rv' },
          { name: 'Palm', value: 'Palm', version: 'PalmOS' }
      ],
      databrowser: [
          { name: 'Chrome', value: 'Chrome', version: 'Chrome' },
          { name: 'Firefox', value: 'Firefox', version: 'Firefox' },
          { name: 'Safari', value: 'Safari', version: 'Version' },
          { name: 'Internet Explorer', value: 'MSIE', version: 'MSIE' },
          { name: 'Opera', value: 'Opera', version: 'Opera' },
          { name: 'BlackBerry', value: 'CLDC', version: 'CLDC' },
          { name: 'Mozilla', value: 'Mozilla', version: 'Mozilla' }
      ],
      init: function () {
          let agent = this.header.join(' '),
              os = this.matchItem(agent, this.dataos),
              browser = this.matchItem(agent, this.databrowser);

          return { os: os, browser: browser };
      },
      matchItem: function (string, data) {
          let i = 0,
              j = 0,
              regex,
              regexv,
              match,
              matches,
              version;

          for (i = 0; i < data.length; i += 1) {
              regex = new RegExp(data[i].value, 'i');
              match = regex.test(string);
              if (match) {
                  regexv = new RegExp(data[i].version + '[- /:;]([\\d._]+)', 'i');
                  matches = string.match(regexv);
                  version = '';
                  if (matches) { if (matches[1]) { matches = matches[1]; } }
                  if (matches) {
                      matches = matches.split(/[._]+/);
                      for (j = 0; j < matches.length; j += 1) {
                          if (j === 0) {
                              version += matches[j] + '.';
                          } else {
                              version += matches[j];
                          }
                      }
                  } else {
                      version = '0';
                  }
                  return {
                      name: data[i].name,
                      version: parseFloat(version)
                  };
              }
          }
          return { name: 'unknown', version: 0 };
      }
  };

  let pc = module.init(),
      screenX = (window.innerWidth > 0) ? window.innerWidth : screen.width,
      screenY = (window.innerHeight > 0) ? window.innerHeight : screen.height;

  return {
      os_name: pc.os.name,
      os_version: pc.os.version,
      browser_name: pc.browser.name,
      browser_version: pc.browser.version,
      browser_agent: navigator.userAgent,
      browser_appversion: navigator.appVersion,
      browser_platform: navigator.platform,
      browser_vendor: navigator.vendor,
      screen: screenX + 'x' + screenY,
  };
}
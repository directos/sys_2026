/******************************************************************************
(C)2021 Orlando Arteaga & Shasling Pamela.
Aquí definimos los Enums globales para diferentes estatus, etc.
******************************************************************************/  

// El estatus de usuarios del sistema.
export const USUARIO_ESTATUS = {
    1: 'Activo',                            // Es un usuario que puede ingresar al Sys
    0: 'Inactivo'                           // El usuario no puede ingresar al Sys; su username queda en el histórico como referencia
};

// Los tipos de contrato. Están también en BD_Contratos_tipo.
export const CONTRATO_TIPO = {
    1: "Individual",                        // Es un contrato que cubre un servicio para una sola persona
    2: "Familiar",                          // Es un contrato que cubre varios servicios para una familia
    3: "Empresarial",                       // Es un contrato que cubre varios servicios para una empresa; no tiene un valor específico
    4: "Ahorro",                            // Es un contrato en el cual el cliente escogerá después producto(s) al precio de lista, cuando lo necesite 
    5: "Orden"                              // No es un contrato, sino una venta de contado o crédito (sustituye al antiguo 'apartado').
};

// El estatus de un contrato.
export const CONTRATO_ESTATUS = {
    //-1                                    Lo usamos para los contratos reservados como registros en la BD, esperando a ser llenados. No se muestra en buscar contratos. Su estatus siguiente será 'precontrato'.
    0: 'Nulo',                              // Es un contrato que no genera recibos, está "muerto"
    1: 'Precontrato',                       // Es un contrato firmado, pero que aun no ha pagado la totalidad de la prima
    2: 'Activo',                            // Es un contrato que genera recibos mensuales
    3: 'Liquidado',                         // Es un contrato que ya no está activo, porque el monto pagado fue usado para adquirir un nuevo contrato
    4: 'Cancelado',                         // Ya el monto total del contrato fue pagado, el saldo es 0
    5: 'Suspendido',                        // El cliente decide dejar de pagar sus cuotas mensuales por un tiempo. Está relacionado con la "fecha_de_reinicio"
    6: 'Incobrable'                         // Tiene una calificación "incobrable" (pero caso).
};

// La calificación del contrato:
export const CONTRATO_CALIFICACION = {
    0: 'Ninguna',                           // Aun no ha sido calificado.
    1: 'Positiva',                          // Tiene una calificación positiva (bandera verde).
    2: 'Negativa',                          // Tiene una calificación negativa (bandera roja).
};

// La condición de un contrato, según los productos.
export const CONTRATO_CONDICION = {
    //0: 'Reconocer monto',                 // En los contratos nulos se pierden los servicios que fueron contratados, pero se reconoce un % del monto ahorrado. PERO... esto no es un estatus, más bien es una regla del negocio!
    0: 'No-servido',                        // No se le ha servido aun ningún producto, tiene todos a su favor
    1: 'Servido parcial',                   // Se han servido algunos productos, otros aun están a favor del cliente
    2: 'Servido'                            // Ya todos los productos salieron (fueron entregados) al cliente, ya no hay productos a favor del cliente
};

// La condición de un contrato, según los productos.
export const CONTRATO_VERSION = {
    0: 'Estandar',                          // Versiones estándar, familiar, ahorro, y versiones anteriores a Sys (incluyendo los individuales anteriores a Sys).
    1: 'TSJ',                               // Los nuevos contratos individuales TSJ; (aplica para contratos_id mayor o igual a 6064).
    2: 'PZ'                                 // Los nuevos contratos individuales usados en la zona de Pérez Zeledón, tienen términos especiales para competir en la zona; (aplica para contratos_id mayor o igual a 6064).
};

// Términos que se usarán en los nuevos contratos:
export const CONTRATO_TERMINOS = {
    familiar:   'TRANSPORTE: Cubre los cantones de Osa, Golfito, San Vito de Coto Brus, Corredores, Buenos Aires, Pérez Zeledón. INCLUYE: arreglos florales, nota luctosa, placa conmemorativa, recordatorios, escolta, transporte.',
    individual: 'TRANSPORTE: Cubre los cantones de Osa, Golfito, San Vito de Coto Brus, Corredores, Buenos Aires, Pérez Zeledón. INCLUYE: arreglos florales, recordatorios, escolta, transporte (regalía por afiliación: transporte a San José).',
    ahorro:     'Incluye los productos y servicios al precio de lista que el cliente elija al momento de utilizarlos, hasta agotar el monto disponible en su contrato.',
    empresarial:'El transporte cubre desde el G.A.M. ó de los hospitales San Juan de Dios, Hospital México, Nacional de Niños, Calderón Guardia, hasta los Cantones de Pérez Zeledón, Buenos Aires, Osa, Golfito, Corredores y Coto Brus, hasta el lugar de velación con un kilometraje equivalente (800km) contemplados dentro del precio final.',
    //apartado:   'Incluye los productos y servicios seleccionados por el cliente en este contrato, todos al precio de lista al momento de utilizarlos, hasta agotar el valor del contrato.'
};

// El estatus de un recibo.
export const RECIBO_ESTATUS = {
    0: 'Nulo',                              // El recibo fue generado pero después "anulado", por alguna razón que debe explicarse en "Notas" de ese recibo
    1: 'Pendiente',                         // El recibo es válido y está pendiente de pago por parte del cliente 
    2: 'Cancelado'                          // El recibo ya fue pagado por el cliente, en su totalidad
};

// El tipo de recibo.
export const RECIBO_TIPO = {
    1: 'Prima',                             // El recibo es por la cuota de la prima. 
    2: 'Cuota',                             // El recibo es por una cuota mensual corriente.
    3: 'Salida',                            // El recibo es por una salida de productos correspondiente a un plan o contrato corriente.
    4: 'Extraordinario',                    // El recibo es por un concepto extraordinario, por ej: 'CCSS', etc. El detalle del recibo refleja el concepto.
    5: 'Liquidacion',                       // El recibo es por una liquidación de un contrato, en realidad no es dinero que ingresa sino que es trasladado de una cuenta a otra. El detalle del recibo refleja el concepto.
    6: 'Orden',                             // El recibo es por una orden (orden) por una venta de contado/crédito.
    7: 'Anulacion'                          // El recibo es por la multa de anulación del contrato, que ahora es 'nulo'.
};

// La condición de los servicios de funeral (o productos) contratados, desde el punto de vista del cliente.
export const SERVICIO_CONDICION = {
    0: 'pendiente a retirar',               // Es un servicio que el cliente aun tiene a su favor
    1: 'recibido',                          // Es un servicio que ya el cliente ha recibido 
};

// Productos para contrato (array):
export const CONTRATO_PRODUCTOS = {
    1: 'Servicio con ataúd de madera',
    2: 'Servicio con ataúd de peluche',
    13:'Servicio de cremación'
};

// Para los productos con entrega en la Salida (conforme a BD_Productos):
export const PRODUCTOS_ENUM = {
    8:  'Placa para bóveda',
    9:  'Recordatorios',
    10: 'Técnica de preservación',
    12: 'Escolta en sepelio',
    14: 'Transporte',
    15: 'Servicio ahorro',
    16: 'Factura electrónica'
};

// Usuarios especiales que usa el sistema:
export const USUARIO_ID = {
    0: 'Ninguno',                           // Hemos reservado el 0 para que no pueda usarse como usuario_id
    1: 'Sys',                               // El sistema propiamente tiene reservado el usuario 1
    2: 'Oficinas'                           // Oficinas centrales tiene usuario 2. (A partir del 3 comienzan los usuarios personales).
};

// El tipo de rubro de la planilla.
export const RUBRO_TIPO = {
    1: 'Deducción',                         // El rubro es una deducción. Ej: "CCSS". 
    2: 'Adicional',                         // El rubro es un adicional. Ej: "Servicio de chofer en sepelio".
    3: 'Préstamo',                          // El rubro es un préstamo hecho al empleado. Este irá siendo abonado por él deduciéndolo de su planilla.
    4: 'Abono',                             // Se usa para identificar los abonos a un préstamo otorgado al empleado.
    5: 'Sobrante'                           // Cuando en un Cierre diario hay un "sobrante" de dinero, el monto se le deduce al agente en la siguiente Planilla.
};

// Estatus de ventas:
export const ESTATUS_VENTAS = {
    0: 'noatendido',                        // No se ha visitado a este cliente en esta temporada.
    1: 'atendido',                          // El cliente ya ha sido atendido pro un vendedor, después de un sepelio.
    2: 'vendido',                           // Se logró hacer otra venta al cliente.
    3: 'nointeresado',                      // El cliente fué visitado, pero no compró por ahora.
    4: 'futuro',                            // El cliente está interesado en comprar, pero más adelante.
    5: 'pendiente'                          // El cliente está por ser visitado próximamente, en la fecha o 'promesa de visita' indicada.
};

// Tipos de gestión con código positivo:
/*export const _GESTION_TIPO = {
    1: 'Promesa',                           // La gestión es un apromesa de pago.
    2: 'Modifica-contrato',                 // La gestión es una modificación de datos del contrato.
    3: 'Reimpresion',                       // La gestión es una reimpresión de un recibo.
    66:'Retirarse',                         // Agente de cobro refiere que cliente desea retirarse.
    67:'Anular',                            // La gestión es una solicitud de anulación de contrato, por parte del vendedor.
    911:'Sos',                              // Es una solicituda de "sos".
};*/

// Tipos de gestión con código positivo:
export const GESTION_TIPO = {
    3:  'Reimpresion',                      // La gestión es una reimpresión de un recibo.
    11: 'Promesa',                          // La gestión es una promesa de pago.
    111:'Promesa',                          // La gestión es una promesa sinpe.
    13: 'Modifica-contrato',                // La gestión es una modificación de datos del contrato.
    16: 'Retirarse',                        // El cliente desea retirarse o anular contrato.
    19: 'Sos',                              // Es una solicituda de "sos".
};

// Tipos de documentos digitales del contrato:
export const DOCUMENTO_TIPO = {
    1: 'Contrato',                          // Contrato suscrito por el vendedor.
    2: 'Recibo provisional',                // Recibo provisional.
    3: 'Cédula',                            // Cédula del cliente.
    4: 'Hoja de salida',                    // Salida de servicio funerario.
    5: 'Letra de cambio',                   // Letra de cambio.
    6: 'Certificado defuncion',             // Certificado de defunción emitido por una autoridad.
    7: 'Factura',                           // Factura de venta, ej: emitida para la CCSS.
    8: 'Datos de Memorial',                 // Formulario que llena el cliente con los datos que llevará el recordatorio.
    9: 'Entrega',                           // Entrega de productos recibidos por el cliente (ej: placas, recordatorios).
    10:'Notificacion',                      // Notificación para el cliente (ej: suspensión de cobro a domicilio).
    11:'Boleta',                            // Boleta de retiro o renuncia al contrato de servicios.
    12:'Comprobante de pago',               // Boleta de retiro o renuncia al contrato de servicios.
    13:'Anexos al plan',                    // Anexos al contrato, usados para ampliar o modificar el plan, en casos específicos.
    99:'Otro',                              // Otro tipo de documento.
};

// Estatus de las campañas y envíos por WA:
export const ESTATUS_CAMPANAS = {
    0: 'Pendiente',                         // Campaña creada, pero no se ha enviado.
    1: 'Programado',                        // Campaña ya ha sido programada y está esperando la hora de inicio.
    2: 'Enviando',                          // Campaña iniciada, ya se está enviando.
    3: 'Pausado',                           // Campaña pausada por el usuario.
    4: 'Finalizado',                        // Campaña finalizada.
    5: 'Exitoso',                           // El envío a un contacto fue exitoso, según la api del proveedor.
    6: 'Fallido',                           // El envío a un contacto falló, según la api del proveedor.
    7: 'SinResult',                         // El envío a un contacto no obtuvo response desde la api del proveedor.
    8: 'FalloApi'                           // El envío a un contacto encontró que la api del proveedor está fallando (posibles causas: fallo en la conexión remota entre servers, falta de pago de la api, error en la api, etc).
};

// Las provincias de Costa Rica:
export const PROVINCIAS_CR = {
    1: 'San José',
    2: 'Alajuela',
    3: 'Cartago',
    4: 'Heredia',
    5: 'Guanacaste',
    6: 'Puntarenas',
    7: 'Limón'
};

// Los meses del año.
export const MESES = {
    1: {mes: "enero", min: "ene"},
    2: {mes: "febrero", min: "feb"},
    3: {mes: "marzo", min: "mar"},
    4: {mes: "abril", min: "abr"},
    5: {mes: "mayo", min: "may"},
    6: {mes: "junio", min: "jun"},
    7: {mes: "julio", min: "jul"},
    8: {mes: "agosto", min: "ago"},
    9: {mes: "septiembre", min: "sep"},
    10: {mes: "octubre", min: "oct"},
    11: {mes: "noviembre", min: "nov"},
    12: {mes: "diciembre", min: "dic"}
};

// Los bancos con convenio de internet-banking
export const BANCOS_CODE = {
    31:  'CISA',
    151: 'BN',
    152: 'BCR'
};

// Los tipos de caso de Soporte:
export const SOPORTE_ESTATUS = {
    0: 'Abierto',       // Aun no ha sido solucionado o corregido.
    1: 'Corregido',     // Cuando debió corregirse un error, u otro detalle en Sys.
    2: 'Solucionado',   // Cuando no se debía a un error en Sys, pero se solucionó de alguna forma (dentro o fuera de Sys).
    3: 'Duplicado'      // El caso es igual al reportado por otro usuario.
};

// Las razones por las que se otorga una acción a los clientes, durante el tiempo de promoción:
export const RAZONES_ACCIONES = {
    1: 'Pago puntual',      // El cliente pagó la cuota puntualmente, en la fecha del día_de_cobro.
    2: 'Prima cancelada',   // El cliente pagó la prima del contrato.
    3: 'Prima puntual',     // El cliente pagó la prima al momento de la suscripción del contrato.
    4: 'Por referido'      // El cliente refirió a un nuevo cliente, que suscribió un contrato.
};

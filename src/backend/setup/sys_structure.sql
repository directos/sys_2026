-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 28, 2025 at 02:19 AM
-- Server version: 10.6.21-MariaDB
-- PHP Version: 7.2.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `funera20_sys`
--

-- --------------------------------------------------------

--
-- Table structure for table `activos_evaluacion`
--

CREATE TABLE `activos_evaluacion` (
  `id` int(10) UNSIGNED NOT NULL,
  `fecha` date NOT NULL COMMENT 'Fecha de la evaluación',
  `agente_id` int(10) UNSIGNED NOT NULL COMMENT 'id del usuario (de la tabla Usuarios)',
  `puntaje` float UNSIGNED NOT NULL COMMENT 'Calificación puesta al agente',
  `notas` text NOT NULL COMMENT 'Notas sobre esta evaluación',
  `usuario_id` int(10) UNSIGNED NOT NULL COMMENT 'Es el usuario que hizo esta calificación',
  `fecha_sys` datetime NOT NULL COMMENT 'Es la fecha en que el usuario hizo esta calificación'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Evaluación sobre el cuidado de activos';

-- --------------------------------------------------------

--
-- Table structure for table `agendas_diarias`
--

CREATE TABLE `agendas_diarias` (
  `id` smallint(4) UNSIGNED NOT NULL,
  `fecha` date NOT NULL COMMENT 'Fecha de la agenda (yyyy-mm-dd)',
  `agente_id` smallint(4) UNSIGNED NOT NULL COMMENT 'Cobrador al que pertenece esta agenda diaria',
  `contratos_id` text DEFAULT NULL COMMENT 'Contratos que aparecen ahora en la agenda de este día',
  `contratos_id_original` text NOT NULL COMMENT 'Los valores que tenía la col Contratos_id insertada por el cron (centinela)',
  `cant_contratos` smallint(4) UNSIGNED NOT NULL COMMENT 'Cantidad de contratos que insertó el cron (centinela); es decir: la cantidad de Contratos_id_original',
  `prom_x_visita` int(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Es una estadística que calcula el tiempo en minutos del "promedio por visita" de cobro.',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora cuando Sys actualizó esta fila por última vez'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Contratos_id de la agenda diaria de cada cobrador';

-- --------------------------------------------------------

--
-- Table structure for table `agendas_permisos`
--

CREATE TABLE `agendas_permisos` (
  `agente_id` int(11) NOT NULL COMMENT 'Es el cobrador que verá otra agenda, y/o prestará sus clientes',
  `ver_a` int(11) NOT NULL DEFAULT 0 COMMENT 'Puede ver toda la agenda de este usuario_id',
  `prestar_a` int(11) NOT NULL DEFAULT 0 COMMENT 'Presta algunos clientes a este usuario_id',
  `dia_cobro` int(11) DEFAULT NULL COMMENT 'Es el día de cobro de los clientes que vamos a prestar',
  `dia_promesa` int(11) DEFAULT 0 COMMENT 'Prestaremos los clientes que tengan una promesa para este día del mes o después',
  `on_off` int(1) NOT NULL DEFAULT 0 COMMENT 'Encendido/apagado de estos permisos',
  `rango_libre` int(1) NOT NULL DEFAULT 0 COMMENT 'Permiso para usar rango en la agenda móvil. 0=limitado, 1=libre',
  `usuario_id` int(11) NOT NULL COMMENT 'Usuario que tramitó este permiso',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha en la que se tramitó este permiso'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Permisos en la agenda del cobrador (agente_id)';

-- --------------------------------------------------------

--
-- Table structure for table `banco_conta`
--

CREATE TABLE `banco_conta` (
  `id` int(11) NOT NULL,
  `banco` int(11) NOT NULL COMMENT 'id del Banco',
  `agencia` int(11) NOT NULL COMMENT 'id de la Agencia bancaria',
  `fecha` date NOT NULL COMMENT 'Fecha de las transacciones',
  `cantidad` int(11) NOT NULL COMMENT 'Cantidad de pagos percibidos',
  `monto_recuperado` int(11) NOT NULL COMMENT 'Monto total de pagos recibidos',
  `monto_comision` int(11) NOT NULL COMMENT 'Monto cobrado comisión del banco',
  `nota_credito` varchar(15) NOT NULL COMMENT 'Número de nota de crédito por las sumas recuperadas por el BN',
  `nota_debito` varchar(15) NOT NULL COMMENT 'Número de nota de débito por las comisiones',
  `cuenta_recuperado` varchar(25) NOT NULL COMMENT 'Cuenta bancaria de donde se depositaron los montos recuperados',
  `cuenta_comision` varchar(25) NOT NULL COMMENT 'Cuenta bancaria de donde tomaron las comisiones',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora del sistema cuando se inserta este registro'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Reporte diario del BN sobre monto recaudado del día';

-- --------------------------------------------------------

--
-- Table structure for table `cierres`
--

CREATE TABLE `cierres` (
  `id` int(10) NOT NULL,
  `agente_id` int(10) NOT NULL,
  `fecha` date NOT NULL COMMENT 'Fecha del cierre, día al que pertenece el cierre',
  `recaudado_hoy` int(10) NOT NULL DEFAULT 0 COMMENT 'Suma de todos los cobros realizados este día',
  `menos` int(10) NOT NULL DEFAULT 0 COMMENT 'Es la suma (o resta) de los gastos y vales',
  `menos_nocash` int(10) NOT NULL COMMENT 'Pagos con tarjeta, sinpe, etc',
  `menos_deposito` int(11) NOT NULL DEFAULT 0 COMMENT 'Depósito que el agente hace a la cuenta de la empresa',
  `menos_cheques` int(11) NOT NULL COMMENT 'Monto que el cliente pagó mediante cheque',
  `menos_efectivo` int(11) NOT NULL DEFAULT 0 COMMENT 'Es el monto entregado en oficinas por el cobrador',
  `menos_gasolina` int(10) NOT NULL DEFAULT 0 COMMENT 'Gasto por combustible, que la empresa reconoce al agente. Se usa también en la evaluación del gasto mensual en vehículos.',
  `menos_aceite` int(11) NOT NULL DEFAULT 0 COMMENT 'Gasto por cambio de aceite, que la empresa reconoce al agente. Se usa también en la evaluación del gasto mensual en vehículos.',
  `menos_repuestos` int(10) NOT NULL DEFAULT 0 COMMENT 'Gasto que la empresa reconoce al agente',
  `menos_viaticos` int(10) NOT NULL DEFAULT 0 COMMENT 'Gasto que la empresa reconoce al agente',
  `menos_vale_oficina` int(10) NOT NULL COMMENT 'Vales por gastos de oficina',
  `menos_vale_personal` int(10) NOT NULL DEFAULT 0 COMMENT 'Vales de dinero entregados al agente; este valor debe ser devuelto a la empresa por el agente',
  `total_cierre` int(10) NOT NULL DEFAULT 0 COMMENT 'Es el resultado del cierre. Lo ideal es que sea "0"',
  `_total_cierre` int(11) NOT NULL COMMENT 'Este era el valor original, antes de hacer el ajuste a valores negativos en el caso de Cierres con "Faltante"',
  `sobrante_nota` text NOT NULL COMMENT 'Son los comentarios que escribe un admin sobre el este sobrante que ha tramitado. (Si el campo está vacío, se considera que el sobrante no se ha tramitado aun)',
  `sobrante_tramitado_por` varchar(255) NOT NULL COMMENT 'Usuario_id y fecha en que tramitó este sobrante',
  `menos_nocash_notas` varchar(255) NOT NULL,
  `menos_deposito_notas` varchar(255) NOT NULL,
  `menos_cheques_notas` varchar(255) NOT NULL,
  `menos_efectivo_notas` varchar(255) NOT NULL,
  `menos_gasolina_notas` varchar(255) NOT NULL,
  `menos_aceite_notas` varchar(255) NOT NULL COMMENT 'Aquí anotamos datos como el kilometraje a la hora de cambiar el aceite',
  `menos_repuestos_notas` varchar(128) NOT NULL,
  `menos_viaticos_notas` varchar(255) NOT NULL,
  `menos_vale_oficina_notas` varchar(255) NOT NULL,
  `menos_vale_personal_notas` varchar(128) NOT NULL,
  `notas` text NOT NULL COMMENT 'Notas generales sobre este cierre',
  `recaudado_primas` int(11) NOT NULL DEFAULT 0 COMMENT 'Monto recaudado por concepto de primas',
  `menos_comision_primas` int(11) NOT NULL DEFAULT 0 COMMENT 'Comisión al cobrador por las primas cobradas',
  `menos_primas_notas` varchar(255) DEFAULT NULL,
  `comisionable` int(10) NOT NULL COMMENT 'Valor que se usará para el pago de comisiones, mediante planilla. (Comisionable es solamente recibos por "Cuota" (no "prima", no "salida")',
  `incidentes` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL COMMENT 'Anotaciones o reportes que hizo el agente durante este día',
  `metrica_cobrados_hoy` int(11) NOT NULL DEFAULT 0 COMMENT 'Clientes visitados hoy (cobrados)',
  `ultima_sincro` datetime DEFAULT NULL COMMENT 'Fecha y hora de la ultima sincronización',
  `faltante_backlog` int(11) NOT NULL COMMENT 'Si es -1 = No se encontró un backlog; Si es > 0 este es el monto faltante debido a una discrepancia con el Backlog en la agenda móvil.',
  `validacion_nocash` varchar(64) NOT NULL COMMENT 'Usuario_id y fecha en que fue validado el "no-cash" con el control cruzado con la cuenta bamcaria',
  `sucursal_id` int(10) NOT NULL DEFAULT 0 COMMENT 'En cual sucursal se tramitó este cierre diario',
  `planilla_id` int(10) DEFAULT NULL COMMENT 'En cual planilla_id se comisionó este cierre',
  `usuario_id` int(10) NOT NULL,
  `fecha_sys` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda todos los cierres diarios de todos los cobradores';

-- --------------------------------------------------------

--
-- Table structure for table `clientes`
--

CREATE TABLE `clientes` (
  `id` smallint(4) NOT NULL,
  `cedula` varchar(64) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellidos` varchar(255) NOT NULL,
  `contrato_id` smallint(4) NOT NULL COMMENT 'Es el contrato_id donde aparece como titular o lo fue',
  `titular_desde` date NOT NULL COMMENT 'Es la fecha desde la cual aparece como titular del contrato_id',
  `calificacion` tinyint(1) NOT NULL COMMENT 'Es la bandera de calificación crediticia que tiene el contrato',
  `notas` tinytext NOT NULL COMMENT 'Es una copia de las notas operativas del contrato donde aparece como titular',
  `fecha_sys` date NOT NULL COMMENT 'Fecha en la que se insertó este registro'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Clientes que aparecen como Titular de algún contrato(s)';

-- --------------------------------------------------------

--
-- Table structure for table `colores_sys`
--

CREATE TABLE `colores_sys` (
  `id` int(11) NOT NULL,
  `color` varchar(24) NOT NULL COMMENT 'Nombre del color',
  `css` varchar(24) NOT NULL COMMENT 'Código css del color',
  `css_texto` varchar(24) NOT NULL COMMENT 'Código del color del texto cuando el css se usa de fondo',
  `estatus` int(1) NOT NULL COMMENT '0=inactivo, 1=activo'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Array de colores predeterminados en Sys';

-- --------------------------------------------------------

--
-- Table structure for table `configuraciones`
--

CREATE TABLE `configuraciones` (
  `id` int(11) NOT NULL,
  `area` varchar(64) NOT NULL COMMENT 'Área de acción a la cual pertenece la variable',
  `variable` varchar(128) NOT NULL COMMENT 'Nombre de la variable en el código',
  `valor` varchar(255) NOT NULL COMMENT 'Es el valor actual de la variable global',
  `texto` varchar(128) NOT NULL COMMENT 'Texto del campo en el formulario',
  `descripcion` varchar(255) NOT NULL COMMENT 'Descripción de la variable para tooltips',
  `usuario_id` int(11) NOT NULL COMMENT 'Usuario que guardó esta configuración',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha en que esta variable fue modificada'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Valores de configuración de Sys';

-- --------------------------------------------------------

--
-- Table structure for table `contratos`
--

CREATE TABLE `contratos` (
  `id` smallint(5) UNSIGNED NOT NULL,
  `id_documento` varchar(255) NOT NULL COMMENT 'Consecutivo que viene en la hoja de contrato que usa el vendedor',
  `tipo_contrato` int(10) NOT NULL COMMENT '1=Individual, 2=Familiar, 3=Empresarial, 4=Ahorro, 5=Orden',
  `version` int(10) NOT NULL DEFAULT 0 COMMENT '2=PZ (versión Pérez Zeledón)',
  `estatus` int(10) NOT NULL DEFAULT 0 COMMENT '-1=Form, 0=Nulo, 1=Precontrato, 2=Activo, 3=Liquidado, 4=Cancelado, 5=Suspendido, 6=incobrable',
  `estatus_anterior` tinyint(1) DEFAULT NULL COMMENT '	Lo usamos para dejar constancia de cuál era el estatus de este contrato cuando se le aplique una liquidación. Esto se usa en los cálculos de liquidación',
  `candado` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'La gerencia usa esta bandera para bloquear la edición del contrato (cuando Candado = 1)',
  `permite_reimprimir` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Bandera para permitir que el agente pueda reimprimir un recibo de este contrato desde la agenda movil. 1 = Permitir',
  `valor_total` int(11) NOT NULL COMMENT 'Es el valor total del contrato. Ej: 1,000,000',
  `monto_ahorrado` int(11) NOT NULL COMMENT 'Es la suma de todas las cuotas pagadas hasta hoy',
  `saldo_a_hoy` int(11) NOT NULL COMMENT 'Saldo por cancelar del contrato, se actualiza una vez al día, mediante cron_jobs',
  `condicion` tinyint(1) UNSIGNED NOT NULL COMMENT '0=No servido; 1=Servido parcial; 2=Servido (total)',
  `fecha_generado` datetime NOT NULL COMMENT 'Fecha en la que se generó este contrato en la bd',
  `generado_por` smallint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Usuario_id quien generó este lote de contratos',
  `lote` mediumint(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Consecutivo de lote de contratos generado',
  `fecha_suscripcion` date NOT NULL COMMENT 'Fecha en que el cliente firma este contrato',
  `plan_enum` tinyint(1) UNSIGNED NOT NULL COMMENT 'Viene definido en BD_Planes, según el id',
  `plan_modificado_sn` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=no, 1=sí es "especial"; es decir, es un plan estandar que se ha modificado (en monto total, o en cuotas)',
  `cuotas_monto` int(10) NOT NULL COMMENT 'Es el monto de cada cuota mensual',
  `cuotas_monto_original` int(10) NOT NULL COMMENT 'Es el monto de las cuotas cuando se registró el contrato, aunque después cambie la cuota este valor quedará guardado',
  `cuotas_arreglo_monto` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Es el monto de las cuotas del arreglo de pago "por plazo", si existe.',
  `cuotas_arreglo_plazo` date NOT NULL COMMENT 'Es el mes en que las cuotas vuelven a la normalidad. Aplica a un arreglo de pago "por plazo", si existe.',
  `mes_inicial` date DEFAULT NULL COMMENT 'El primer recibo por ''cuota'' será generada en este mes (ej: 2019-04)',
  `dia_cobro` tinyint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Día de cobro: es el día del mes en que el cliente debe pagar la cuota. Ej: 10 (de cada mes)',
  `de_cuota_avanzada` tinyint(1) UNSIGNED NOT NULL COMMENT '0=No; 1=Es de cuota avanzada (útil para día "30")',
  `orden_ruta` smallint(5) NOT NULL DEFAULT 0 COMMENT 'Orden de ruta oficial, asignada por la oficina. 0 = sin agendar, -1000 = necesario enrutar',
  `orden_ruta_temp` smallint(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Orden de ruta temporal, asignada por el cobrador',
  `orden_ruta_intel` int(3) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Orden de ruta "inteligente". Puede ser calculada A) usando el algoritmo de googleAPI ($), o B) usando un algoritmo  euclidiano.',
  `terminos` text NOT NULL COMMENT 'Ej: "TRANSPORTE: Incluye hospitales de..."',
  `porcentaje_salida` int(10) NOT NULL COMMENT 'Porcentaje de salida: Es el % del saldo que el cliente acuerda pagar si necesitara usar el servicio antes de cancelar el monto total',
  `prima_monto` int(10) NOT NULL DEFAULT 0 COMMENT 'Es el monto de la prima. Ej: 20,000 (sualmente las 2 primeras cuotas)',
  `cant_servicios` int(10) NOT NULL COMMENT 'Cantidad de servicios contratados en este plan. Ej: 3',
  `titulares_historico` varchar(255) NOT NULL COMMENT 'Aquí guarda el histórico de titulares que ha tenido el contrato (cliente_id). Ej: 101, 269',
  `ultima_gestion_cobrador` varchar(255) DEFAULT NULL COMMENT '	Para guardar aquí la última gestión que hizo el cobrador en su agenda; es una copia de la fila de la tabla Gestiones',
  `ultimo_mes_facturado` date NOT NULL COMMENT 'Fecha del último recibo generado (esté o no pagado aun)',
  `historial_log` text NOT NULL COMMENT 'Para ir escribiendo algunos eventos de interés. Por ej: entra o sale de la agenda-master, etc.',
  `suspension_mes_reinicio` date NOT NULL COMMENT 'El cliente desea suspender el contrato (cobros) hasta el mes indicado',
  `cuotas_facturadas` int(10) NOT NULL DEFAULT 0 COMMENT 'Es la cantidad de cuotas que hangenerado recibos. Sirve para llevar el número de cuota indicada en el recibo',
  `cuotas_pagadas` int(10) NOT NULL DEFAULT 0 COMMENT 'Es la cantidad de cuotas que ya ha pagado el cliente al día de hoy',
  `ultimo_mes_pagado` date NOT NULL COMMENT 'Ej: "2019-04"   ... es decir, el cliente ha pagado sus cuotas hasta el mes de abril de 2019 (está al día)',
  `fecha_cancelacion` date NOT NULL COMMENT 'Fecha en que se canceló el valor del contrato',
  `vendedor_id` smallint(4) UNSIGNED NOT NULL COMMENT 'Vendedores.id',
  `cobrador_id` smallint(4) UNSIGNED NOT NULL COMMENT 'Cobradores.id',
  `cobrador_provisional` smallint(4) UNSIGNED NOT NULL COMMENT 'Cobrador que irá a cobrar el próximo pago, sustituyendo provisionalmente al cobrador "oficial"',
  `radar_id` smallint(4) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Este contrato está en el radar del usuario_id, quien le está dando seguimiento',
  `recordarle_a_cli` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1=encendido, 0=apagado',
  `recordarle_dias` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '	cant de días antes de la fecha de pago o promesa',
  `recordarle_fecha` date NOT NULL COMMENT '	Fecha en la que se le debe enviar un recordatorio al cliente',
  `promesa_de_pago` date NOT NULL COMMENT 'Día en que promete pagar su recibo pendiente (sea prima o cuota)',
  `promesa_por` varchar(64) NOT NULL COMMENT 'Indica cuál usuario puso la promesa y en qué fecha y hora',
  `promesa_cobrador` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Check. En precontratos, la promesa es asignada al: 0=vendedor, 1=cobrador',
  `registrado_por` varchar(255) DEFAULT NULL COMMENT 'Usuario_id que registra el contrato, y cuándo',
  `cli_cedula` varchar(64) NOT NULL,
  `cli_genero` varchar(1) DEFAULT NULL COMMENT 'M=masculino, F=femenino',
  `cli_nombre` varchar(255) NOT NULL,
  `cli_apellidos` varchar(255) NOT NULL,
  `cli_conocido` varchar(255) NOT NULL COMMENT 'Conocido como (C.C.)',
  `cli_nacimiento` date NOT NULL COMMENT 'Fecha de nacimiento del cliente',
  `cli_edad` varchar(16) NOT NULL,
  `cli_ocupacion` varchar(255) DEFAULT NULL,
  `cli_geolocation` varchar(255) DEFAULT NULL COMMENT 'Latitud y Longitud de la ubicación del cliente (Lat;Lon). Ej: 8.6469737;-82.94426930000002',
  `cli_direccion` varchar(255) NOT NULL,
  `cli_ciudad` varchar(255) DEFAULT NULL,
  `cli_provincia` varchar(255) DEFAULT NULL,
  `cli_postal` varchar(255) DEFAULT NULL,
  `cli_areacode` varchar(5) NOT NULL DEFAULT '506' COMMENT 'Código de área teléfono. Ej: 506 = Costa Rica',
  `cli_tel_celular` varchar(32) DEFAULT NULL,
  `cli_tel_habitacion` varchar(32) DEFAULT NULL,
  `cli_tel_trabajo` varchar(32) DEFAULT NULL,
  `cli_email` varchar(255) DEFAULT NULL,
  `cli_notas` text DEFAULT NULL,
  `cli2_cedula` varchar(64) DEFAULT NULL,
  `cli2_nombre` varchar(255) DEFAULT NULL,
  `cli2_apellidos` varchar(255) DEFAULT NULL,
  `cli2_nacimiento` date NOT NULL COMMENT 'Fecha nacimiento 2do titular',
  `cli2_edad` varchar(16) NOT NULL,
  `cli2_ocupacion` varchar(255) NOT NULL COMMENT 'Es la ocupación del segundo titular',
  `cli2_tel` varchar(32) DEFAULT NULL,
  `cli3_cedula` varchar(64) DEFAULT NULL,
  `cli3_nombre` varchar(255) DEFAULT NULL,
  `cli3_apellidos` varchar(255) DEFAULT NULL,
  `cli3_nacimiento` date NOT NULL,
  `cli3_edad` varchar(16) NOT NULL,
  `cli3_ocupacion` varchar(255) NOT NULL,
  `cli3_tel` varchar(32) DEFAULT NULL,
  `titular_fallecido` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Indica si el titular registrado en este contrato aparece como "fallecido" en el registro civil. Útil en los contratos nulos',
  `no_spam` tinyint(1) UNSIGNED NOT NULL COMMENT '1 = El cliente NO desea recibir mensajes de la empresa (ej: email, WhatsApp, etc)',
  `nota_importante` tinyint(1) UNSIGNED NOT NULL COMMENT '0 = normal, 1 = importante',
  `notas` text NOT NULL COMMENT 'Notas operativas',
  `nota_gestion` text NOT NULL COMMENT 'Notas de gestiones realizadas a este cliente',
  `nota_a_cobrador` varchar(255) NOT NULL COMMENT 'Es un aviso puesto en Desktop para que el cobrador lo vea al ver el contrato en su agenda',
  `bandera_calificacion` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1=buena, 2=mala. Es decir, el cobrador califica al clente como "bueno" o "malo", según su experiencia de pago puntual, etc. Está relacionado con el comentario que hizo sobre el cliente.',
  `notas_soporte` text NOT NULL COMMENT 'Notas del equipo de Soporte técnico',
  `prospecto_notas` varchar(255) NOT NULL,
  `prospecto_agente` smallint(4) UNSIGNED NOT NULL COMMENT 'Este es el vendedor_id que ha atendido últimamente a este prospecto',
  `es_irregular` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Son contratos que un admin identifica como "irregular", por ejemplo: un contrato activo que tiene muchas cuotas atrasadas',
  `no_adelantar` date NOT NULL DEFAULT '0000-00-00' COMMENT '0000-00-00 = apagado; 9999-12-31 = encendido indefinido; ej: 2023-04-01 = encendido hasta cuota de abril/2023',
  `sos` varchar(64) DEFAULT NULL COMMENT 'Solicitud de SOS. Cuando tiene un afecha = está encendido, fue activado en esa fecha',
  `anular` varchar(64) DEFAULT NULL COMMENT 'Ej: 7@2021-08-03 = el usuario 7 tramitó la anulación en el archivo de oficinas; si no tiene usuario_id es cuando el vendedor lo anuló y aun no ha sido tramitado en Oficinas',
  `actualizar` varchar(255) NOT NULL COMMENT 'Solicitud para actualizar datos de contacto del cliente. "solicitado@3@2021-01-02" = solicitud. "actualizado@12@..." = actualizado por el agente 12',
  `actualizado` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Para saber si debemos actualizarlo en la agenda de cobro (descargarlo). 0=no se ha actualizado en Sys, 1=Se ha actualizado en Sys (debe llevarse a la agenda)',
  `servicio_en_curso` mediumint(6) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = no tiene salida en curso; 2 = 1= tiene una Salida en curso; n = Salida_id en curso',
  `par_banco` tinyint(11) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=no afiliado; n=número del banco donde está afiliado al pago automático de recibos (PAR) ',
  `brief_agendado` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'El brief del cliente se verá en la agenda de ventas (0=No, 1=Sí)',
  `brief_impreso` varchar(255) DEFAULT NULL COMMENT 'Usuario_id que imprime el brief y cuándo',
  `ventas_com_prima` int(1) NOT NULL DEFAULT 0 COMMENT '0 = el vendedor no comisiona la prima, 1 = el vendedor sí comisiona la prima',
  `ventas_com_cuotas` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Este contrato comisiona n cuotas (base)',
  `ventas_com_extra` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Este contrato comisiona n cuotas extra cuando se sobrepasa la meta de ventas',
  `ventas_conteo_mes` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Este es el contrato número n vendido en el mes',
  `ventas_estatus` smallint(4) NOT NULL DEFAULT 0 COMMENT '0=No atendido, 1=Atendido, 2=Vendido, 3=No interesado, 4=Futuro (no se descarta que el cliente compre más adelante), 5=Promesa de visita (pendiente)	',
  `promesa_de_visita` date DEFAULT NULL COMMENT 'Fecha de promesa de visita al cliente. El vendedor y el cliente acuerdan cita para esta fecha',
  `eliminado` varchar(64) NOT NULL COMMENT 'Ej: 7@2021-05-18 quiere decir que el usuario 7 lo eliminó en esta fecha',
  `sucursal_id` smallint(4) UNSIGNED NOT NULL DEFAULT 1,
  `referido_por` varchar(64) NOT NULL COMMENT 'Cédula de la persona que refirió a este nuevo cliente',
  `usuario_id` smallint(4) UNSIGNED NOT NULL COMMENT 'Es el usuario_id del sistema que modificó este contrato',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora del sistema, cuando este contrato fue modicado',
  `mi_hash` varchar(128) DEFAULT NULL COMMENT 'Lo usamos para compartir el estado de cuentas, como medida adicional de seguridad en el link que se le envía al cliente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Todos los contratos de la empresa';

-- --------------------------------------------------------

--
-- Table structure for table `cpanel_cobro_diario`
--

CREATE TABLE `cpanel_cobro_diario` (
  `id` int(11) NOT NULL,
  `fecha` date NOT NULL COMMENT 'Es el día visto',
  `cobrador_id` int(11) NOT NULL COMMENT 'Es el agente cobrador',
  `monto_recaudado_hoy` mediumint(8) UNSIGNED NOT NULL COMMENT 'Monto total recaudado por el agente hoy',
  `monto_recaudado_acumulado` mediumint(8) UNSIGNED NOT NULL COMMENT 'Monto recaudado por el agente, acumulado en el mes',
  `contratos_cant` int(11) NOT NULL COMMENT 'Cantidad total de contratos en agenda de este día',
  `contratos_array` text NOT NULL COMMENT 'Listado de contratos en el total',
  `cobrados_cant` int(11) NOT NULL COMMENT 'Cantidad de contratos cobrados',
  `cobrados_xcien` int(11) NOT NULL COMMENT 'Porcentaje de contratos cobradoos',
  `cobrados_array` text NOT NULL COMMENT 'Listado de los contratos cobrados',
  `movidos_cant` int(11) NOT NULL COMMENT 'Cantidad de contratos movidos, es decir sin cobrar pero con una nueva promesa futura',
  `movidos_xcien` int(11) NOT NULL COMMENT 'Porcentaje de contratos movidos',
  `movidos_array` text NOT NULL COMMENT 'Listado de los contratos movidos',
  `omitidos_calc` int(11) NOT NULL COMMENT 'Omitidos_calc = Total - Cobrados - Movidos',
  `omitidos_cant` int(11) NOT NULL COMMENT 'Cantidad de contratos omitidos, es decir, sin gestionar este día',
  `omitidos_xcien` int(11) NOT NULL COMMENT 'Porcentaje de contratos omitidos',
  `omitidos_array` text NOT NULL COMMENT 'Listado de contratos omitidos'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Foto diaria del comportamiento del día anterior';

-- --------------------------------------------------------

--
-- Table structure for table `cpanel_cobro_morosos`
--

CREATE TABLE `cpanel_cobro_morosos` (
  `id` smallint(3) UNSIGNED NOT NULL,
  `fecha` date NOT NULL,
  `cobrador_id` smallint(4) UNSIGNED NOT NULL,
  `cant_clientes` int(4) UNSIGNED NOT NULL COMMENT 'Es la cantidad de clientes que tiene el cobrador en su cartera',
  `morosos_monto` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Monto en dinero que suman sus morosos',
  `morosos_xcien` float UNSIGNED NOT NULL COMMENT 'Porcentaje de clientes morosos',
  `morosos_cant` int(11) NOT NULL,
  `morosos_array` text NOT NULL,
  `este_mes_cant` int(11) NOT NULL,
  `este_mes_array` text NOT NULL,
  `prox_mes_cant` int(11) NOT NULL,
  `prox_mes_array` text NOT NULL,
  `sin_promesa_cant` int(11) NOT NULL,
  `sin_promesa_array` text NOT NULL,
  `con_1_cuota_cant` int(11) NOT NULL DEFAULT 0 COMMENT 'Los que tienen 1 cuota atrasada',
  `con_1_cuota_array` text NOT NULL,
  `con_2_cuotas_cant` int(11) NOT NULL DEFAULT 0 COMMENT 'Los que tienen 2 cuotas atrasadas',
  `con_2_cuotas_array` text NOT NULL,
  `con_1o2_cuotas_cant` int(11) NOT NULL,
  `con_1o2_cuotas_array` text NOT NULL,
  `con_mas2_cuotas_cant` int(11) NOT NULL,
  `con_mas2_cuotas_array` text NOT NULL,
  `cant_clientes_xirr` int(4) UNSIGNED NOT NULL COMMENT 'xIRR = sin "irregulares". Es decir, este valor no incluye los clientes marcados como "irregulares", para que no afecte la métrica del agente',
  `morosos_monto_xirr` int(10) UNSIGNED NOT NULL,
  `morosos_xcien_xirr` float UNSIGNED NOT NULL,
  `morosos_cant_xirr` int(11) NOT NULL,
  `morosos_array_xirr` text NOT NULL,
  `este_mes_cant_xirr` int(10) UNSIGNED NOT NULL,
  `este_mes_array_xirr` text NOT NULL,
  `prox_mes_cant_xirr` int(10) UNSIGNED NOT NULL,
  `prox_mes_array_xirr` text NOT NULL,
  `sin_promesa_cant_xirr` int(10) UNSIGNED NOT NULL,
  `sin_promesa_array_xirr` text NOT NULL,
  `con_1_cuota_cant_xirr` int(10) UNSIGNED NOT NULL,
  `con_1_cuota_array_xirr` text NOT NULL,
  `con_2_cuotas_cant_xirr` int(10) UNSIGNED NOT NULL,
  `con_2_cuotas_array_xirr` text NOT NULL,
  `con_1o2_cuotas_cant_xirr` int(10) UNSIGNED NOT NULL,
  `con_1o2_cuotas_array_xirr` text NOT NULL,
  `con_mas2_cuotas_cant_xirr` int(10) UNSIGNED NOT NULL,
  `con_mas2_cuotas_array_xirr` text NOT NULL,
  `sin_movimiento_cant` int(10) UNSIGNED NOT NULL COMMENT 'Cuántos clientes que aun no han tenido movimiento (pago) en lo que va de mes (xIRR)',
  `sin_movimiento_xcien` float UNSIGNED NOT NULL COMMENT 'Porcentaje de clientes sin movimiento, comparado con la cantidad de clientes activos del agente  (xIRR)',
  `sin_movimiento_array` text NOT NULL COMMENT 'Ids de los contratos sin movimiento  (xIRR)',
  `cuotas_canceladas_cant` smallint(5) UNSIGNED NOT NULL COMMENT 'Cuotas canceladas en el mes, comparado con la cant de clientes del agente',
  `cuotas_canceladas_xcien` float UNSIGNED NOT NULL COMMENT 'Porcentade de cuotas canceladas'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Índices diarios de morosidad por cobrador, al iniciar el día';

-- --------------------------------------------------------

--
-- Table structure for table `evaluaciones`
--

CREATE TABLE `evaluaciones` (
  `id` int(10) UNSIGNED NOT NULL,
  `fecha` date NOT NULL COMMENT 'Fecha de la evaluación',
  `agente_id` int(10) UNSIGNED NOT NULL COMMENT 'id del usuario (de la tabla Usuarios)',
  `activos` float UNSIGNED NOT NULL COMMENT 'Cuidado de activos (ej: moto)',
  `presentacion` float UNSIGNED NOT NULL COMMENT 'Presentación ante el cliente',
  `resolucion` float UNSIGNED NOT NULL COMMENT 'Resolución de problemas',
  `actualizacion` float UNSIGNED NOT NULL COMMENT 'Mantenimiento de datos actualizados',
  `notas` text NOT NULL COMMENT 'Notas sobre esta evaluación',
  `usuario_id` int(10) UNSIGNED NOT NULL COMMENT 'Es el usuario que hizo esta calificación',
  `fecha_sys` datetime NOT NULL COMMENT 'Es la fecha en que el usuario hizo esta calificación'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Evaluación de los agentes en el campo';

-- --------------------------------------------------------

--
-- Table structure for table `formacion`
--

CREATE TABLE `formacion` (
  `id` tinyint(4) NOT NULL COMMENT 'Puede usarse como el número de semana del año',
  `tema` varchar(255) NOT NULL COMMENT 'Es el tema del artículo',
  `filename` varchar(255) NOT NULL COMMENT 'Es el nombre del archivo del contenido. Ej: 47-abcd-efgh',
  `ref` char(255) NOT NULL COMMENT 'Es la referencia de donde fue tomado el contenido'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `gestiones_codigos`
--

CREATE TABLE `gestiones_codigos` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(128) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Códigos de las gestiones';

-- --------------------------------------------------------

--
-- Table structure for table `gestiones_promesas_ayer`
--

CREATE TABLE `gestiones_promesas_ayer` (
  `id` int(10) NOT NULL,
  `contrato_id` int(10) NOT NULL COMMENT 'id del contrato en BD Contratos',
  `id_documento` varchar(255) NOT NULL COMMENT 'Codigo del contrato impreso',
  `dia_cobro` int(2) NOT NULL COMMENT 'Día de cobro, según Contrato',
  `promesa_original` date NOT NULL COMMENT 'Promesa que tenía originalmente (debe ser la fecha de ayer))',
  `sucursal_id` int(4) NOT NULL DEFAULT 1 COMMENT 'Sucursal a la que pertenece el contrato'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Todos los contratos de la empresa';

-- --------------------------------------------------------

--
-- Table structure for table `gestiones_promesas_hoy`
--

CREATE TABLE `gestiones_promesas_hoy` (
  `id` int(10) NOT NULL,
  `contrato_id` int(10) NOT NULL COMMENT 'id del contrato en BD Contratos',
  `id_documento` varchar(255) NOT NULL COMMENT 'Codigo del contrato impreso',
  `dia_cobro` int(2) NOT NULL COMMENT 'Día de cobro, según Contrato',
  `promesa_original` date NOT NULL COMMENT 'Es la fecha de la promesa que tenía originalmente (debe ser la fecha de hoy)',
  `sucursal_id` int(4) NOT NULL DEFAULT 1 COMMENT 'Sucursal a la que pertenece el contrato'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Todos los contratos de la empresa';

-- --------------------------------------------------------

--
-- Table structure for table `gestiones_promesas_ven`
--

CREATE TABLE `gestiones_promesas_ven` (
  `id` int(10) NOT NULL,
  `contrato_id` int(10) NOT NULL COMMENT 'id del contrato en BD Contratos',
  `id_documento` varchar(255) NOT NULL COMMENT 'Consecutivo que viene en la hoja de contrato que usa el vendedor',
  `estatus` int(10) NOT NULL DEFAULT 0 COMMENT '-1=Form, 0=Nulo, 1=Precontrato, 2=Activo, 3=Liquidado, 4=Cancelado, 5=Suspendido',
  `dia_cobro` int(11) NOT NULL,
  `vendedor_id` int(10) NOT NULL COMMENT 'Vendedores.id',
  `cobrador_id` int(10) NOT NULL COMMENT 'Cobradores.id',
  `promesa_de_pagox` date NOT NULL COMMENT 'Día en que promete pagar su recibo pendiente (sea prima o cuota)',
  `promesa_de_pago` date NOT NULL,
  `promesa_cobrador` int(1) NOT NULL DEFAULT 0 COMMENT 'Check. En precontratos, la promesa es asignada al: 0=vendedor, 1=cobrador',
  `cli_nombre` varchar(255) NOT NULL,
  `cli_direccion` varchar(255) NOT NULL,
  `cli_telefonos` varchar(32) DEFAULT NULL,
  `sucursal_id` int(4) NOT NULL DEFAULT 1
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Todos los contratos de la empresa';

-- --------------------------------------------------------

--
-- Table structure for table `log_ibanking`
--

CREATE TABLE `log_ibanking` (
  `id` int(11) NOT NULL,
  `fecha` datetime NOT NULL COMMENT 'Fecha y hora de la transacción',
  `ip_address` varchar(64) NOT NULL COMMENT 'IP address del usuario. CISA=186.177.136.75',
  `operador` varchar(64) NOT NULL COMMENT 'Es la empresa que sirve de intermediario. Ej: ''Cisa''',
  `banco` int(11) NOT NULL COMMENT 'Es el banco que hace la transacción. Ej: 151=BCR',
  `metodo` varchar(12) DEFAULT NULL COMMENT 'GET o POST, etc',
  `request` text NOT NULL COMMENT 'Parámetros de entrada',
  `response` text NOT NULL COMMENT 'Parámetros de salida',
  `tstamp` varchar(24) NOT NULL COMMENT 'Time-stamp del response'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log_sys`
--

CREATE TABLE `log_sys` (
  `id` mediumint(7) UNSIGNED NOT NULL,
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora de este log',
  `usuario_id` smallint(4) NOT NULL DEFAULT 0 COMMENT 'El usuario que causó este log',
  `descripcion` text NOT NULL COMMENT 'Descripción más amplia de este log',
  `query` text DEFAULT NULL COMMENT 'Copia del query que se ejecutó en este evento',
  `codigo` enum('00','01','02','03','11','111','12','13','14','16','19') NOT NULL DEFAULT '00' COMMENT 'Es el código del log o la gestión. Ej: 00=genérico, 01=cobro, 02=reimpresión, 03=sincro',
  `visible_en` enum('0','1','2','3') NOT NULL DEFAULT '0' COMMENT '0=n/a; 1=debe verse en "Eventos del día" solamente, 2=debe verse en las "Gestiones del contrato" solamente; 3= debe verse en ambos (eventos y gestiones)',
  `contrato_id` mediumint(7) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Contrato_id al que pertenece la gestión o evento, si lo hay',
  `fecha_promesa` date NOT NULL COMMENT 'Fecha de la promesa del contrato, si es una promesa',
  `geolocation` varchar(36) NOT NULL DEFAULT '0' COMMENT 'Ubicación donde ocurrió este evento',
  `ip_address` varchar(15) NOT NULL DEFAULT '0' COMMENT 'Dirección IP de este evento',
  `tstamp` varchar(13) NOT NULL DEFAULT '0' COMMENT 'Timestamp de este log',
  `descripcion_min` varchar(128) NOT NULL COMMENT 'Sirve para que nos funcione el ADD UNIQUE INDEX en un campo CHAR porque no se puede hacer con un campo TEXT (como es de Descripcion)',
  `tabla_ref` enum('Gestiones','Log_sys') DEFAULT NULL COMMENT 'Tabla original de donde fue importado este registro',
  `id_ref` mediumint(6) UNSIGNED DEFAULT NULL COMMENT 'id que tenía en la tabla original'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Log del sistema, actividades de los usuarios en Sys';

-- --------------------------------------------------------

--
-- Table structure for table `log_version`
--

CREATE TABLE `log_version` (
  `id` smallint(4) UNSIGNED NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` text NOT NULL,
  `idea_de` varchar(64) NOT NULL COMMENT 'Reconocimiento a quien tuvo la idea de esta nueva característica',
  `ocultar` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 = Ocultar este item del listado en Inicio',
  `tachado` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 = El texto de la descripción aparecerá tachado. Por ejemplo, cuando el nuevo requerimiento haya sido descartado o porque su concepto original fue mal planteado y entonces reversamos el requerimiento.'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Lleva el log de versiones de Sys';

-- --------------------------------------------------------

--
-- Table structure for table `log_version_fechas_erroneas`
--

CREATE TABLE `log_version_fechas_erroneas` (
  `id` smallint(4) UNSIGNED NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` text NOT NULL,
  `idea_de` varchar(64) NOT NULL COMMENT 'Reconocimiento a quien tuvo la idea de esta nueva característica',
  `ocultar` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 = Ocultar este item del listado en Inicio',
  `tachado` tinyint(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '1 = El texto de la descripción aparecerá tachado. Por ejemplo, cuando el nuevo requerimiento haya sido descartado o porque su concepto original fue mal planteado y entonces reversamos el requerimiento.'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Lleva el log de versiones de Sys';

-- --------------------------------------------------------

--
-- Table structure for table `memorial`
--

CREATE TABLE `memorial` (
  `id` int(11) NOT NULL,
  `code` varchar(64) NOT NULL COMMENT 'Ej: 10BA',
  `estatus` tinyint(1) NOT NULL COMMENT '0=inactivo, 1=activo',
  `salida_id` int(11) DEFAULT NULL,
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `nacio` date DEFAULT NULL,
  `murio` date DEFAULT NULL,
  `bio` text DEFAULT NULL,
  `carrusel` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=Mostrar carrusel de fotos. 0=Ocultarlo',
  `video` varchar(255) DEFAULT '0' COMMENT 'Codigo del video en YouTube. Ej: https://youtu.be/ ---> EXGtm1FtYq8',
  `biblia_cita` varchar(512) DEFAULT NULL,
  `biblia_texto` varchar(64) DEFAULT NULL,
  `honras` text NOT NULL,
  `gracias` text DEFAULT NULL,
  `color` varchar(24) NOT NULL COMMENT 'Ej: cyan',
  `color_fondo` varchar(24) NOT NULL COMMENT 'Color del fondo del texto bíblico',
  `color_texto` varchar(24) NOT NULL COMMENT 'Color del font del texto bíblico',
  `font_size` varchar(24) NOT NULL COMMENT 'Tamaño de las letras del nombre. Ej: "display-3" (es una class de Bootstrap)',
  `sucursal_id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL COMMENT 'Usuario que crea o modifica este perfil',
  `fecha_sys` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda el perfil del falecido para la web';

-- --------------------------------------------------------

--
-- Table structure for table `metadata`
--

CREATE TABLE `metadata` (
  `id` int(10) UNSIGNED NOT NULL,
  `fecha_sys` datetime NOT NULL,
  `usuario_id` tinyint(3) UNSIGNED NOT NULL,
  `metadata` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Datos internos para Soporte, enviado desde los dispositivos';

-- --------------------------------------------------------

--
-- Table structure for table `ordenes`
--

CREATE TABLE `ordenes` (
  `id` int(11) NOT NULL,
  `fecha` datetime NOT NULL COMMENT 'Fecha de la proforma',
  `contrato_id` int(11) NOT NULL COMMENT 'id del contrato al que pertenece esta proforma',
  `descuento` int(11) NOT NULL DEFAULT 0 COMMENT 'Monto del descuento, si aplica. 0 = no tiene descuento',
  `impuestos_sn` int(1) NOT NULL COMMENT 'Incluye impuestos (s/n)',
  `registrado_por` varchar(128) NOT NULL COMMENT 'Usuario_id que registra el contrato, y cuándo. Ej: 3@2020-07-01 13:45',
  `usuario_id` int(11) NOT NULL COMMENT 'Usuario que creó esta proforma',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha de creación de esta proforma'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Proformas de ventas de contado';

-- --------------------------------------------------------

--
-- Table structure for table `planes`
--

CREATE TABLE `planes` (
  `enum` int(10) NOT NULL,
  `tipo_plan` varchar(64) NOT NULL COMMENT 'Ej: "AH" (ahorro), ó "F" (familiar). Este campo sirve para ordenar con ORDER BY cuando se desplieguen los planes disponibles',
  `tipo_plan_enum` int(10) NOT NULL COMMENT 'Es igual a Tipo_contrato_enum. Ej 1=individual, 2=familiar, etc.',
  `orden` int(11) NOT NULL COMMENT 'Es un orden para el listado de las opciones del tipo de plan',
  `descripcion_plan` varchar(255) NOT NULL COMMENT 'Ej: "El plan de Ahorro no tiene asociados productos específicos, sino que el cliente ..."',
  `valor_total` int(10) NOT NULL COMMENT 'Ej: 1500000',
  `cant_servicios` int(1) NOT NULL DEFAULT 1 COMMENT '	Es la cantidad de servicios o ataudes que tiene este plan',
  `cuotas_monto` int(10) NOT NULL COMMENT 'Ej: 15000',
  `cuotas_cantidad` int(10) NOT NULL COMMENT 'Ej: 100',
  `porcentaje_de_salida` int(64) NOT NULL COMMENT 'Es el % del saldo que el cliente acuerda pagar si necesitara usar el servicio antes de cancelar el monto total',
  `terminos_plan` text NOT NULL COMMENT 'Ej: TRANSPORTE: Cubre los hospitales de Ciudad Neily, Golfito, San Vito ...',
  `disponible_sn` int(1) NOT NULL COMMENT 'S/N ... 0=no usar, no disponible en nuevos contratos; 1=usar, disponible en nuevos contratos. Este campo sirve cuando se muestren los planes disponibles',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora del sistema, cuando se creó este plan'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Son los planes que se comercializan mediante los contratos';

-- --------------------------------------------------------

--
-- Table structure for table `planillas`
--

CREATE TABLE `planillas` (
  `id` int(10) NOT NULL,
  `agente_id` int(10) NOT NULL COMMENT 'Usuario_id del agente a quien pertenece esta planilla',
  `_rol` varchar(64) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'Ej: ''Cobrador'' ó ''Vendedor''',
  `comisiones_monto` int(10) NOT NULL DEFAULT 0 COMMENT 'Es la suma de las comisiones del agente en esta ocasión',
  `adicionales_monto` int(10) NOT NULL DEFAULT 0 COMMENT 'Suma de los rubros por ''adicionales'' del empleado',
  `deducciones_monto` int(10) NOT NULL DEFAULT 0 COMMENT 'Total de los rubros por deducciones',
  `a_pagar` int(10) NOT NULL DEFAULT 0 COMMENT 'Monto a pagar en la planilla (comisiones menos deducciones)',
  `fecha_anterior` datetime NOT NULL COMMENT 'Fecha de la planilla anterior de este agente',
  `sucursal_id` int(10) NOT NULL COMMENT 'Sucursal_id en la que se tramitó esta planilla',
  `usuario_id` int(10) NOT NULL COMMENT 'Es el usuario admin que tramitó esta planilla',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora cuando se tramitó esta planilla'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda las planillas ya pagadas a los agentes';

-- --------------------------------------------------------

--
-- Table structure for table `planillas_aguinaldos`
--

CREATE TABLE `planillas_aguinaldos` (
  `id` int(10) NOT NULL,
  `periodo` int(11) NOT NULL COMMENT 'Año o período; ej: 2020',
  `empleado_id` int(11) NOT NULL COMMENT 'id del empleado que recibe este aguinaldo',
  `suma_ingresos` int(11) NOT NULL COMMENT 'Es la suma de los ingresos obtenidos por el empleado desde diciembre anterior hasta noviembre de este año',
  `a_pagar` int(11) NOT NULL COMMENT 'Monto del aguinaldo a pagar al empleado',
  `sucursal_id` int(11) NOT NULL COMMENT 'Sucursal que tramita este aguinaldo',
  `usuario_id` int(11) NOT NULL COMMENT 'id del usuario de Sys que tramita este aguinaldo',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora de este trámite'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda los datos clave de los aguinados tramitados';

-- --------------------------------------------------------

--
-- Table structure for table `planillas_aguinaldos_row`
--

CREATE TABLE `planillas_aguinaldos_row` (
  `id` int(11) NOT NULL,
  `aguinaldo_id` int(11) NOT NULL COMMENT 'id del aguinaldo al que corresponde este detalle',
  `meses` date NOT NULL COMMENT 'Mes incluido en el aguinaldo; ej: 2020-11',
  `montos` int(11) NOT NULL COMMENT 'Monto de ingreso de ese mes; ej: 450,000'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Meses incluidos en el aguinaldo, con sus montos';

-- --------------------------------------------------------

--
-- Table structure for table `planillas_row`
--

CREATE TABLE `planillas_row` (
  `id` int(11) NOT NULL,
  `planilla_id` int(10) NOT NULL COMMENT 'Planilla a que pertenece este item',
  `contrato` varchar(32) NOT NULL COMMENT 'Contrato a que pertenece este item',
  `documento` int(10) NOT NULL COMMENT 'Cierre_id o Recibo_id asociado a este item',
  `tipo` varchar(32) NOT NULL COMMENT 'Cuota o Cierre diario, según el ron de vendedor o cobrador',
  `fecha` date NOT NULL COMMENT 'Fecha del documento',
  `comisionable` int(10) NOT NULL COMMENT 'Monto comisionable de este item',
  `comision` int(10) NOT NULL COMMENT 'Monto de la comisión por este item',
  `tasa` int(10) NOT NULL COMMENT 'Porcentaje de comisión. Ej: 10% de la cuota para el cobrador; 50% de la cuota 1-3 para el vendedor '
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `planillas_rubros`
--

CREATE TABLE `planillas_rubros` (
  `id` int(10) NOT NULL,
  `fecha` datetime NOT NULL COMMENT 'Fecha del rubro',
  `agente_id` int(10) NOT NULL,
  `descripcion` varchar(255) NOT NULL COMMENT 'Descripción del rubro',
  `monto` int(10) NOT NULL COMMENT 'Monto del rubro',
  `tipo` int(1) NOT NULL COMMENT '1=Deducción, 2=Adicional, 3=Préstamo, 4=Abono a préstamo',
  `prestamo_saldo` int(11) NOT NULL COMMENT 'Es el saldo que falta por pagar por parte del empleado',
  `_prestamo_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Es el id del préstamo, si aplica',
  `salida_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Es el id de la Salida a la que corresponde este rubro, si aplica',
  `servicio_enum` int(2) NOT NULL DEFAULT 0 COMMENT 'Es igual que "producto_enum", para identificarlo en una salida, si aplica',
  `cierre_id` int(11) NOT NULL COMMENT 'Cierre en el que se incluyó este rubro (ej: vale personal)',
  `planilla_id` int(10) NOT NULL COMMENT 'Planilla en la que se incluyó este rubro',
  `sucursal_id` int(10) NOT NULL,
  `usuario_id` int(10) NOT NULL COMMENT 'Usuario de Sys que creó este rubro',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha de creación del rubro en Sys'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Rubros (deducciones o adicionales) a incluir en planilla';

-- --------------------------------------------------------

--
-- Table structure for table `planillas_vacaciones`
--

CREATE TABLE `planillas_vacaciones` (
  `id` int(10) NOT NULL,
  `periodo_ini` varchar(7) NOT NULL COMMENT 'Mes de inicio para cálculo vacaciones. Ej: ''2020-06''',
  `periodo_fin` varchar(7) NOT NULL COMMENT 'Mes final para cálculo vacaciones. Ej: ''2020-12''',
  `empleado_id` int(11) NOT NULL COMMENT 'id del empleado que recibe este aguinaldo',
  `suma_ingresos` int(11) NOT NULL COMMENT 'Es la suma de los ingresos obtenidos por el empleado desde diciembre anterior hasta noviembre de este año',
  `prom_mensual` int(11) NOT NULL COMMENT 'Promedio mensual de los meses del período: Suma_ingresos / cant de meses',
  `a_pagar` int(11) NOT NULL COMMENT 'Monto del aguinaldo a pagar al empleado',
  `sucursal_id` int(11) NOT NULL COMMENT 'Sucursal que tramita este aguinaldo',
  `usuario_id` int(11) NOT NULL COMMENT 'id del usuario de Sys que tramita este aguinaldo',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora de este trámite'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda los datos clave de los aguinados tramitados';

-- --------------------------------------------------------

--
-- Table structure for table `planillas_vacaciones_row`
--

CREATE TABLE `planillas_vacaciones_row` (
  `id` int(11) NOT NULL,
  `vacaciones_id` int(11) NOT NULL COMMENT 'id de las vacaciones al que corresponde este detalle',
  `meses` date NOT NULL COMMENT 'Mes incluido en el aguinaldo; ej: 2020-11',
  `montos` int(11) NOT NULL COMMENT 'Monto de ingreso de ese mes; ej: 450,000'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Meses incluidos en el aguinaldo, con sus montos';

-- --------------------------------------------------------

--
-- Table structure for table `productos`
--

CREATE TABLE `productos` (
  `enum` int(10) NOT NULL,
  `codigo` varchar(64) NOT NULL COMMENT 'Es el codigo de lista del producto. Ej: "M-101"',
  `nombre` varchar(64) NOT NULL,
  `descripcion` text NOT NULL,
  `precio` int(11) NOT NULL,
  `notas` text NOT NULL,
  `disponible_sn` int(1) NOT NULL COMMENT 'S/N ... 0=no usar, no disponible; 1=se puede comercializar, esté o no por defecto dentro de los contratos',
  `usar_en_contratos_sn` int(1) NOT NULL COMMENT '0=No, 1=Si. Es decir, aparecerá en el listado de productos disponible en los nuevos contratos',
  `usar_en_ordenes_sn` int(11) NOT NULL DEFAULT 1 COMMENT '0=No, 1=Sí se usa este producto en ventas de contado (proformas)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Listado de productos y precios';

-- --------------------------------------------------------

--
-- Table structure for table `productos_de_inventario`
--

CREATE TABLE `productos_de_inventario` (
  `enum` tinyint(3) UNSIGNED NOT NULL COMMENT 'Producto_enum correspondiente',
  `descripcion` varchar(128) NOT NULL COMMENT 'Descripción del producto. Ej: "Ataud 20, largo interior 47 cm"',
  `cant_minima` int(2) UNSIGNED NOT NULL COMMENT 'Es la cantidad mínima que debe haber en existencia en el inventario de cada sucursal',
  `usar` tinyint(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Usamos o no este producto. Ej: 0=no, 1=sí. Es decir: es posible que ya no usemos un producto antiguo, y ya no lo mostraremos en las opciones para una nueva Salida.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Sos los productos que la empresa maneja en inventario';

-- --------------------------------------------------------

--
-- Table structure for table `productos_en_inventario`
--

CREATE TABLE `productos_en_inventario` (
  `id` int(11) NOT NULL,
  `producto_enum` tinyint(3) NOT NULL COMMENT 'id en la tabla Productos_de_inventario',
  `sucursal_id` tinyint(4) NOT NULL COMMENT 'A cuál sucursal perteneces',
  `fecha_ingreso` datetime NOT NULL COMMENT 'Fecha en que el producto ingresó en inventario',
  `por_usuario` int(10) NOT NULL COMMENT 'Usuario que ingresó este producto unitario en inventario',
  `salida_id` int(10) NOT NULL COMMENT 'Salida_id donde fue usado este producto unitario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Son los productos en existencia, en cada sucursal';

-- --------------------------------------------------------

--
-- Table structure for table `productos_row`
--

CREATE TABLE `productos_row` (
  `id` int(10) NOT NULL COMMENT 'Cada row es un producto con cantidad 1. Es decir, si son 3 ataud de madera, entonces en esta tabla se crean 3 rows, una por cada ataud de madera. Esto facilitará llevar el control de salidas en esta misma tabla, para cada item individual',
  `contrato_id` int(10) NOT NULL COMMENT 'A cuál contrato pertenece este producto',
  `orden_id` int(11) NOT NULL DEFAULT 0 COMMENT 'id de la Proforma de venta de contado',
  `salida_id` int(10) DEFAULT NULL COMMENT 'Es la Salida_id que respalda la salida de este producto a favor del cliente. Si aun no hay una Salida_id quiere decir que el producto aun no se ha entregado',
  `producto_enum` int(10) NOT NULL COMMENT 'Productos.id',
  `producto_nombre` varchar(255) NOT NULL COMMENT 'EJ: "Ataúd de madera"',
  `producto_descripcion` varchar(255) NOT NULL COMMENT 'Descripción del producto según su id',
  `precio` int(11) NOT NULL COMMENT 'Precio del producto en la proforma',
  `notas` text DEFAULT NULL COMMENT 'Notas adicionales, campo abierto',
  `recibido_por` varchar(255) DEFAULT NULL COMMENT 'Nombre del cliente, quien recibe el producto',
  `fechayhora_de_salida` datetime DEFAULT NULL COMMENT 'Es la fecha y hora en que este producto es entregado al cliente, mediante el proceso de Salidas. Si hay una "salida_id" pero no hay yna "Fechayhora_de_salida" para este producto, quiere decir que este producto está pendiente de entregar.  Por ejemplo, una placa estará lista para entregar aprox 1 mes después del sepelio; esa placa debe aparecer como "Pendiente" de entregar al cliente que ya la está esperando.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda los productos que pertenecen a un contrato';

-- --------------------------------------------------------

--
-- Table structure for table `promos_acciones`
--

CREATE TABLE `promos_acciones` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` tinytext NOT NULL COMMENT 'Es el código de la acción, ej "2C73H". Se calcula por el cobro_id + razon_id + mes_cuota. (Debemos usar estas tres variables porque un mismo cobro puede ser por varias cuotas).',
  `accionista_ced` varchar(64) NOT NULL COMMENT 'Cédula del dueño de esta acción',
  `razon_id` tinyint(3) UNSIGNED NOT NULL COMMENT '1=cuota puntual, 2=prima cancelada, 3=prima puntual, 4=referido',
  `fecha_sys` datetime NOT NULL COMMENT 'Cuándo se incluyó este registro',
  `fecha_del_pago` date NOT NULL COMMENT 'Fecha del pago del recibo',
  `fecha_limite` date NOT NULL COMMENT 'Fecha límite para pago puntual del recibo (aplica para cuotas, no para primas)',
  `cobro_id` int(11) UNSIGNED NOT NULL COMMENT 'Es el cobro_id que provocó esta acción',
  `recibo_id` int(10) UNSIGNED NOT NULL COMMENT 'Es el recibo_id que provocó esta acción. Lo usamos para ubicar a simple vista cuál contrato pertenece',
  `contrato_id` int(10) UNSIGNED NOT NULL COMMENT 'Contrato_id del recibo cancelado',
  `contrato_doc` varchar(24) NOT NULL COMMENT 'id_documento del contrato',
  `cuota_mes` date NOT NULL COMMENT 'A cual mes pertenece la cuota de esta acción',
  `notas` varchar(255) NOT NULL COMMENT 'Observaciones (opcional)',
  `es_valida` tinyint(3) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0=no, 1=sí es válida la acción',
  `promo_id` tinyint(3) UNSIGNED NOT NULL COMMENT 'id de la promo, corresponde a la table Promos_id'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Registro de las acciones que van ganando los participantes';

-- --------------------------------------------------------

--
-- Table structure for table `promos_ganadores`
--

CREATE TABLE `promos_ganadores` (
  `id` int(10) UNSIGNED NOT NULL,
  `accion_id` int(10) UNSIGNED NOT NULL COMMENT 'Es el id de la acción, tomada de Promo_acciones',
  `accion_code` varchar(64) NOT NULL COMMENT 'Es el código de la acción, tomada de Promo_acciones. Es como un control cruzado id/code',
  `accionista_ced` varchar(64) NOT NULL COMMENT 'Cédula del cliente ganador de esta acción',
  `usuario_id` int(4) UNSIGNED NOT NULL COMMENT 'Qué usuario generó a este ganador',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora en que se generó a este ganador',
  `promo_id` int(10) UNSIGNED NOT NULL COMMENT 'El el id de la promo a la que pertenece el ganador, tomada de Promos_id'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Acciones ganadoras de la promo';

-- --------------------------------------------------------

--
-- Table structure for table `promos_id`
--

CREATE TABLE `promos_id` (
  `id` tinyint(3) UNSIGNED NOT NULL COMMENT 'id de la promo',
  `nombre` varchar(255) NOT NULL COMMENT 'Nombre de la promo',
  `fecha_ini` date NOT NULL COMMENT 'Fecha de inicio de la promo',
  `fecha_fin` date NOT NULL COMMENT 'Fecha de finalización de la promo',
  `ganadores_cant` int(2) NOT NULL COMMENT 'Cuántos ganadores deben ser seleccionados al final de la promo'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Promociones lanzadas, su nombre y período';

-- --------------------------------------------------------

--
-- Table structure for table `promos_referidos`
--

CREATE TABLE `promos_referidos` (
  `id` int(11) NOT NULL,
  `fecha_sys` datetime NOT NULL COMMENT 'Cuándo se incluyó este registro',
  `referido_por` varchar(64) NOT NULL COMMENT 'Cédula del que lo refirió',
  `referido_nombre` varchar(255) NOT NULL COMMENT 'Nombre y apellidos del referido',
  `referido_tel` varchar(32) NOT NULL COMMENT 'Teléfono del referido',
  `promo_id` tinyint(3) UNSIGNED NOT NULL COMMENT 'id de la promo, según tabla Promos_id'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Los referidos y referentes de la promo';

-- --------------------------------------------------------

--
-- Table structure for table `recibos`
--

CREATE TABLE `recibos` (
  `id` int(10) NOT NULL COMMENT 'Este es el consecutivo de los recibos; aparece en el recibo impreso como número de consecutivo',
  `id_provisional_agenda` varchar(16) DEFAULT NULL COMMENT 'Este es el número provisional del recibo generado en la agenda móvil',
  `tipo_recibo` int(1) NOT NULL COMMENT '1=Prima, 2=Cuota, 3=Salida, 4=Extraordinario, 5=Liquidación, 6=Orden',
  `contrato_id` int(10) NOT NULL DEFAULT 0 COMMENT 'Contratos.id; de cual contrato se deriva este recibo',
  `cobrador_id` int(10) NOT NULL COMMENT 'Usuarios.id del usuario que cobró este recibo',
  `estatus` int(1) DEFAULT NULL COMMENT '0=Anulado (ej: contrato en papelera), 1=Pendiente, 2=Pagado (cancelado). Está definido en Enums.js',
  `fecha_cancelacion` datetime DEFAULT NULL COMMENT 'Es la fecha en que el cliente canceló este recibo',
  `fecha_impresion` datetime DEFAULT NULL COMMENT 'Es la fecha en la que se envió a imprimir este recibo, por última vez',
  `fecha_limite` date NOT NULL COMMENT 'Es la fecha en la que debe pagarse este recibo, según el día de pago acordado del contrato',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora del Sys, cuando se creó o generó este recibo',
  `dia_cobro` int(10) NOT NULL COMMENT 'Idem ant: el día de cobro indicado en el contrato puede cambiar en el futuro. Por eso debe quedar estampado en este recibo',
  `mes_al_cobro_ini` date DEFAULT NULL COMMENT 'El mes que está pagando. Usualmente Mes_al_cobro_ini = Mes_al_cobro_fin; pero en recibos extraordinarios pueden ser diferentes cuando el cliente paga por adelantado varios meses',
  `mes_al_cobro_fin` date DEFAULT NULL COMMENT 'Ej: 2019-04-01 (queriendo decir "2019-04"). Usualmente Mes_al_cobro_ini = Mes_al_cobro_fin; pero en recibos extraordinarios pueden ser diferentes cuando el cliente paga por adelantado varios meses',
  `cuota_numero` int(10) NOT NULL COMMENT 'Es la cuota que paga este recibo, es decir, el número de cuota correspondiente. Si un recibo paga 2 cuotas, aquí aparecerá el número más alto, es decir: el número total de cuotas hasta ahora',
  `cuotas_este_recibo` int(10) NOT NULL DEFAULT 1 COMMENT 'Cant de cuotas que paga este recibo. Usualmente = 1; pero en recibos extraordinarios puede ser 2, 3, 4, 5, 6 ...',
  `descuento` int(11) NOT NULL DEFAULT 0 COMMENT 'Para indicar el monto del descuento, si aplica',
  `monto_recibo` int(10) NOT NULL COMMENT 'Es el monto de este recibo. Ej: 10000',
  `saldo_anterior` int(10) NOT NULL COMMENT 'Es el saldo que quedaba antes de ente recibo',
  `nuevo_saldo` int(10) NOT NULL COMMENT 'Es el saldo actualizado después del pago de este recibo',
  `id_documento` varchar(21) DEFAULT NULL COMMENT 'Es el número de documento (ej: recibo en papel) que se usó antes de Sys',
  `prioridad_cobro` int(1) NOT NULL DEFAULT 1 COMMENT '0 = primero a cobrar (forzado); 1 = prioridad de todas las cuotas; 1000 = prioridad por defecto de todas las salidas y extraordinarios',
  `promesa_de_pago` int(10) DEFAULT NULL COMMENT 'Es un día del mes (diferente al día de pago) en que el cliente se comprometió a pagar el recibo atrasado',
  `arreglo_de_pago` int(11) NOT NULL DEFAULT 0 COMMENT 'Indica si este recibo es parte de un arreglo de pago; 0=No, 1=Sí',
  `veces_impreso` int(10) NOT NULL DEFAULT 0 COMMENT 'Guarda las veces que se ha dado la orden de imprimir este recibo',
  `detalle_recibo` text DEFAULT NULL COMMENT 'Ej: "Cuota mes 2019-04"',
  `abonos_ids` varchar(255) DEFAULT NULL COMMENT 'Si este recibo ha recibido pago(s) parciales mediante abonos, entonces registramos el id de los abonos (Recibos_abonos.id)',
  `notas` text DEFAULT NULL COMMENT 'Anotaciones hechas a este recibo',
  `comisionable_vendedor` int(11) NOT NULL COMMENT 'Monto que debe pagarse al vendedor como comisión pr este recibo',
  `vendedor_id` int(10) NOT NULL COMMENT 'El vendedor que vendió el contrato, quien debe recibir comisión por cuotas 1 a 3',
  `agente_id` int(10) NOT NULL DEFAULT 1 COMMENT 'Es el agente responsable de este recibo (ej: vendedo o cobrador u usuario-admin), es quien cobra este recibo. Ej: si es una PRIMA es el vendedor, si es una CUOTA es el cobrador',
  `orden_id` int(11) NOT NULL DEFAULT 0 COMMENT 'Si este recibo es de un aproforma, este es el id de la proforma',
  `lote_id` int(10) NOT NULL COMMENT 'Es el número del lote en el cual fue creado el recibo de forma automática. Si es = 0 quiere decir que este recibo es manual',
  `planilla_id` int(10) DEFAULT NULL COMMENT 'Es la Planilla.id donde se pagó la comisión al vendedor. también la usamos como bandera: -1=no aplica un aplanilla; -2=es por una liquidación de contrato',
  `sucursal_id` int(10) NOT NULL COMMENT 'A qué sucursal pertenece este recibo. Se usa por ej para el cálculo de planillas de la sucursal',
  `usuario_id` int(10) NOT NULL COMMENT 'Quien realizó el registro (generó) este recibo',
  `tstamp` varchar(24) DEFAULT NULL COMMENT 'Timestamp de los recibos generados en la agenda móvil'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Almacena la data de todos los recibos generados por el Sys';

-- --------------------------------------------------------

--
-- Table structure for table `recibos_backlog`
--

CREATE TABLE `recibos_backlog` (
  `id` int(11) NOT NULL,
  `recibo_id` int(11) NOT NULL,
  `notas` varchar(255) NOT NULL,
  `monto_este_abono` int(11) NOT NULL,
  `fecha_del_pago` datetime NOT NULL,
  `contrato_id` int(11) NOT NULL,
  `id_documento` varchar(64) NOT NULL,
  `agente_id` int(11) NOT NULL,
  `geolocation` varchar(64) NOT NULL,
  `tstamp` varchar(64) NOT NULL,
  `device` varchar(64) DEFAULT NULL COMMENT 'Nos ayuda a identificar cuál dispositivo es',
  `sucursal_id` int(11) NOT NULL COMMENT 'La sucursal a la que pertenece este recibo y agente',
  `fecha_sys` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Recibos backlog guardado en el dispositivo del agente';

-- --------------------------------------------------------

--
-- Table structure for table `recibos_cobros`
--

CREATE TABLE `recibos_cobros` (
  `id` mediumint(7) UNSIGNED NOT NULL,
  `recibo_id` mediumint(7) UNSIGNED NOT NULL COMMENT 'Pago parcial para aplicar al Recibo_id',
  `_provisional_id` tinytext DEFAULT NULL COMMENT 'Lo usábamos para escribir el número de sinpe, tarjeta, depósito',
  `notas` tinytext DEFAULT NULL COMMENT 'Sinpe, Tarjeta, Depósito, Cheque, Notas, etc.',
  `tipo_recibo` int(1) NOT NULL COMMENT '1=Prima, 2=Cuota, 3= Salida, 4=Extraordinario, 5=Liquidacion, 6=Proforma',
  `fecha_del_pago` datetime NOT NULL COMMENT 'Es la fecha en que se hizo el pago por parte del cliente. Coincide con al fecha del recibo provisional en papel, si lo hay',
  `cliente_id` varchar(64) DEFAULT '0' COMMENT 'Es igual a Contratos.Cli_cedula',
  `contrato_id` int(10) NOT NULL COMMENT 'Es el contrato_id al que pertenece este recibo y este pago',
  `agente_id` int(10) NOT NULL COMMENT 'Usuario_id del agente a quien pertenece este cobro; usualmente lo usamos para endosar el cobro al cobrador de planta',
  `monto_total` int(10) NOT NULL COMMENT 'Monto total de este recibo',
  `saldo_anterior` int(10) NOT NULL COMMENT 'Saldo de este recibo antes de este pago',
  `monto_este_abono` int(10) NOT NULL COMMENT 'Monto abonado ahora a este recibo',
  `monto_cash` int(11) NOT NULL DEFAULT 0 COMMENT 'Monto recibido en efectivo',
  `monto_nocash` int(11) NOT NULL DEFAULT 0 COMMENT 'Monto cobrado pero no en efectivo (por ej: tarjeta, sinpe, depósito, cheque, etc)',
  `nuevo_saldo` int(10) NOT NULL COMMENT 'Saldo que le queda a este recibo después de este pago',
  `forma_de_pago` varchar(1) NOT NULL COMMENT 'E=efectivo, T=tarjeta, S=sinpe o transf, C=cheque, P=provisional, H=hibrido (cash + noCash)',
  `geolocation` varchar(255) DEFAULT NULL COMMENT 'Coordenadas de la ubicación donde se realizó este cobro',
  `ip_address` varchar(16) NOT NULL DEFAULT '0' COMMENT 'Dirección IP de este cobro',
  `cierre_id` int(10) UNSIGNED DEFAULT NULL COMMENT 'Es el id del cierre diario donde se incluyó este recibo. También lo usamos como bandera: (-1) = cuando no debe aparecer en un cierre porque es vendedor=cobrador;  (-2) = cuando el recibo es por una liquidación de contrato.',
  `cierre_id_endoso` int(10) UNSIGNED DEFAULT NULL COMMENT 'Es el cierre_id del agente de oficina que cobró este recibo y  lo endosó a otro agente.',
  `nota_aux` varchar(255) DEFAULT NULL COMMENT '7@2021-06-22 11:01:02 Usuario_id que tramita la prima en el contrato físico, y fecha-hora',
  `sucursal_id` int(10) NOT NULL COMMENT 'La sucursal a la cual pertenece este cobro. Se usa en cierres diarios pendientes de la sucursal',
  `usuario_id` int(10) NOT NULL COMMENT 'Es el usuario_id que registró este pago, quien hizo clic en el btn "cobrar"',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora del sistema cuando se registra este pago parcial',
  `tstamp` varchar(24) NOT NULL COMMENT 'Timestamp, para identificar si este registro ya había sido insertado antes, en la tarea de sincronización de la Agenda'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Es como una cuenta de ahorro donde el cliente abona para ir pagando un recibo formal';

-- --------------------------------------------------------

--
-- Table structure for table `recibos_lotes`
--

CREATE TABLE `recibos_lotes` (
  `id` int(10) NOT NULL,
  `fecha_sys` datetime NOT NULL,
  `periodo` date NOT NULL COMMENT 'Es el mes al cobro al que corresponde este lote',
  `detalle` varchar(255) DEFAULT NULL COMMENT 'Ej: zonas 1, 2, 3; ó ... Todas las zonas',
  `cantidad_contratos` int(10) NOT NULL COMMENT 'es la cantidad de contratos a los que se generó al menos un recibo',
  `nuevos_cant` int(3) UNSIGNED NOT NULL COMMENT 'Cantidad de contratos nuevos, que reciben su primera cuota en esta generación',
  `nuevos_monto` int(10) UNSIGNED NOT NULL COMMENT 'Monto de las cuotas que representan los contratos que entraron nuevos en esta generación',
  `cantidad_recibos` int(10) DEFAULT NULL COMMENT 'Es la cantidad de recibos generados en esta ocasión',
  `monto_total` int(10) DEFAULT NULL COMMENT 'Es el monto total de todos los recibos generados en este lote, es decir, la suma de todos los montos de los n recibos generados esta vez ',
  `cancelables_cant` int(3) UNSIGNED NOT NULL COMMENT 'Cantidad de contratos que pudieran llegar a cancelarse este mes',
  `cancelables_monto` int(10) UNSIGNED NOT NULL COMMENT 'Monto que representan esos contratos cancelables',
  `sin_recibo` text DEFAULT NULL COMMENT 'Son los contratos "activos" y sin ningún recibo pendiente que NO recibieron un recibo en este lote. (OJO)',
  `sin_recibo_adelantado` text DEFAULT NULL COMMENT 'Son los contratos_id que no recibieron un recibo por estar "adelantados" (pero con un recibo pendiente de pago). En el simulador son los "Recibo adelantado-no-creado"',
  `usuario_id` int(10) NOT NULL COMMENT 'Es el usuario que generó este lote',
  `sucursal_id` int(10) NOT NULL COMMENT 'Número de sucursal a que pertenece este lote'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda los datos de cada lote generado automáticamente.';

-- --------------------------------------------------------

--
-- Table structure for table `salidas`
--

CREATE TABLE `salidas` (
  `id` int(10) NOT NULL,
  `fecha_salida` datetime NOT NULL COMMENT 'Fecha y hora de esta salida, sea pasada o presente (now)',
  `contrato_id` int(10) NOT NULL COMMENT 'Contratos.id',
  `contrato_valor_total` int(11) NOT NULL COMMENT 'Es el valor total original del contrato. Ej: 1,000,000',
  `contrato_saldo` int(11) NOT NULL COMMENT 'En el "ahorro" es el monto disponible (verde) que quedaba en el contrato ANTES de solicitar este servicio',
  `monto_servido` int(10) NOT NULL COMMENT 'En las salidas de ''Ahorro'' es el precio de los productos servidos, el cual se utiliza para calcular: ''Servido_acumulado'', ''A_pagar_ahora'', ''A_favor_despues''',
  `porcentaje_salida` int(11) NOT NULL COMMENT 'Es el % que se usó en el formulario de Salida para calcular el monto del pago de Salida',
  `monto_pagado_ahora` int(11) NOT NULL COMMENT 'Es el monto que el cliente paga ahora (si aplica) para obtener el servicio de funeral',
  `nuevo_ahorrado` int(11) NOT NULL COMMENT 'Es monto ahorrado que tendrá el cliente ahora cuando pague el 40% del saldo que le quedaba',
  `nuevo_saldo` int(11) NOT NULL COMMENT 'Es el nuevo saldo, calculado incluyendo el 40% que paga ahora. Este "saldo actualizado" es el valor que irá impreso en la letra de cambio',
  `recibo_id` int(10) NOT NULL DEFAULT 0 COMMENT 'Es el id del recibo que paga esta salida. Si no hubo un pago entonces Recibo_id = 0',
  `hoja_actualizada` varchar(255) DEFAULT NULL COMMENT 'Si la hoja de salida fue actualizada, ej: 7@2022-07-22 11:59:59',
  `fallecido_cedula` varchar(64) NOT NULL COMMENT 'Cédula del fallecido',
  `fallecido_nombre` varchar(255) DEFAULT NULL COMMENT 'Nombre(s) y apellidos del fallecido',
  `fallecido_fecha_nacimiento` date DEFAULT NULL COMMENT 'Fecha de nacimiento del fallecido',
  `fallecido_fecha_defuncion` date DEFAULT NULL COMMENT 'Fecha de defunción del fallecido',
  `fallecido_edad_cumplida` varchar(16) NOT NULL COMMENT 'Edad cumplida del fallecido',
  `certificado_defuncion` varchar(255) DEFAULT NULL COMMENT 'Es el número del certificado de defunción',
  `productos_servidos` varchar(255) NOT NULL COMMENT 'Ej: "Servicio con ataúd de madera"',
  `productos_condicion` varchar(255) NOT NULL COMMENT '0=producto no servido, 1=producto servido. Es para guardar un histórico de la condición de cada producto contratado, cómo estaba al momento de esta salida',
  `inventario_sucursal` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Sucursal_id de donde se tomó el ataúd y flores',
  `inventario_velas` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cantidad de velas usadas en este servicio',
  `inventario_producto` tinyint(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Tipo de ataúd usado en este servicio',
  `notas` text NOT NULL COMMENT 'Notas sobre esta salida',
  `factura_sn` int(1) NOT NULL DEFAULT 0 COMMENT '0=no lleva factura, 1=sí lleva factura',
  `factura_numero` int(11) DEFAULT 0 COMMENT 'Número de la factura electrónica correspondiente',
  `factura_recibido` varchar(255) DEFAULT NULL COMMENT 'Nombre del cliente que recibe la factura-e, para tramitarla',
  `factura_aplicada` date DEFAULT NULL COMMENT 'Fecha de aplicación (pago) de la factura, por parte del cliente',
  `factura_aplicada_por` varchar(255) DEFAULT NULL COMMENT 'Nombre del usuario que aplicó la factura',
  `donde` varchar(255) NOT NULL COMMENT 'Dónde se dió el servicio',
  `usuario_id` int(11) NOT NULL COMMENT 'Es el usuario del sistema que realizó esta gestión',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora del sistema'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda los datos de cada salida de producto a favor del cli';

-- --------------------------------------------------------

--
-- Table structure for table `soporte`
--

CREATE TABLE `soporte` (
  `id` int(11) NOT NULL,
  `fecha_ini` datetime NOT NULL COMMENT 'Fecha en que el usuario solicita el soporte',
  `fecha_fin` datetime NOT NULL COMMENT 'Fecha en que el caso es cerrado',
  `usuario_id` int(11) NOT NULL COMMENT 'Usuario que solicita el soporte',
  `soportista_id` int(11) NOT NULL COMMENT 'Usuario que atiende el caso y lo cierra',
  `descripcion` text NOT NULL COMMENT 'Descripción del caso, pro el usuario que abre el caso',
  `comentarios` text NOT NULL COMMENT 'Comentarios de soporte',
  `estatus` int(1) NOT NULL COMMENT '0 = abierto; 1 = corregido en Sys; 2 = Solucionado fuera de Sys (ej: cuando se debe al usuario, o problema de red, etc); 3 = Duplicado (ya este problema fue reportado por otro usuario)',
  `visible` enum('0','1') NOT NULL DEFAULT '1' COMMENT '1=visible, 0=oculto'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Para gestionar los casos de soporte';

-- --------------------------------------------------------

--
-- Table structure for table `stats_clientesxdia`
--

CREATE TABLE `stats_clientesxdia` (
  `id` int(11) NOT NULL,
  `fecha_sys` date NOT NULL COMMENT 'Fecha en que se compiló este stat',
  `cobrador_id` int(11) NOT NULL COMMENT 'id del usuario del Cobrador a quien pertenece este stat',
  `cant_clientes` varchar(256) NOT NULL COMMENT 'String-array de las cantidades desde día 1 al 30, separado por comas'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Cantidad clientes asignados por día de cobro, por cobrador';

-- --------------------------------------------------------

--
-- Table structure for table `stats_prospectos`
--

CREATE TABLE `stats_prospectos` (
  `cli_nombre` varchar(255) DEFAULT NULL,
  `cli_cedula` varchar(64) NOT NULL,
  `cli_tel_celular` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `contrato_doc` varchar(255) DEFAULT NULL,
  `contrato_id` int(10) DEFAULT NULL,
  `contrato_id_reciente` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'id del contrato más recientemente suscrito pro el cliente',
  `estatus` int(1) NOT NULL COMMENT 'Estatus del contrato',
  `servidos` int(1) DEFAULT NULL,
  `por_servir` int(1) DEFAULT NULL,
  `cuotas_restantes` int(10) DEFAULT NULL,
  `fecha_ultimo_pago` date DEFAULT NULL COMMENT 'Fecha de cancelación del contrato, si aplica',
  `vendedor_id` int(11) DEFAULT 0 COMMENT 'usuario_id del agente vendedor',
  `cobrador_id` int(11) DEFAULT 0 COMMENT 'usuario_id del agente cobrador',
  `prospecto_agente` int(11) DEFAULT 0 COMMENT 'usuario_id del agente asignado a atender a este prospecto',
  `prospecto_notas` varchar(255) NOT NULL,
  `ventas_estatus` int(1) DEFAULT NULL,
  `promesa_de_visita` date DEFAULT NULL,
  `cant_planes` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Es la cantidad de planes ACTIVOS que aparecen a nombre del cliente',
  `total_cuotas` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Suma del monto de cuotas que actualmente está pagando el cliente por todos sus planes activos',
  `suscripcion_reciente` date NOT NULL COMMENT 'Es la fecha de suscripción de su plan más reciente',
  `sucursal_id` int(1) DEFAULT NULL,
  `fecha_sys` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Guarda los prospectos de ventas, diariamente';

-- --------------------------------------------------------

--
-- Table structure for table `sucursales`
--

CREATE TABLE `sucursales` (
  `id` int(10) NOT NULL,
  `nombre_sucursal` varchar(64) NOT NULL COMMENT 'Nombre de la sucursal',
  `ubicacion` text NOT NULL COMMENT 'Dónde está la sucursal',
  `provincia` varchar(64) NOT NULL COMMENT 'Provincia donde se ubica la sucursal',
  `telefonos` varchar(64) NOT NULL COMMENT 'Teléfonos de contacto de esta sucursal',
  `fecha_de_creacion` date NOT NULL COMMENT 'Fecha en la que se crea esta sucursal en el sys',
  `creado_por` int(10) NOT NULL COMMENT 'Usuario_id admin que creó esta sucursal en el sys',
  `gerente` int(10) NOT NULL COMMENT 'Usuario_id quien es el gerente de esta sucursal',
  `texto_prueba` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Esta tabla almacena la info de las sucursales del negocio';

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(10) NOT NULL,
  `code` varchar(16) NOT NULL COMMENT 'Código único del usuario; lo usamos en el perfil online. Ej: OAG3',
  `mensaje` tinytext NOT NULL COMMENT 'Es un mensaje personalizado que se escuchará en el mensaje de bienvenida al usuario',
  `usuario` varchar(64) NOT NULL COMMENT 'User, Username',
  `nombre_pila` varchar(255) NOT NULL COMMENT 'Es cómo se pronuncia el nombre de pila',
  `nombre` varchar(64) NOT NULL,
  `apellidos` varchar(64) NOT NULL,
  `puesto` varchar(56) NOT NULL COMMENT 'Puesto laboral que ocupa el empleado o usuario',
  `password` varchar(255) NOT NULL,
  `notas` varchar(256) NOT NULL COMMENT 'Observaciones sobre el usuario',
  `technote` text NOT NULL COMMENT 'Notas técnicas. Por ej: speech.voices',
  `genero` varchar(1) NOT NULL COMMENT 'F=Femenino, M=Masculino',
  `cedula` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL,
  `telefono` varchar(32) DEFAULT NULL,
  `fecha_nacimiento` date NOT NULL,
  `fecha_ingreso` date NOT NULL COMMENT 'Fecha en que la persona ingresó a la empresa',
  `mes_ingreso` int(2) NOT NULL DEFAULT 0 COMMENT 'Es el mes en el que ingresó el usuario. Se usa en Planilla-Vacaciones. Como no se tiene la "fecha de ingreso" de algunos usuarios, al menos seteamos este valor para el cálculo de vacaciones',
  `vacaciones_aviso_onoff` int(1) NOT NULL DEFAULT 0 COMMENT 'Bandera que usamos en el aviso de vacaciones. Mientras está "on" se muestra el aviso hasta que el usuario apara el aviso en Sys',
  `sucursal_id` int(10) NOT NULL,
  `estatus` int(1) UNSIGNED NOT NULL COMMENT '0=inactivo, 1=activo',
  `estatus_now` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=no está conectado, 1=está conectado en Sys en este momento',
  `visible` int(1) NOT NULL COMMENT 'S/N ... si se muestra o no en la UI',
  `creado_por` varchar(64) NOT NULL COMMENT 'Usuario admin que creó a este usuario en el sys y la fecha. Ej: 3@2020-07-26',
  `usuario_id` int(11) NOT NULL COMMENT 'Usuario_id que modificó este registro',
  `fecha_sys` date NOT NULL COMMENT 'Fecha y hora cuando fue creado el usuario',
  `last_login` datetime NOT NULL COMMENT 'Cuándo el usuario ingresó la última vez',
  `last_sincro` datetime NOT NULL COMMENT 'Fecha y hora de lasincronización más reciente, si aplica',
  `vista` varchar(16) NOT NULL DEFAULT 'no' COMMENT 'Es la vista que aparecerá por defecto cuando el usuario ingrese. Ej: "sys" ó "agenda"',
  `sabor` varchar(16) DEFAULT NULL COMMENT 'Es el tipo de agenda que verá el agente al ingresar a la vista "Agenda". Ej: ''cobros'', ''ventas''',
  `otra_agenda` int(11) NOT NULL DEFAULT 0 COMMENT 'Es el usuario_id de otro agente a cuya agenda tiene permiso para usar. Útil cuando se desea endosar temporalmente la agenda de otro cobrador',
  `rol_principal` varchar(16) DEFAULT 'empleado' COMMENT 'Es el rol principal del usuario, dentro de la estructura empresarial',
  `rol_dev` int(1) NOT NULL COMMENT 'Es developer',
  `rol_gerente` int(1) NOT NULL COMMENT 'Es gerente',
  `rol_gestor` int(1) NOT NULL DEFAULT 0 COMMENT 'Gestor de cobro, como Merlyn',
  `rol_admin` int(1) NOT NULL COMMENT 'Es adminsitrativo',
  `rol_supervisor` int(11) NOT NULL DEFAULT 0 COMMENT 'Rol para supervisores. Tienen ciertos permisos en Sys, como ver clientes, pero no modificar',
  `rol_agente` int(1) NOT NULL COMMENT 'El usuario puede aparecer como agente recaudador de algún recibo',
  `rol_vendedor` int(1) NOT NULL COMMENT 'Es vendedor',
  `rol_cobrador` int(1) NOT NULL COMMENT 'Es cobrador',
  `rol_empleado` int(1) NOT NULL DEFAULT 1 COMMENT 'Es empleado, aparece en planilla',
  `rol_patologo` int(1) NOT NULL DEFAULT 0 COMMENT 'Es patólogo, especialista en técnica de preservación del cuerpo',
  `en_cierres` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Este usuario debe aparecer en los Cierres diarios, si cobra algún recibo',
  `en_planillas` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Este usuario debe aparecer en Planillas y Aguinaldos, si tiene ingresos',
  `p_clientes` int(1) NOT NULL COMMENT 'Clientes (create, read, update, delete)',
  `p_usuarios` int(1) NOT NULL COMMENT 'Usuarios de Sys (create, read, update, delete)',
  `p_cierres` int(1) NOT NULL COMMENT 'Gestionar cierres diarios',
  `p_eliminar` int(1) NOT NULL DEFAULT 0 COMMENT 'Permiso para eliminar items sensibles. Ej: cobros, recibos, salidas',
  `p_eliminart` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Permiso para eliminar. Pero con caracter "temporal" (solo alcanza para una operación por vez)',
  `p_reimprimirt` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Permiso para reimprimir un recibo. Pero con caracter "temporal" (solo alcanza para una operación por vez)',
  `p_planillas` int(1) NOT NULL COMMENT 'Permiso para gestionar planillas y comisiones',
  `p_lotes` int(1) NOT NULL COMMENT 'Generar lotes mensuales de recibos',
  `p_indices` int(1) NOT NULL COMMENT 'Ver a los índices y stats del negocio',
  `p_reportes` int(1) NOT NULL DEFAULT 0 COMMENT 'Ver los reportes de empresa',
  `p_log` int(1) NOT NULL COMMENT 'Log (ver)',
  `p_agenda` int(1) NOT NULL COMMENT 'El usuario debe tener una agenda de cobro individual, a la que acceda con su usuario',
  `p_amaster` int(1) NOT NULL DEFAULT 0 COMMENT 'El usuario tiene permiso para acceder a la Agenda-master, aunque no sea GERENTE. Si es gerente tendrá acceso siempre',
  `p_facturar` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'El usuario tiene permiso para emitir facturas electrónicas',
  `sys_habla` int(1) UNSIGNED NOT NULL DEFAULT 1 COMMENT '0=no, 1=sí',
  `ventas_meta_mensual` int(1) NOT NULL DEFAULT 0 COMMENT 'Meta de ventas para vendedores, en cant de contratos vendidos',
  `bonificacion` smallint(5) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Monto de bonificación por cada contrato sobremeta',
  `ventas_comision_prima` int(11) NOT NULL DEFAULT 0 COMMENT 'Porcentaje de la prima que obtiene de comisión al vender un contrato',
  `ventas_comision_cuotas` int(1) NOT NULL DEFAULT 0 COMMENT 'Cuántas cuotas comisiona el vendedor, de cada contrato vendido',
  `ventas_comision_extra` smallint(6) NOT NULL DEFAULT 0 COMMENT 'Bonificación extra por cada contrato vendido por encima de la meta mensual',
  `tasa_comision_principal` int(11) NOT NULL DEFAULT 0 COMMENT '50% para vendedores (por n cuotas); 10% para cobradores (por cada recibo)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `wa_campanas`
--

CREATE TABLE `wa_campanas` (
  `id` int(10) UNSIGNED NOT NULL,
  `estatus` int(10) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Pendiente, 1=Programado, 2=Enviando, 3=Pausado, 4=Finalizado',
  `titulo` varchar(255) NOT NULL COMMENT 'Título de la campaña',
  `mensaje` text NOT NULL COMMENT 'Texto del mensaje de la campaña. Ej: "Hola %nombre%, bla bla."',
  `imagen` varchar(255) NOT NULL COMMENT 'Imagen que enviamos como parte del mensaje',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora de creación de esta campaña',
  `grupo_id` mediumint(8) UNSIGNED NOT NULL COMMENT 'Grupo de contactos a quien fue dirigida la campaña',
  `cant_contactos` smallint(5) UNSIGNED NOT NULL COMMENT 'Cantidad de contactos a que fue dirigida la campaña',
  `iniciar` datetime NOT NULL COMMENT 'Fecha y hora de inicio (automático) de la campaña',
  `usuario_id` int(3) UNSIGNED NOT NULL COMMENT 'Autor de esta campaña'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Campañas para enviar por WhatsApp';

-- --------------------------------------------------------

--
-- Table structure for table `wa_contactos`
--

CREATE TABLE `wa_contactos` (
  `id` int(10) UNSIGNED NOT NULL,
  `telefono` varchar(32) NOT NULL COMMENT 'Número de teléfono del destinatario',
  `nombre` varchar(255) NOT NULL COMMENT 'Nombre del destinatario, para incluir en el mensaje. Ej: "Hola %nombre%, bla bla"',
  `etc` varchar(255) NOT NULL COMMENT 'Cualquier otra variable que queramos llevar el mensaje. Ej: "Hola %nombre%, tu contrato es %etc%"',
  `grupo_id` int(10) UNSIGNED NOT NULL COMMENT 'Id del grupo de contactos a que pertenece este contacto'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Estos son los contactos de WA, ordenados por grupos';

-- --------------------------------------------------------

--
-- Table structure for table `wa_grupos`
--

CREATE TABLE `wa_grupos` (
  `id` int(10) UNSIGNED NOT NULL,
  `grupo_nombre` varchar(255) NOT NULL COMMENT 'Nombre identificador del grupo de contactos',
  `usuario_id` int(3) UNSIGNED NOT NULL COMMENT 'Usuario que creó el grupo',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha de creación del grupo'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Grupos de contactos';

-- --------------------------------------------------------

--
-- Table structure for table `wa_log`
--

CREATE TABLE `wa_log` (
  `id` int(10) UNSIGNED NOT NULL,
  `telefono` varchar(32) NOT NULL COMMENT 'Número del destinatario',
  `nombre` varchar(255) NOT NULL COMMENT 'Nombre del destinatario',
  `grupo_id` int(10) UNSIGNED NOT NULL COMMENT 'Grupo de contactos al que pertenece',
  `campana_id` int(10) UNSIGNED NOT NULL COMMENT 'Campaña_id que le fue enviada',
  `estatus` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=Pendiente, 1=Programado, 5=Exitoso, 6=Fallido, 7=SinResult, 8=FalloApi',
  `fecha_sys` datetime NOT NULL COMMENT 'Fecha y hora de envío del mensaje',
  `tstamp` varchar(13) NOT NULL COMMENT 'Timestamp de envío del mensaje'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Log de resultados al enviar cada mensaje a su destinatario';

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activos_evaluacion`
--
ALTER TABLE `activos_evaluacion`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `agendas_diarias`
--
ALTER TABLE `agendas_diarias`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `agendas_permisos`
--
ALTER TABLE `agendas_permisos`
  ADD PRIMARY KEY (`agente_id`);

--
-- Indexes for table `banco_conta`
--
ALTER TABLE `banco_conta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cierres`
--
ALTER TABLE `cierres`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`agente_id`,`fecha`,`recaudado_hoy`,`ultima_sincro`,`usuario_id`,`fecha_sys`);

--
-- Indexes for table `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`cedula`,`contrato_id`) USING BTREE;

--
-- Indexes for table `colores_sys`
--
ALTER TABLE `colores_sys`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `configuraciones`
--
ALTER TABLE `configuraciones`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`id_documento`);

--
-- Indexes for table `cpanel_cobro_diario`
--
ALTER TABLE `cpanel_cobro_diario`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`fecha`,`cobrador_id`);

--
-- Indexes for table `cpanel_cobro_morosos`
--
ALTER TABLE `cpanel_cobro_morosos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`fecha`,`cobrador_id`);

--
-- Indexes for table `evaluaciones`
--
ALTER TABLE `evaluaciones`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `formacion`
--
ALTER TABLE `formacion`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gestiones_codigos`
--
ALTER TABLE `gestiones_codigos`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gestiones_promesas_ayer`
--
ALTER TABLE `gestiones_promesas_ayer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gestiones_promesas_hoy`
--
ALTER TABLE `gestiones_promesas_hoy`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gestiones_promesas_ven`
--
ALTER TABLE `gestiones_promesas_ven`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_ibanking`
--
ALTER TABLE `log_ibanking`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_sys`
--
ALTER TABLE `log_sys`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`descripcion_min`,`usuario_id`,`geolocation`,`tstamp`,`contrato_id`,`fecha_promesa`,`codigo`);

--
-- Indexes for table `log_version`
--
ALTER TABLE `log_version`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `log_version_fechas_erroneas`
--
ALTER TABLE `log_version_fechas_erroneas`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `memorial`
--
ALTER TABLE `memorial`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`code`);

--
-- Indexes for table `metadata`
--
ALTER TABLE `metadata`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ordenes`
--
ALTER TABLE `ordenes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`enum`);

--
-- Indexes for table `planillas`
--
ALTER TABLE `planillas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`agente_id`,`fecha_anterior`,`fecha_sys`);

--
-- Indexes for table `planillas_aguinaldos`
--
ALTER TABLE `planillas_aguinaldos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`periodo`,`empleado_id`);

--
-- Indexes for table `planillas_aguinaldos_row`
--
ALTER TABLE `planillas_aguinaldos_row`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `planillas_row`
--
ALTER TABLE `planillas_row`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `planillas_rubros`
--
ALTER TABLE `planillas_rubros`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `planillas_vacaciones`
--
ALTER TABLE `planillas_vacaciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`periodo_ini`,`periodo_fin`,`empleado_id`);

--
-- Indexes for table `planillas_vacaciones_row`
--
ALTER TABLE `planillas_vacaciones_row`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`enum`);

--
-- Indexes for table `productos_de_inventario`
--
ALTER TABLE `productos_de_inventario`
  ADD PRIMARY KEY (`enum`);

--
-- Indexes for table `productos_en_inventario`
--
ALTER TABLE `productos_en_inventario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `producto_id` (`producto_enum`);

--
-- Indexes for table `productos_row`
--
ALTER TABLE `productos_row`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `promos_acciones`
--
ALTER TABLE `promos_acciones`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`recibo_id`,`razon_id`);

--
-- Indexes for table `promos_ganadores`
--
ALTER TABLE `promos_ganadores`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `promos_id`
--
ALTER TABLE `promos_id`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `promos_referidos`
--
ALTER TABLE `promos_referidos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`promo_id`,`referido_por`,`referido_nombre`,`referido_tel`) USING HASH;

--
-- Indexes for table `recibos`
--
ALTER TABLE `recibos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`contrato_id`,`id_provisional_agenda`,`fecha_sys`,`fecha_cancelacion`,`cuota_numero`,`mes_al_cobro_ini`,`monto_recibo`,`saldo_anterior`,`usuario_id`),
  ADD KEY `contrato_id` (`contrato_id`,`cobrador_id`),
  ADD KEY `lote_id` (`lote_id`,`vendedor_id`,`abonos_ids`);

--
-- Indexes for table `recibos_backlog`
--
ALTER TABLE `recibos_backlog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`tstamp`);

--
-- Indexes for table `recibos_cobros`
--
ALTER TABLE `recibos_cobros`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`recibo_id`,`tipo_recibo`,`contrato_id`,`monto_este_abono`,`fecha_del_pago`,`usuario_id`,`tstamp`) USING BTREE,
  ADD KEY `recibo_id` (`recibo_id`);

--
-- Indexes for table `recibos_lotes`
--
ALTER TABLE `recibos_lotes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`periodo`);

--
-- Indexes for table `salidas`
--
ALTER TABLE `salidas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`contrato_id`,`fecha_sys`),
  ADD KEY `contrato_id` (`contrato_id`),
  ADD KEY `contrato_id_2` (`contrato_id`),
  ADD KEY `recibo_id` (`recibo_id`);

--
-- Indexes for table `soporte`
--
ALTER TABLE `soporte`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stats_clientesxdia`
--
ALTER TABLE `stats_clientesxdia`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sucursales`
--
ALTER TABLE `sucursales`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `idx_name` (`usuario`),
  ADD KEY `sucursal_id` (`sucursal_id`);

--
-- Indexes for table `wa_campanas`
--
ALTER TABLE `wa_campanas`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `wa_contactos`
--
ALTER TABLE `wa_contactos`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `wa_grupos`
--
ALTER TABLE `wa_grupos`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `wa_log`
--
ALTER TABLE `wa_log`
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `idx_name` (`telefono`,`grupo_id`,`campana_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activos_evaluacion`
--
ALTER TABLE `activos_evaluacion`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `agendas_diarias`
--
ALTER TABLE `agendas_diarias`
  MODIFY `id` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `banco_conta`
--
ALTER TABLE `banco_conta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cierres`
--
ALTER TABLE `cierres`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `clientes`
--
ALTER TABLE `clientes`
  MODIFY `id` smallint(4) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `colores_sys`
--
ALTER TABLE `colores_sys`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `configuraciones`
--
ALTER TABLE `configuraciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contratos`
--
ALTER TABLE `contratos`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cpanel_cobro_diario`
--
ALTER TABLE `cpanel_cobro_diario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cpanel_cobro_morosos`
--
ALTER TABLE `cpanel_cobro_morosos`
  MODIFY `id` smallint(3) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `evaluaciones`
--
ALTER TABLE `evaluaciones`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gestiones_codigos`
--
ALTER TABLE `gestiones_codigos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gestiones_promesas_ayer`
--
ALTER TABLE `gestiones_promesas_ayer`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gestiones_promesas_hoy`
--
ALTER TABLE `gestiones_promesas_hoy`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gestiones_promesas_ven`
--
ALTER TABLE `gestiones_promesas_ven`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_ibanking`
--
ALTER TABLE `log_ibanking`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_sys`
--
ALTER TABLE `log_sys`
  MODIFY `id` mediumint(7) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_version`
--
ALTER TABLE `log_version`
  MODIFY `id` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `log_version_fechas_erroneas`
--
ALTER TABLE `log_version_fechas_erroneas`
  MODIFY `id` smallint(4) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `memorial`
--
ALTER TABLE `memorial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `metadata`
--
ALTER TABLE `metadata`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ordenes`
--
ALTER TABLE `ordenes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planes`
--
ALTER TABLE `planes`
  MODIFY `enum` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planillas`
--
ALTER TABLE `planillas`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planillas_aguinaldos`
--
ALTER TABLE `planillas_aguinaldos`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planillas_aguinaldos_row`
--
ALTER TABLE `planillas_aguinaldos_row`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planillas_row`
--
ALTER TABLE `planillas_row`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planillas_rubros`
--
ALTER TABLE `planillas_rubros`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planillas_vacaciones`
--
ALTER TABLE `planillas_vacaciones`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `planillas_vacaciones_row`
--
ALTER TABLE `planillas_vacaciones_row`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `productos`
--
ALTER TABLE `productos`
  MODIFY `enum` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `productos_de_inventario`
--
ALTER TABLE `productos_de_inventario`
  MODIFY `enum` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Producto_enum correspondiente';

--
-- AUTO_INCREMENT for table `productos_en_inventario`
--
ALTER TABLE `productos_en_inventario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `productos_row`
--
ALTER TABLE `productos_row`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'Cada row es un producto con cantidad 1. Es decir, si son 3 ataud de madera, entonces en esta tabla se crean 3 rows, una por cada ataud de madera. Esto facilitará llevar el control de salidas en esta misma tabla, para cada item individual';

--
-- AUTO_INCREMENT for table `promos_acciones`
--
ALTER TABLE `promos_acciones`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promos_ganadores`
--
ALTER TABLE `promos_ganadores`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promos_id`
--
ALTER TABLE `promos_id`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'id de la promo';

--
-- AUTO_INCREMENT for table `promos_referidos`
--
ALTER TABLE `promos_referidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recibos`
--
ALTER TABLE `recibos`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT COMMENT 'Este es el consecutivo de los recibos; aparece en el recibo impreso como número de consecutivo';

--
-- AUTO_INCREMENT for table `recibos_backlog`
--
ALTER TABLE `recibos_backlog`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recibos_cobros`
--
ALTER TABLE `recibos_cobros`
  MODIFY `id` mediumint(7) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recibos_lotes`
--
ALTER TABLE `recibos_lotes`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `salidas`
--
ALTER TABLE `salidas`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `soporte`
--
ALTER TABLE `soporte`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stats_clientesxdia`
--
ALTER TABLE `stats_clientesxdia`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sucursales`
--
ALTER TABLE `sucursales`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wa_campanas`
--
ALTER TABLE `wa_campanas`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wa_contactos`
--
ALTER TABLE `wa_contactos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wa_grupos`
--
ALTER TABLE `wa_grupos`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `wa_log`
--
ALTER TABLE `wa_log`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

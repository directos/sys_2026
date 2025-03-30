-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 28, 2025 at 03:21 AM
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

--
-- Dumping data for table `sucursales`
--

INSERT INTO `sucursales` (`id`, `nombre_sucursal`, `ubicacion`, `provincia`, `telefonos`, `fecha_de_creacion`, `creado_por`, `gerente`, `texto_prueba`) VALUES
(1, 'Ciudad Neily', 'Costado N.O. del Parque, contiguo a Óptica CB. Ciudad Neily, Punt.', 'Puntarenas', '2783.1058 | 8732.9494', '2008-01-01', 3, 4, ''),
(2, 'Pérez Zeledón', 'Pérez Zeledón, SJ. Centro Comercial Rimar.', 'San José', '2771.6058 | 8972.4541', '2021-05-01', 3, 4, '');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

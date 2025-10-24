CREATE DATABASE IF NOT EXISTS `trabajadores_db`;
USE `trabajadores_db`;
CREATE TABLE IF NOT EXISTS `trabajadores` (
 `id` INT AUTO_INCREMENT PRIMARY KEY,
 `nombre` VARCHAR(255) NOT NULL,
 `cargo` VARCHAR(255) NOT NULL
);
INSERT INTO `trabajadores` (`nombre`, `cargo`) VALUES
('Juan Perez', 'Desarrollador'),
('Maria Garcia', 'Diseñadora'),
('Carlos Lopez', 'Gerente de Proyecto');
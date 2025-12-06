-- 1. CREACIÓN DE LA BASE DE DATOS Y TABLAS
DROP DATABASE IF EXISTS sistema_ventas_mas;
CREATE DATABASE sistema_ventas_mas;
USE sistema_ventas_mas;

-- Tabla Clientes 
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    dni VARCHAR(20) NOT NULL UNIQUE, 
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    direccion VARCHAR(200)
);

-- Tabla Productos 
CREATE TABLE Productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0),
    stock INT NOT NULL CHECK (stock >= 0)
);

-- Tabla Ordenes (Cabecera) 
CREATE TABLE Ordenes (
    id_orden INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL,
    CONSTRAINT fk_orden_cliente FOREIGN KEY (id_cliente) 
        REFERENCES Clientes(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Tabla Detalles_Orden 
CREATE TABLE Detalles_Orden (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_orden INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    
    CONSTRAINT fk_detalle_orden FOREIGN KEY (id_orden) 
        REFERENCES Ordenes(id_orden)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        
    CONSTRAINT fk_detalle_producto FOREIGN KEY (id_producto) 
        REFERENCES Productos(id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Índice requerido [cite: 22]
CREATE INDEX idx_producto_nombre ON Productos(nombre);

-- 2. CARGA DE DATOS INICIALES (INSERTS)

-- 10 Productos 
INSERT INTO Productos (nombre, categoria, precio, stock) VALUES 
('Laptop Gamer', 'Electronica', 1200.00, 50),
('Mouse Inalambrico', 'Accesorios', 25.50, 100),
('Teclado Mecanico', 'Accesorios', 80.00, 75),
('Monitor 24 pulgadas', 'Electronica', 200.00, 40),
('Auriculares Bluetooth', 'Audio', 50.00, 60),
('Smartphone Android', 'Telefonia', 350.00, 30),
('Funda para Laptop', 'Accesorios', 15.00, 150),
('Disco Duro Externo 1TB', 'Almacenamiento', 60.00, 80),
('Memoria USB 64GB', 'Almacenamiento', 12.00, 200),
('Cargador Portatil', 'Accesorios', 30.00, 90);

-- 10 Clientes 
INSERT INTO Clientes (nombre, apellido, dni, email, telefono, direccion) VALUES 
('Juan', 'Perez', '30111222', 'juan.perez@email.com', '555-001', 'Calle 1'),
('Maria', 'Gomez', '31222333', 'maria.gomez@email.com', '555-002', 'Calle 2'),
('Pedro', 'Ruiz', '32333444', 'pedro.ruiz@email.com', '555-003', 'Calle 3'),
('Ana', 'Lopez', '33444555', 'ana.lopez@email.com', '555-004', 'Calle 4'),
('Luis', 'Diaz', '34555666', 'luis.diaz@email.com', '555-005', 'Calle 5'),
('Sofia', 'Mora', '35666777', 'sofia.mora@email.com', '555-006', 'Calle 6'),
('Carlos', 'Vega', '36777888', 'carlos.vega@email.com', '555-007', 'Calle 7'),
('Lucia', 'Sanz', '37888999', 'lucia.sanz@email.com', '555-008', 'Calle 8'),
('Miguel', 'Cano', '38999000', 'miguel.cano@email.com', '555-009', 'Calle 9'),
('Elena', 'Rios', '39000111', 'elena.rios@email.com', '555-010', 'Calle 10');
-- Cliente 1 compra Laptop
INSERT INTO Ordenes (id_cliente, fecha) VALUES (1, '2023-01-10');
INSERT INTO Detalles_Orden (id_orden, id_producto, cantidad, precio_unitario) VALUES (LAST_INSERT_ID(), 1, 1, 1200.00);

-- Cliente 2 compra Mouse
INSERT INTO Ordenes (id_cliente, fecha) VALUES (2, '2023-02-15');
INSERT INTO Detalles_Orden (id_orden, id_producto, cantidad, precio_unitario) VALUES (LAST_INSERT_ID(), 2, 2, 25.50);
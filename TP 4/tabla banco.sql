DROP DATABASE IF EXISTS Banco;
CREATE DATABASE Banco;
USE Banco;
CREATE TABLE clientes (
    numero_cliente INT PRIMARY KEY AUTO_INCREMENT,
    dni INT NOT NULL UNIQUE,
    apellido VARCHAR(60) NOT NULL,
    nombre VARCHAR(60) NOT NULL
);

CREATE TABLE cuentas (
 numero_cuenta int primary key auto_increment,
 numero_cliente int not null,
 saldo DECIMAL(10,2) not null default 0.00,
 foreign key (numero_cliente) references clientes(numero_cliente)
 );
 
CREATE TABLE movimientos (
    numero_movimiento INT PRIMARY KEY AUTO_INCREMENT,
    numero_cuenta INT NOT NULL,
    fecha DATE NOT NULL,
    tipo ENUM('CREDITO', 'DEBITO') NOT NULL,
    importe DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta)
);
CREATE TABLE historial_movimientos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero_cuenta INT NOT NULL,
    numero_movimiento INT NOT NULL,
    saldo_anterior DECIMAL(10, 2) NOT NULL,
    saldo_actual DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (numero_cuenta) REFERENCES cuentas(numero_cuenta),
    FOREIGN KEY (numero_movimiento) REFERENCES movimientos(numero_movimiento)
);

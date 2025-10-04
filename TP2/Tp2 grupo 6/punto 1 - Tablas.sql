DROP DATABASE IF EXISTS TP2;
CREATE DATABASE TP2;
USE Tp2;
create table Socios (
 id_socio int primary key,
 nombre varchar (100),
 direccion varchar (100)
);
create table Barcos (
 matricula varchar(20) primary key,
 nombre varchar (100),
 numero_amarre int,
 cuota decimal(10,2),
 id_socio int,
 foreign key (id_socio) references Socios(id_socio)
);
create table Salidas (
 id_salida int primary key,
 matricula varchar(20),
 fecha_salida date,
 hora_salida time,
 destino varchar(100),
 patron_nombre varchar(100),
 patron_direccion varchar(255),
 foreign key  (matricula) references Barcos(matricula)
 );



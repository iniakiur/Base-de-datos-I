drop database if exists ESTADIA; 
create database ESTADIA;
USE ESTADIA;

create table Hotel (
cod_hotel INT PRIMARY KEY,
direccion_hotel VARCHAR(50),
ciudad_hotel VARCHAR(50),
cantidad_habitaciones INT,
dni_gerente INT,
foreign key (dni_gerente) REFERENCES Gerente (dni_gerente)
);

create table Cliente (
dni_cliente INT PRIMARY KEY,
nombre_cliente VARCHAR(50),
ciudad_cliente VARCHAR(50)
);

create table HABITACION(
  cod_hotel INT,
  habitacion INT,
  PRIMARY KEY (cod_hotel, habitacion),
  FOREIGN KEY (cod_hotel) REFERENCES HOTEL(cod_hotel)
);

create table Gerente (
dni_gerente INT PRIMARY KEY,
nombre_gerente VARCHAR(50)
);

create table Hospedaje (
fecha_inicio_hospedaje DATE,
cant_dias_hospedaje INT,
habitacion INT
);

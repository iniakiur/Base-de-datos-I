drop database if exists TallerAuto;
create database TallerAuto;
use TallerAuto;

create table Cliente (
dni_cliente INT PRIMARY KEY,
nombre_cliente VARCHAR(50),
celular_cliente VARCHAR(50)
);

create table Mecanico (
dni_mecanico INT PRIMARY KEY,
nombre_mecanico VARCHAR(50),
mail_mecanico VARCHAR(50)
);

create table Auto (
patente_auto VARCHAR(50),
marca_auto VARCHAR(50),
modelo_auto VARCHAR(50),
primary key (patente_auto , marca_auto , modelo_auto),
dni_cliente INT,
foreign key (dni_cliente) references Cliente (dni_cliente)
);

create table Fosa (
codigo_fosa INT PRIMARY KEY,
largo_fosa INT,
ancho_fosa int,
patente_auto VARCHAR(50),
foreign key (patente_auto) REFERENCES Auto (patente_auto)
);

create table Sucursal (
codigo_sucursal INT PRIMARY KEY,
domicilio_sucursal VARCHAR(50),
telefono_sucursal VARCHAR(50),
codigo_fosa int,
dni_mecanico int,
foreign key (codigo_fosa) REFERENCES Fosa (codigo_fosa),
foreign key (dni_mecanico) REFERENCES Mecanico (dni_mecanico)
);



DROP DATABASE IF EXISTS gabinete_abogados;
CREATE DATABASE gabinete_abogados;
USE gabinete_abogados;
create table Clientes (
 dni varchar(200)  primary key,
 nombre varchar(200) not null,
 direccion varchar(255)
 );
 create table Asuntos (
  numero_expediente  varchar(20) primary key,
  dni_cliente varchar(200) not null,
  fecha_inicio date not null,
  fecha_fin date,
  estado varchar(10) not null,
foreign key (dni_cliente) references Clientes(dni),
  constraint ck_fecha_fin_estado check(
   (estado = 'Abierto' and fecha_fin is null) or
   (estado = 'Cerrado' and fecha_fin is not null)
    )
  );
  create table Procuradores (
  id_procurador int primary key,
  nombre varchar(100) not null,
  direccion varchar(200)
  );
  create table Asunto_Procuradores (
  numero_expediente varchar(20),
  id_procurador int,
  primary key (numero_expediente, id_procurador),
  foreign key (numero_expediente) references Asuntos(numero_expediente),
  foreign key (id_procurador) references Procuradores(id_procurador)
  );
  
  

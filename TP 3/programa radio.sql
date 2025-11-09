drop database if exists ProgramaRadio;
create database ProgramaRadio;
use ProgramaRadio;

create table Gerente (
dni_gerente INT PRIMARY KEY,
nombre_gerente VARCHAR (50)
);

create table Radio (
radio VARCHAR(50),
anio INT,
frecuencia_radio float,
dni_gerente INT,
primary key (radio, anio),
FOREIGN KEY (dni_gerente) REFERENCES Gerente(dni_gerente)
);

create table Programa (
programa VARCHAR (50),
conductor VARCHAR(50),
radio VARCHAR(50),
anio INT,
primary key (radio, anio , programa),
foreign key (radio, anio) REFERENCES Radio (radio, anio)
); 


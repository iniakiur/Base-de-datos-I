-- Base de datos (opcional)
DROP DATABASE IF EXISTS TorneosCiclismo;
CREATE DATABASE TorneosCiclismo;
USE TorneosCiclismo;

-- Personas (para presidente y médico opcionalmente)
CREATE TABLE Persona (
    dni CHAR(10) PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100)
) ENGINE=InnoDB;

-- Tabla de torneos
CREATE TABLE Torneo (
    cod_torneo INT PRIMARY KEY,
    nombre_torneo VARCHAR(200) NOT NULL
) ENGINE=InnoDB;

-- Corredores: cada corredor tiene un código único POR torneo
-- clave primaria compuesta (cod_torneo, cod_corredor)
CREATE TABLE Corredor (
    cod_torneo INT NOT NULL,
    cod_corredor INT NOT NULL,
    nyap_corredor VARCHAR(200) NOT NULL,
    PRIMARY KEY (cod_torneo, cod_corredor),
    FOREIGN KEY (cod_torneo) REFERENCES Torneo(cod_torneo)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Sponsors
CREATE TABLE Sponsor (
    id_sponsor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sponsor VARCHAR(200) NOT NULL,
    dni_presidente CHAR(10) NOT NULL,
    dni_medico CHAR(10) NOT NULL,
    FOREIGN KEY (dni_presidente) REFERENCES Persona(dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (dni_medico) REFERENCES Persona(dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Relación N:M entre Corredor y Sponsor DENTRO de un torneo.
-- (Un corredor tiene varios sponsors en un torneo; un sponsor puede representar varios corredores)
CREATE TABLE Corredor_Sponsor (
    cod_torneo INT NOT NULL,
    cod_corredor INT NOT NULL,
    id_sponsor INT NOT NULL,
    PRIMARY KEY (cod_torneo, cod_corredor, id_sponsor),
    FOREIGN KEY (cod_torneo, cod_corredor) REFERENCES Corredor(cod_torneo, cod_corredor)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (id_sponsor) REFERENCES Sponsor(id_sponsor)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- Bicicletas: los cod_bicicleta son únicos DENTRO de un torneo (por eso PK compuesta)
-- Cada bicicleta está asignada a un corredor (en ese mismo torneo)
CREATE TABLE Bicicleta (
    cod_torneo INT NOT NULL,
    cod_bicicleta INT NOT NULL,
    marca_bicicleta VARCHAR(100) NOT NULL,
    cod_corredor INT NOT NULL,
    PRIMARY KEY (cod_torneo, cod_bicicleta),
    FOREIGN KEY (cod_torneo, cod_corredor) REFERENCES Corredor(cod_torneo, cod_corredor)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

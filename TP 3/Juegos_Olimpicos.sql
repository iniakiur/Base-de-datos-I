DROP DATABASE IF EXISTS JuegosOlimpicos;
CREATE DATABASE JuegosOlimpicos;
USE JuegosOlimpicos;

CREATE TABLE Pais (
    cod_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre_pais VARCHAR(100) NOT NULL
);

CREATE TABLE Deportista (
    id_deportista INT AUTO_INCREMENT PRIMARY KEY,
    nombre_deportista VARCHAR(150) NOT NULL,
    cod_pais INT NOT NULL,
    FOREIGN KEY (cod_pais) REFERENCES Pais(cod_pais)
);

CREATE TABLE Juego (
    anio_olimpiada YEAR PRIMARY KEY,
    cod_pais_sede INT NOT NULL,
    FOREIGN KEY (cod_pais_sede) REFERENCES Pais(cod_pais)
);

CREATE TABLE Disciplina (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nombre_disciplina VARCHAR(100) NOT NULL
);

CREATE TABLE Participacion (
    anio_olimpiada YEAR NOT NULL,
    id_deportista INT NOT NULL,
    id_disciplina INT NOT NULL,
    asistente VARCHAR(150),
    PRIMARY KEY (anio_olimpiada, id_deportista),
    FOREIGN KEY (anio_olimpiada) REFERENCES Juego(anio_olimpiada),
    FOREIGN KEY (id_deportista) REFERENCES Deportista(id_deportista),
    FOREIGN KEY (id_disciplina) REFERENCES Disciplina(id_disciplina)
);

-- Ejemplo de datos
INSERT INTO Pais (nombre_pais) VALUES ('Argentina'), ('Francia'), ('Japón');
INSERT INTO Juego (anio_olimpiada, cod_pais_sede) VALUES (2020, 3), (2024, 2);
INSERT INTO Deportista (nombre_deportista, cod_pais) VALUES ('Lionel Pérez', 1), ('Sofía Gómez', 1), ('Jean Dupont', 2);
INSERT INTO Disciplina (nombre_disciplina) VALUES ('Natación'), ('Atletismo'), ('Ciclismo');
INSERT INTO Participacion (anio_olimpiada, id_deportista, id_disciplina, asistente) VALUES
(2020, 1, 1, 'Carlos Ruiz'),
(2020, 2, 2, 'Ana López'),
(2024, 3, 3, 'Pierre Martin');

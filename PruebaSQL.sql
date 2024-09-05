utilizando psql server 16 en el cmd de windows, necesito

CREATE DATABASE pruebasql_gabriel_munoz_666;

\c pruebasql_gabriel_munoz_666

-----------------------------------------------------------------------------
1. Revisa el tipo de relación y crea el modelo correspondiente.
Respeta las claves primarias, foráneas y tipos de datos.

CREATE TABLE Peliculas (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    ano INTEGER
);

CREATE TABLE Tags (
    id SERIAL PRIMARY KEY,
    tag VARCHAR(32)
);

CREATE TABLE Peliculas_Tags (
    pelicula_id INTEGER REFERENCES Peliculas(id),
    tag_id INTEGER REFERENCES Tags(id),
    PRIMARY KEY (pelicula_id, tag_id)
);

-----------------------------------------------------------------------------
2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados,
la segunda película debe tener 2 tags asociados.

INSERT INTO Peliculas (nombre, ano) VALUES
('Película 1', 2020),
('Película 2', 2021),
('Película 3', 2022),
('Película 4', 2023),
('Película 5', 2024);

INSERT INTO Tags (tag) VALUES
('Acción'),
('Comedia'),
('Drama'),
('Ciencia Ficción'),
('Aventura');

-----------------------------------------------------------------------------
3. Cuenta la cantidad de tags que tiene cada película. Si una película 
no tiene tags debe mostrar 0.

-----------------------------------------------------------------------------
4. Crea las tablas correspondientes respetando los nombres,
tipos, claves primarias y foráneas y tipos de datos.

CREATE TABLE Preguntas (
    id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR(255)
);

CREATE TABLE Respuestas (
    id SERIAL PRIMARY KEY,
    respuestas VARCHAR(255),
    usuario_id INTEGER REFERENCES Usuarios(id),
    pregunta_id INTEGER REFERENCES Preguntas(id)
);

CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER CHECK (edad >= 18),
    email VARCHAR(255) UNIQUE
);

-----------------------------------------------------------------------------
5. Agrega 5 usuarios y 5 preguntas.

INSERT INTO Usuarios (nombre, edad) VALUES
('Usuario 1', 25),
('Usuario 2', 30),
('Usuario 3', 35),
('Usuario 4', 40),
('Usuario 5', 45);

INSERT INTO Preguntas (pregunta, respuesta_correcta) VALUES
('¿Cuál es la capital de Francia?', 'París'),
('¿En qué año comenzó la Segunda Guerra Mundial?', '1939'),
('¿Cuál es el planeta más grande del sistema solar?', 'Júpiter'),
('¿Quién pintó la Mona Lisa?', 'Leonardo da Vinci'),
('¿Cuál es el elemento químico más abundante en el universo?', 'Hidrógeno');

a. La primera pregunta debe estar respondida correctamente dos veces, por dos
usuarios diferentes.
b. La segunda pregunta debe estar contestada correctamente solo por un
usuario.
c. Las otras tres preguntas deben tener respuestas incorrectas.
Contestada correctamente significa que la respuesta indicada en la tabla
respuestas es exactamente igual al texto indicado en la tabla de preguntas.

-----------------------------------------------------------------------------
6. Cuenta la cantidad de respuestas correctas totales por usuario
(independiente de la pregunta).

-----------------------------------------------------------------------------
7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
correctamente.

-----------------------------------------------------------------------------
8. Implementa un borrado en cascada de las respuestas al borrar un usuario.
Prueba la implementación borrando el primer usuario.

-----------------------------------------------------------------------------
9. Crea una restricción que impida insertar usuarios menores de 18 años en la
base de datos.

-----------------------------------------------------------------------------
10. Altera la tabla existente de usuarios agregando el campo email.
Debe tener la restricción de ser único.
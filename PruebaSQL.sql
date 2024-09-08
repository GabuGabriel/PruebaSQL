psql -U postgres
postgres

CREATE DATABASE pruebasql_gabriel_munoz_666;

\c pruebasql_gabriel_munoz_666

-----------------------------------------------------------------------------
1. Revisa el tipo de relación y crea el modelo correspondiente.
Respeta las claves primarias, foráneas y tipos de datos.

Tipo de relación:
Esta es una relación muchos a muchos 
Una película puede tener múltiples tags
Un tag puede estar asociado a múltiples películas

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
    pelicula_id INT,
    tag_id INT,
    PRIMARY KEY (pelicula_id, tag_id),
    FOREIGN KEY (pelicula_id) REFERENCES Peliculas(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
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

INSERT INTO Peliculas_Tags (pelicula_id, tag_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5);          

-----------------------------------------------------------------------------
3. Cuenta la cantidad de tags que tiene cada película. Si una película 
no tiene tags debe mostrar 0.

SELECT p.id, p.nombre, COUNT(pt.tag_id) AS cantidad_tags
FROM Peliculas p
LEFT JOIN Peliculas_Tags pt ON p.id = pt.pelicula_id
GROUP BY p.id, p.nombre
ORDER BY p.id;

o

SELECT p.nombre, COUNT(pt.tag_id) AS cantidad_tags
FROM Peliculas p
LEFT JOIN Peliculas_Tags pt ON p.id = pt.pelicula_id
GROUP BY p.id;

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
    edad INTEGER CHECK (edad >= 18), --restricción de edad
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
INSERT INTO Respuestas (respuestas, usuario_id, pregunta_id)
VALUES ('París', 1, 1), ('París', 2, 1);

b. La segunda pregunta debe estar contestada correctamente solo por un
usuario.
INSERT INTO Respuestas (respuestas, usuario_id, pregunta_id)
VALUES ('1939', 3, 2);

c. Las otras tres preguntas deben tener respuestas incorrectas.
Contestada correctamente significa que la respuesta indicada en la tabla
respuestas es exactamente igual al texto indicado en la tabla de preguntas.
INSERT INTO Respuestas (respuestas, usuario_id, pregunta_id)
VALUES 
('Marte', 4, 3),
('Vincent van Gogh', 5, 4),
('Oxígeno', 1, 5);

-----------------------------------------------------------------------------
6. Cuenta la cantidad de respuestas correctas totales por usuario
(independiente de la pregunta).

SELECT u.nombre, COUNT(r.id) AS respuestas_correctas
FROM Usuarios u
JOIN Respuestas r ON u.id = r.usuario_id
JOIN Preguntas p ON r.pregunta_id = p.id
WHERE r.respuestas = p.respuesta_correcta
GROUP BY u.id, u.nombre;

o

SELECT u.id, u.nombre, COUNT(r.id) as respuestas_correctas
FROM Usuarios u
LEFT JOIN Respuestas r ON u.id = r.usuario_id
LEFT JOIN Preguntas p ON r.pregunta_id = p.id
WHERE r.respuestas = p.respuesta_correcta
GROUP BY u.id, u.nombre
ORDER BY u.id;

-----------------------------------------------------------------------------
7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
correctamente.

SELECT p.pregunta, COUNT(r.id) AS usuarios_correctos
FROM Preguntas p
JOIN Respuestas r ON p.id = r.pregunta_id
WHERE r.respuestas = p.respuesta_correcta
GROUP BY p.id, p.pregunta;

o

SELECT p.id, p.pregunta, COUNT(r.id) as usuarios_correctos
FROM Preguntas p
LEFT JOIN Respuestas r ON p.id = r.pregunta_id
WHERE r.respuestas = p.respuesta_correcta
GROUP BY p.id, p.pregunta
ORDER BY p.id;

-----------------------------------------------------------------------------
8. Implementa un borrado en cascada de las respuestas al borrar un usuario.
Prueba la implementación borrando el primer usuario.

ALTER TABLE Respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD CONSTRAINT respuestas_usuario_id_fkey
FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE;

--probar eliminando el primer usuario
DELETE FROM Usuarios WHERE id = 1;

--verificar
SELECT * FROM Respuestas WHERE usuario_id = 1;

-----------------------------------------------------------------------------
9. Crea una restricción que impida insertar usuarios menores de 18 años en la
base de datos.

-----------------------------------------------------------------------------
10. Altera la tabla existente de usuarios agregando el campo email.
Debe tener la restricción de ser único.

ALTER TABLE Usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

--hay respuestas ya resueltas
--otras necesitan revision  

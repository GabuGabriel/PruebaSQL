psql -U postgres
postgres

CREATE DATABASE pruebasql_gabriel_munoz_777;

\c pruebasql_gabriel_munoz_777

-----------------------------------------------------------------------------
1. Revisa el tipo de relación y crea el modelo correspondiente.
Respeta las claves primarias, foráneas y tipos de datos.

el modelo nos indica ue estas tablas tienen relación de muchos a muchos. 
Una película puede tener múltiples tags
Un tag puede estar asociado a múltiples películas

se requiere una tabla intermedia para conectar las dos tablas principales
(Peliculas y Tags) para resolver la relación muchos a muchos.
con su clave primaria y claves foraneas que hagan referecia a las tablas principales

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

SELECT * FROM Peliculas;
SELECT * FROM Tags;
SELECT * FROM Peliculas_Tags;

-----------------------------------------------------------------------------
2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados,
la segunda película debe tener 2 tags asociados.

INSERT INTO Peliculas (nombre, ano) VALUES
('Pelicula 1', 2020),
('Pelicula 2', 2021),
('Pelicula 3', 2022),
('Pelicula 4', 2023),
('Pelicula 5', 2024);

INSERT INTO Tags (tag) VALUES
('Accion'),
('Comedia'),
('Drama'),
('Ciencia Ficcion'),
('Aventura');

INSERT INTO Peliculas_Tags (pelicula_id, tag_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 4), (2, 5);         

SELECT * FROM Peliculas;
SELECT * FROM Tags;
SELECT * FROM Peliculas_Tags;

-----------------------------------------------------------------------------
3. Cuenta la cantidad de tags que tiene cada película. Si una película 
no tiene tags debe mostrar 0.

SELECT p.nombre, COUNT(pt.tag_id) AS cantidad_tags
FROM Peliculas p
LEFT JOIN Peliculas_Tags pt ON p.id = pt.pelicula_id
GROUP BY p.id;
   nombre   | cantidad_tags
------------+---------------
 Pelicula 3 |             0
 Pelicula 5 |             0
 Pelicula 4 |             0
 Pelicula 2 |             2
 Pelicula 1 |             3
(5 rows)

-----------------------------------------------------------------------------
4. Crea las tablas correspondientes respetando los nombres,
tipos, claves primarias y foráneas y tipos de datos.

CREATE TABLE Preguntas (
    id SERIAL PRIMARY KEY,
    pregunta VARCHAR(255),
    respuesta_correcta VARCHAR(255)
);

CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255),
    edad INTEGER
);

CREATE TABLE Respuestas (
    id SERIAL PRIMARY KEY,
    respuestas VARCHAR(255),
    usuario_id INTEGER REFERENCES Usuarios(id),
    pregunta_id INTEGER REFERENCES Preguntas(id)
);

-----------------------------------------------------------------------------
5. Agrega 5 usuarios y 5 preguntas.

INSERT INTO Usuarios (nombre, edad) VALUES
('Usuario 1', 25),
('Usuario 2', 30),
('Usuario 3', 35),
('Usuario 4', 40),
('Usuario 5', 45);

SELECT * FROM Usuarios;

INSERT INTO Preguntas (pregunta, respuesta_correcta) VALUES
('Cual es la capital de Francia?', 'Paris'),
('En que ano comenzo la Segunda Guerra Mundial?', '1939'),
('Cual es el planeta mas grande del sistema solar?', 'Jupiter'),
('Quien pinto la Mona Lisa?', 'Leonardo da Vinci'),
('Cual es el elemento quimico mas abundante en el universo?', 'Hidrogeno');

SELECT * FROM Preguntas;

a. La primera pregunta debe estar respondida correctamente dos veces, por dos
usuarios diferentes.
INSERT INTO Respuestas (respuestas, usuario_id, pregunta_id) VALUES 
('Paris', 1, 1), ('Paris', 2, 1);

b. La segunda pregunta debe estar contestada correctamente solo por un
usuario.
INSERT INTO Respuestas (respuestas, usuario_id, pregunta_id)
VALUES ('1939', 3, 2);

c. Las otras tres preguntas deben tener respuestas incorrectas.
Contestada correctamente significa que la respuesta indicada en la tabla
respuestas es exactamente igual al texto indicado en la tabla de preguntas.
INSERT INTO Respuestas (respuestas, usuario_id, pregunta_id)
VALUES ('Marte', 4, 3), ('Vincent van Gogh', 5, 4), ('Oxigeno', 1, 5);

SELECT * FROM Respuestas;

-----------------------------------------------------------------------------
6. Cuenta la cantidad de respuestas correctas totales por usuario
(independiente de la pregunta).

Utilizando LEFT JOIN para incluir a todos los usuarios 
y WHERE para filtrar las respuestas que coinciden
con GROUP BY agrupamos los resultados por usuario para contar las respuestas correctas de cada uno

SELECT u.id, u.nombre, COUNT(r.id) as respuestas_correctas
FROM Usuarios u
LEFT JOIN Respuestas r ON u.id = r.usuario_id
LEFT JOIN Preguntas p ON r.pregunta_id = p.id
WHERE r.respuestas = p.respuesta_correcta
GROUP BY u.id, u.nombre
ORDER BY u.id;
 id |  nombre   | respuestas_correctas
----+-----------+----------------------
  1 | Usuario 1 |                    1
  2 | Usuario 2 |                    1
  3 | Usuario 3 |                    1
(3 rows)

-----------------------------------------------------------------------------
7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron
correctamente.

Se utiliza LEFT JOIN para incluir todas las preguntas
y el WHERE para filtrar las correctas
con GROUP BY agrupamos los resultados para contar cuantos respondieron correctamente

SELECT p.id, p.pregunta, COUNT(r.id) as usuarios_correctos
FROM Preguntas p
LEFT JOIN Respuestas r ON p.id = r.pregunta_id
WHERE r.respuestas = p.respuesta_correcta
GROUP BY p.id, p.pregunta
ORDER BY p.id;
 id |                   pregunta                    | usuarios_correctos
----+-----------------------------------------------+--------------------
  1 | Cual es la capital de Francia?                |                  2
  2 | En que ano comenzo la Segunda Guerra Mundial? |                  1
(2 rows)

-----------------------------------------------------------------------------
8. Implementa un borrado en cascada de las respuestas al borrar un usuario.
Prueba la implementación borrando el primer usuario.

Característica que permite que cuando se elimine un registro en una tabla principal,
todos los registros relacionados en las tablas secundarias también se eliminen automáticamente.
Esto es útil para mantener la integridad referencial de la base de datos.

ALTER TABLE Respuestas
DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD CONSTRAINT respuestas_usuario_id_fkey
FOREIGN KEY (usuario_id) REFERENCES Usuarios(id) ON DELETE CASCADE;

--probar eliminando el primer usuario
DELETE FROM Usuarios WHERE id = 1;

--verificar
SELECT * FROM Respuestas WHERE usuario_id = 1;
 id | respuestas | usuario_id | pregunta_id
----+------------+------------+-------------
(0 rows)

-----------------------------------------------------------------------------
9. Crea una restricción que impida insertar usuarios menores de 18 años en la
base de datos.

ALTER TABLE Usuarios
ADD CONSTRAINT check_edad CHECK (edad >= 18);

-----------------------------------------------------------------------------
10. Altera la tabla existente de usuarios agregando el campo email.
Debe tener la restricción de ser único.

ALTER TABLE Usuarios
ADD COLUMN email VARCHAR(255) UNIQUE;

SELECT * FROM Usuarios;

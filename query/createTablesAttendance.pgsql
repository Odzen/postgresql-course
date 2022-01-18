-- CREATE DATABASE Attendance;

DROP TABLE IF EXISTS "Administrador" CASCADE;
DROP TABLE IF EXISTS "Personal" CASCADE;
DROP TABLE IF EXISTS "Docencia Misional" CASCADE;
DROP TABLE IF EXISTS "Curso" CASCADE;
DROP TABLE IF EXISTS "Sede" CASCADE;
DROP TABLE IF EXISTS "Estudiante" CASCADE;
DROP TABLE IF EXISTS "TipoAsistente" CASCADE;
DROP TABLE IF EXISTS "AsistenciaSede";
DROP TABLE IF EXISTS "Matricula";

CREATE TABLE "Administrador" (
  "idAdmin" int PRIMARY KEY,
  "NombreAdmin" varchar(15) NOT NULL,
  "ContraseñaAdmin" varchar(8) NOT NULL
);

CREATE TABLE "Sede" (
  "idSede" serial PRIMARY KEY,
  "NombreSede" varchar(15) NOT NULL,
  "UbicacionSede" varchar(20),
  "idAdmin" int NOT NULL,
  CONSTRAINT "FK_Sede.idAdmin"
    FOREIGN KEY ("idAdmin")
      REFERENCES "Administrador"("idAdmin")
);

CREATE TABLE "TipoAsistente" (
  "idTipo" int PRIMARY KEY CHECK ("idTipo"=1 OR "idTipo"=2 OR "idTipo"=3),
  "tipoAsistente" varchar(5) UNIQUE NOT NULL
);

CREATE TABLE "Personal" (
  "ccP" int PRIMARY KEY,
  "ContraseñaP" varchar(8) NOT NULL,
  "SalarioP" money CONSTRAINT positive_sentP CHECK("SalarioP" > 0::money),
  "EPS_P" varchar(15),
  "ARL_P" varchar(15),
  "Nombre_P" varchar(15) NOT NULL,
  "Apellido_P" varchar(15) NOT NULL,
  "idTipo" int NOT NULL CHECK ("idTipo"=1 OR "idTipo"=2),
  CONSTRAINT "FK_P.idTipo"
    FOREIGN KEY ("idTipo")
      REFERENCES "TipoAsistente"("idTipo")
);

CREATE TABLE "Docencia Misional" (
  "idDM" serial PRIMARY KEY,
  "Departamento_DM" varchar(15),
  "Profesion_DM" varchar(15),
  "ccP" int NOT NULL,
  CONSTRAINT "FK_DM.ccP"
    FOREIGN KEY ("ccP")
      REFERENCES "Personal"("ccP")
);

CREATE TABLE "Curso" (
  "CodigoCurso" varchar(15) PRIMARY KEY,
  "NombreCurso" varchar(15) UNIQUE NOT NULL,
  "NumeroCreditosCurso" int NOT NULL,
  "idDM" int NOT NULL,
  CONSTRAINT "FK_Curso.ccDM"
    FOREIGN KEY ("idDM")
      REFERENCES "Docencia Misional"("idDM")
);

CREATE TABLE "Estudiante" (
  "CodigoEstudiante" int PRIMARY KEY,
  "ContraseñaEst" varchar(8) NOT NULL,
  "DireccionEst" varchar(20),
  "NombreEst" varchar(20) NOT NULL,
  "ApellidoEst" varchar(20) NOT NULL,
  "idTipo" int NOT NULL DEFAULT 3,
  CONSTRAINT "FK_Estudiante.idTipo"
    FOREIGN KEY ("idTipo")
      REFERENCES "TipoAsistente"("idTipo")
);

CREATE TABLE "Matricula" (
  "CodigoEstudiante" int,
  "CodigoCurso" varchar(15),
  "HoraMatricula" time NOT NULL,
  "FechaMatricula" date NOT NULL,
  PRIMARY KEY ("CodigoEstudiante", "CodigoCurso"),
  CONSTRAINT "FK_Matricula.CodigoEstudiante"
    FOREIGN KEY ("CodigoEstudiante")
      REFERENCES "Estudiante"("CodigoEstudiante"),
  CONSTRAINT "FK_Matricula.CodigoCurso"
    FOREIGN KEY ("CodigoCurso")
      REFERENCES "Curso"("CodigoCurso")
);

CREATE TABLE "AsistenciaSede" (
  "idAsistencia" serial PRIMARY KEY,
  "HoraAst" time NOT NULL,
  "FechaAst" date NOT NULL,
  "CodigoEstudiante" int,
  "ccP" int,
  "idSede" int,
  CONSTRAINT "FK_AsistenciaSede.idSede"
    FOREIGN KEY ("idSede")
      REFERENCES "Sede"("idSede"),
  CONSTRAINT "FK_AsistenciaSede.ccP"
    FOREIGN KEY ("ccP")
      REFERENCES "Personal"("ccP"),
  CONSTRAINT "FK_AsistenciaSede.CodigoEstudiante"
    FOREIGN KEY ("CodigoEstudiante")
      REFERENCES "Estudiante"("CodigoEstudiante")
);

-- RESTART SERIAL FIELDS FOR TESTING

-- ALTER SEQUENCE <tablename>_<id>_seq RESTART WITH 1

ALTER SEQUENCE "Sede_idSede_seq" RESTART;

ALTER SEQUENCE "Docencia Misional_idDM_seq" RESTART;

ALTER SEQUENCE "AsistenciaSede_idAsistencia_seq" RESTART;


-- DELETE RECORDS FOR TESTING

TRUNCATE  "Administrador","Sede","TipoAsistente","Personal", "Docencia Misional", "Curso", "Matricula","AsistenciaSede"  CASCADE;


-- INSERT RECORDS FOR TESTING

INSERT INTO "Administrador" ("idAdmin", "NombreAdmin", "ContraseñaAdmin") VALUES
  (543556, 'Admin1', '32423421'), 
  (234521, 'Admin2', '454647'),
  (789182, 'Admin3', '431245');

INSERT INTO "Sede" ("NombreSede", "UbicacionSede", "idAdmin") VALUES
  ('MelendezCali', 'Sur', '543556'),
  ('SanFernandoCali', 'Centro', '543556'),
  ('TuluaRegional', 'Centro', '234521'),
  ('PalmiraRegional', 'Centro', '789182'),
  ('CaucaRegional', 'Centro', '234521');

INSERT INTO "TipoAsistente" ("idTipo", "tipoAsistente") VALUES
  (1, 'NM'), 
  (2, 'DM'),
  (3, 'Est');

INSERT INTO "Personal" ("ccP", "ContraseñaP", "SalarioP", "EPS_P", "ARL_P", "Nombre_P", "Apellido_P", "idTipo") VALUES
  (4848481, '1234s',1000,'SURA','SURA', 'Jefferson', 'Pena', 2),
  (4848482, '1234x',2000,'SOS','SOS', 'Jaime', 'Garzon', 2),
  (4848483, '1234y',590,'Sanitas','Sanitas', 'Alvaro', 'Uribe', 1),
  (4848484, '1234y',590,'Sanitas','Sanitas', 'Gustavo', 'Petro', 1);

INSERT INTO "Docencia Misional" ("Departamento_DM", "Profesion_DM", "ccP") VALUES
  ('Sistemas', 'Ingeniero', 4848481),
  ('Matematicas', 'Matematico', 4848482);

INSERT INTO "Curso" ("CodigoCurso", "NombreCurso", "NumeroCreditosCurso", "idDM") VALUES
  ('76002M', 'Matematicas', 3, 2),
  ('76003M', 'Bases de Datos', 3, 1),
  ('76004M', 'FADA', 2, 1);

INSERT INTO "Estudiante" ("CodigoEstudiante", "ContraseñaEst", "DireccionEst", "NombreEst", "ApellidoEst") VALUES 
  (1744936, '12346', 'cRA 50', 'Juan', 'Velasquez'),
  (1744934, '12345', 'cRA 50', 'Jorge', 'Mayor'),
  (1744933, '12344', 'cRA 50', 'Jorge', 'Mayor');

INSERT INTO "Matricula" ("CodigoEstudiante", "CodigoCurso", "HoraMatricula", "FechaMatricula") VALUES
  (1744936, '76002M', '23:00:00', '2022-01-08'),
  (1744936, '76003M', '23:01:00', '2022-01-08'),
  (1744936, '76004M', '23:02:00', '2022-01-08'),
  (1744934, '76002M', '23:01:00', '2022-01-09'),
  (1744934, '76004M', '23:02:00', '2022-01-10'),
  (1744933, '76004M', '23:02:00', '2022-01-11');

INSERT INTO "AsistenciaSede" ("HoraAst", "FechaAst", "CodigoEstudiante", "ccP", "idSede") VALUES
  ('24:00:00', '2022-02-08', 1744936, NULL, 1),
  ('24:00:00', '2022-02-08', NULL, 4848481, 1),
  ('24:00:00', '2022-08-08', NULL, 4848482, 2),
  ('24:00:00', '2022-12-08', NULL, 4848484, 4),
  ('24:00:00', '2022-12-08', NULL, 4848483, 5),
  ('24:00:00', '2022-05-08', 1744933, NULL, 4),
  ('24:00:00', '2022-05-08', 1744934, NULL, 3);


-- SELECT FOR CHECK THE CONTENT OF EACH TABLE TESTING

SELECT * FROM "Administrador";
SELECT * FROM "Sede";
SELECT * FROM "TipoAsistente";
SELECT * FROM "Personal";
SELECT * FROM "Docencia Misional";
SELECT * FROM "Curso";
SELECT * FROM "Estudiante";
SELECT * FROM "Matricula";
SELECT * FROM "AsistenciaSede";
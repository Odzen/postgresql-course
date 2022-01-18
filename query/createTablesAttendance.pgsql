-- CREATE DATABASE Attendance;

DROP TABLE IF EXISTS "Administrador";
DROP TABLE IF EXISTS "Personal";
DROP TABLE IF EXISTS "Docencia Misional";
DROP TABLE IF EXISTS "Curso";
DROP TABLE IF EXISTS "Sede";
DROP TABLE IF EXISTS "Estudiante";
DROP TABLE IF EXISTS "TipoAsistente";
DROP TABLE IF EXISTS "Estudiante";
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
  "ContraseñaDM" varchar(8) NOT NULL,
  "SalarioDM" money CONSTRAINT positive_sentDM CHECK("SalarioDM" > 0::money),
  "EPS_DM" varchar(15),
  "ARL_DM" varchar(15),
  "Nombre_DM" varchar(15) NOT NULL,
  "Apellido_DM" varchar(15) NOT NULL,
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
  "CodigoCurso" int PRIMARY KEY,
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
  "idTipo" int NOT NULL DEFAULT 1,
  CONSTRAINT "FK_Estudiante.idTipo"
    FOREIGN KEY ("idTipo")
      REFERENCES "TipoAsistente"("idTipo")
);

CREATE TABLE "Matricula" (
  "CodigoEstudiante" int,
  "CodigoCurso" int,
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
  "idAsistentencia" serial PRIMARY KEY,
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
      REFERENCES "Estudiante"("CodigoEstudiante"),
);



-- DELETE RECORDS FOR TESTING

DELETE FROM "Administrador"
WHERE "idAdmin" = 543556;
DELETE FROM "Administrador"
WHERE "idAdmin" = 234521;
DELETE FROM "Administrador"
WHERE "idAdmin" = 789182;


DELETE FROM "Sede"
WHERE "idAdmin" = 543556;
DELETE FROM "Sede"
WHERE "idAdmin" = 234521;
DELETE FROM "Sede"
WHERE "idAdmin" = 789182;



DELETE FROM "Estudiante"
WHERE "CodigoEstudiante" = 1744936;
DELETE FROM "Estudiante"
WHERE "CodigoEstudiante" = 1744934;

DELETE FROM "No Misional"
WHERE "ccNM" = 1005869667;
DELETE FROM "No Misional"
WHERE "ccNM" = 121243254;

DELETE FROM "Docencia Misional"
WHERE "ccDM" = 3245654;
DELETE FROM "Docencia Misional"
WHERE "ccDM" = 1212432;


DELETE FROM "Administrador"
WHERE "idAdmin" = 3246237;

-- RESTART SERIAL FIELDS FOR TESTING


ALTER SEQUENCE "Sede" "idSede" RESTART;

ALTER SEQUENCE "Docencia Misional" "idDM" RESTART;

ALTER SEQUENCE "AsistenciaSede" "idAsistentencia" RESTART;




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

INSERT INTO "Estudiante" ("CodigoEstudiante", "ContraseñaEst", "DireccionEst", "NombreEst", "ApellidoEst") VALUES 
  (1744936, '1234', 'cRA 50', 'Juna', 'Velasquez'),
  (1744934, '123324', 'cRA 50', 'Jorge', 'Mayor');

INSERT INTO "No Misional" ("ccNM", "ContraseñaNM", "NombreNM", "ApellidoNM") VALUES
  (1005869667, '1234s', 'Jefferson', 'Osorio'),
  (121243254, '12ddfg', 'Francisco', 'Gonzalez');

INSERT INTO "Docencia Misional" ("ccDM", "ContraseñaDM", "Nombre_DM", "Apellido_DM") VALUES
  (3245654, '1234s', 'Marcos', 'FF'),
  (1212432, '12asdd', 'Franco', 'A');


INSERT INTO "Administrador" ("idAdmin", "NombreAdmin", "ContraseñaAdmin") VALUES
  (3246237, 'Carlos', '32423421');

INSERT INTO "Sede" ("NombreSede", "UbicacionSede", "idAdmin") VALUES
  ('Melendez', 'asdasd', '3246237');

SELECT * FROM "Sede";


INSERT INTO "AsistenciaSede" ("idAsistente","idSede", "HoraAst", "FechaAst", "idTipo") VALUES
  (3245654,18, '24:00:00', '1999-01-08', 2),
  (1005869667,18, '24:00:00', '1999-01-08',1),
  (1744936,18, '24:00:00', '1999-01-08',3);


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
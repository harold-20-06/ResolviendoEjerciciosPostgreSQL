/*
===========================Cursores==============================

Escribe las sentencias SQL necesarias para crear una base de datos llamada test, una tabla llamada alumnos y 4 
sentencias de inserción para inicializar la tabla. La tabla alumnos está formada por las siguientes columnas:
id (entero sin signo y clave primaria)
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres
fecha_nacimiento (fecha)
*/
-- Crear la base de datos test
CREATE DATABASE test;

-- Crear la tabla de alumnos
CREATE TABLE alumnos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50),
  apellido1 VARCHAR(50),
  apellido2 VARCHAR(50),
  fecha_nacimiento DATE
);

-- Insertar 4 registros iniciales en la tabla de alumnos
INSERT INTO alumnos (nombre, apellido1, apellido2, fecha_nacimiento)
VALUES ('Juan', 'Perez', 'Gomez', '1995-05-15'),
       ('Maria', 'Lopez', 'Gonzalez', '1998-07-20'),
       ('Pepe', 'Fernandez', 'Rodriguez', '2000-01-10'),
       ('Lucia', 'Garcia', 'Martinez', '1999-11-30');
/*
Una vez creada la tabla se decide añadir una nueva columna a la tabla llamada edad que será un valor calculado a 
partir de la columna fecha_nacimiento. Escriba la sentencia SQL necesaria para modificar la tabla y añadir la 
nueva columna.
*/
select * from alumnos
alter table alumnos add column edad integer;
/*
Escriba una función llamada calcular_edad que reciba una fecha y devuelva el número de años que han pasado desde 
la fecha actual hasta la fecha pasada como parámetro:

Función: calcular_edad
Entrada: Fecha
Salida: Número de años (entero)
*/
drop function calcular_edad(fecha DATE); 
create or replace function calcular_edad(fecha DATE) 
returns integer
as $$
declare
anhios int;
begin 
 anhios = extract(year from current_date) - extract(year from fecha); 
 return anhios;
end;
$$ language plpgsql;

select calcular_edad('20-07-1995');
/*
Ahora escriba un procedimiento que permita calcular la edad de todos los alumnmos que ya existen en la tabla. Para
esto será necesario crear un procedimiento llamado actualizar_columna_edad que calcule la edad de cada alumno y 
actualice la tabla. Este procedimiento hará uso de la función calcular_edad que hemos creado en el paso anterior.
*/
drop procedure actualizar_columna_edad();
create or replace procedure actualizar_columna_edad()
as $$
declare 
cur_alumnos cursor for select * from alumnos;
row_alumnos record;
begin
for row_alumnos in cur_alumnos
loop
  begin
  update alumnos set edad = calcular_edad(row_alumnos.fecha_nacimiento) where id = row_alumnos.id;  
  exception 
  when others then
  raise exception 'error, no se actualizo';
  end;
end loop;
end;
$$ language plpgsql;
call actualizar_columna_edad();
select * from alumnos;

--Modifica la tabla alumnos del ejercicio anterior para añadir una nueva columna email. 
alter table alumnos add column email varchar(30);  
select * from alumnos;
/*
Una vez que hemos modificado la tabla necesitamos asignarle una dirección de correo electrónico de forma automática.
Escriba un procedimiento llamado crear_email que dados los parámetros de entrada: nombre, apellido1, apellido2 y 
dominio, cree una dirección de email y la devuelva como salida.

Procedimiento: crear_email
Entrada:
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
dominio (cadena de caracteres)
Salida:
email (cadena de caracteres)
devuelva una dirección de correo electrónico con el siguiente formato:

El primer carácter del parámetro nombre.
Los tres primeros caracteres del parámetro apellido1.
Los tres primeros caracteres del parámetro apellido2.
El carácter @.
El dominio pasado como parámetro.
*/
drop procedure crear_email(in_nombre varchar,in_apellido1 varchar,in_apellido2 varchar,in_dominio varchar,out out_email varchar);
create or replace procedure crear_email(in_nombre varchar,in_apellido1 varchar,in_apellido2 varchar,in_dominio varchar,out out_email varchar)
as $$ 
declare
 cur_alumnos cursor for select * from alumnos;
 row_alumnos record;
begin
  for row_alumnos in cur_alumnos
  loop
  out_email = LEFT(in_nombre, 1) || LEFT(in_apellido1, 3) || LEFT(in_apellido2, 3) || '@' || in_dominio; 
  end loop;
end;
$$ language plpgsql;

CALL crear_email('Juan', 'Perez', 'Gomez', 'miempresa.com','email'); 
/*
Ahora escriba un procedimiento que permita crear un email para todos los alumnmos que ya existen en la tabla. Para
esto será necesario crear un procedimiento llamado actualizar_columna_email que actualice la columna email de la 
tabla alumnos. Este procedimiento hará uso del procedimiento crear_email que hemos creado en el paso anterior.
*/
drop procedure actualizar_columna_email();
create or replace procedure actualizar_columna_email()
as $$ 
declare
 cur_alumnos2 cursor for select * from alumnos;
 row_alumnos record;
 new_email varchar(30);
begin
  for row_alumnos in cur_alumnos2
  loop
  CALL crear_email(row_alumnos.nombre, row_alumnos.apellido1, row_alumnos.apellido2, 'spectrum', new_email);
  update alumnos set email = new_email where id = row_alumnos.id;
  end loop;
end;
$$ language plpgsql;

call actualizar_columna_email();
select * from alumnos;

/*
Escribe un procedimiento llamado crear_lista_emails_alumnos que devuelva la lista de emails de la tabla alumnos 
separados por un punto y coma. Ejemplo: juan@iescelia.org;maria@iescelia.org;pepe@iescelia.org;lucia@iescelia.org.
*/

drop procedure crear_lista_emails_alumnos(out out_lista text);
create or replace procedure crear_lista_emails_alumnos(out out_lista text)
as $$ 
declare
 cur_alumnos3 cursor for select * from alumnos;
 row_alumnos record;
 lista text = '';
begin
  for row_alumnos in cur_alumnos3
  loop
  lista := lista || row_alumnos.email || ';';
  end loop;
  out_lista := lista; 
end;
$$ language plpgsql;

call crear_lista_emails_alumnos('lista');
select * from alumnos;


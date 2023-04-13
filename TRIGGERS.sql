=========================TRIGGERS================================
/*Crea una base de datos llamada db_test que contenga una tabla llamada alumnos con las siguientes columnas.

Tabla alumnos:

id (entero)
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
nota (número real)
*/

create database db_test;

create table alumnos(
	id integer,
	nombre varchar(25),
	apellido1 varchar(25),
	apellido2 varchar(25),
	nota real
);
select * from alumnos

/*Una vez creada la tabla escriba dos triggers con las siguientes características:

Trigger 1: trigger_check_nota_before_insert
Se ejecuta sobre la tabla alumnos.
Se ejecuta antes de una operación de inserción.
Si el nuevo valor de la nota que se quiere insertar es negativo, se guarda como 0.
Si el nuevo valor de la nota que se quiere insertar es mayor que 10, se guarda como 10.
*/

drop function insert_nota();
create function insert_nota()
returns trigger
as $$
declare
begin
  if new.nota < 0 then
  new.nota = 0;
  end if;
  if new.nota > 10 then
  new.nota = 10;
  end if;
  return new;
end;
$$ language plpgsql;

drop trigger trigger_check_nota_before_insert on alumnos;
create trigger trigger_check_nota_before_insert
before insert on alumnos 
for each row
execute function insert_nota();

INSERT INTO alumnos VALUES (1, 'Pepe', 'López', 'López', -1);
INSERT INTO alumnos VALUES (2, 'María', 'Sánchez', 'Sánchez', 11);
INSERT INTO alumnos VALUES (3, 'Juan', 'Pérez', 'Pérez', 8.5);

select * from alumnos;

/*
Trigger2 : trigger_check_nota_before_update
Se ejecuta sobre la tabla alumnos.
Se ejecuta antes de una operación de actualización.
Si el nuevo valor de la nota que se quiere actualizar es negativo, se guarda como 0.
Si el nuevo valor de la nota que se quiere actualizar es mayor que 10, se guarda como 10.
*/
create function update_nota()
returns trigger
as $$
declare
begin
  if new.nota < 0 then
  new.nota = 0;
  end if;
  if new.nota > 10 then
  new.nota = 10;
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trigger_check_nota_before_update
before update on alumnos
for each row
execute function update_nota();

UPDATE alumnos SET nota = -4 WHERE id = 1;
UPDATE alumnos SET nota = 14 WHERE id = 2;
UPDATE alumnos SET nota = 9.5 WHERE id = 3;

select * from alumnos;
====================================================
--Crea una base de datos llamada db_test que contenga una tabla llamada alumnos con las siguientes columnas.
create database db_test;
/*
Tabla alumnos_mail:

id (entero sin signo)
nombre (cadena de caracteres)
apellido1 (cadena de caracteres)
apellido2 (cadena de caracteres)
email (cadena de caracteres)
*/
create table alumnos_mail(
id integer,
nombre varchar(30),
apellido1 varchar(30),
apellido2 varchar(30),
email varchar(40)
);
select * from alumnos_mail
/*
Escriba un procedimiento llamado crear_email que dados los parámetros de entrada: nombre, apellido1, apellido2 y dominio, cree una dirección de email y la devuelva como salida.

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
create or replace procedure crear_email(
	in_nombre varchar,in_apellido1 varchar,in_apellido2 varchar,in_dominio varchar,out out_email varchar)
as $$ 
declare
begin
  out_email = LEFT(in_nombre, 1) || LEFT(in_apellido1, 3) || LEFT(in_apellido2, 3) || '@' || in_dominio; 
end;
$$ language plpgsql;

/*
Una vez creada la tabla escriba un trigger con las siguientes características:

Trigger: trigger_crear_email_before_insert
Se ejecuta sobre la tabla alumnos_mail.
Se ejecuta antes de una operación de inserción.
Si el nuevo valor del email que se quiere insertar es NULL, entonces se le creará automáticamente una dirección de email y se insertará en la tabla.
Si el nuevo valor del email no es NULL se guardará en la tabla el valor del email.
Nota: Para crear la nueva dirección de email se deberá hacer uso del procedimiento crear_email.
*/
select * from alumnos_mail;
create function crear_email_before_insert()
returns trigger
as $$
declare
new_email varchar(30);
begin
  if new.email is null then
     call crear_email(new.nombre,new.apellido1,new.apellido2,'dominio',new_email);
     new.email = new_email;
  end if;
  
  return new;
end;
$$ language plpgsql;

create trigger trigger_crear_email_before_insert
before insert on alumnos_mail
for each row
execute function crear_email_before_insert();

insert into alumnos_mail values (2,'pedro','cazas','limpias','pruebadecorreo@dominio');

select * from alumnos_mail;

/*
Modifica el ejercicio anterior y añade un nuevo trigger que las siguientes características:
Trigger: trigger_guardar_email_after_update:

Se ejecuta sobre la tabla alumnos_mail.
Se ejecuta después de una operación de actualización.
Cada vez que un alumno modifique su dirección de email se deberá insertar un nuevo registro en una tabla llamada log_cambios_email.
La tabla log_cambios_email contiene los siguientes campos:

id: clave primaria (entero autonumérico)
id_alumno: id del alumno (entero)
fecha_hora: marca de tiempo con el instante del cambio (fecha y hora)
old_email: valor anterior del email (cadena de caracteres)
new_email: nuevo valor con el que se ha actualizado
*/
drop table log_cambios_email;
create table log_cambios_email(
id serial,
id_alumno integer,
fecha_hora TIMESTAMP,
old_email varchar(30),
new_email varchar(30)
);

create function guardar_email_after_update()
returns trigger
as $$
declare
new_email varchar(30);
begin
  
  insert into log_cambios_email (id_alumno,fecha_hora,old_email,new_email) 
  						  values(new.id,now(),old.email,new.email);
  return new;
end;
$$ language plpgsql;

create trigger trigger_guardar_email_after_update
after update on alumnos_mail
for each row
execute function guardar_email_after_update();

update alumnos_mail set email = 'pruebacuarta@dominio' where id = 2;  

select * from alumnos_mail;
select * from log_cambios_email;

/*
Modifica el ejercicio anterior y añade un nuevo trigger que tenga las siguientes características:
Trigger: trigger_guardar_alumnos_eliminados:

Se ejecuta sobre la tabla alumnos_mail.
Se ejecuta después de una operación de borrado.
Cada vez que se elimine un alumno de la tabla alumnos se deberá insertar un nuevo registro en una tabla llamada log_alumnos_eliminados.
La tabla log_alumnos_eliminados contiene los siguientes campos:

id: clave primaria (entero autonumérico)
id_alumno: id del alumno (entero)
fecha_hora: marca de tiempo con el instante del cambio (fecha y hora)
nombre: nombre del alumno eliminado (cadena de caracteres)
apellido1: primer apellido del alumno eliminado (cadena de caracteres)
apellido2: segundo apellido del alumno eliminado (cadena de caracteres)
email: email del alumno eliminado (cadena de caracteres)
*/

drop table log_alumnos_eliminados;
create table log_alumnos_eliminados(
id serial,
id_alumno integer,
fecha_hora TIMESTAMP,
nombre varchar(30),    --: nombre del alumno eliminado (cadena de caracteres)
apellido1 varchar(30), --: primer apellido del alumno eliminado (cadena de caracteres)
apellido2 varchar(30), --: segundo apellido del alumno eliminado (cadena de caracteres)
email varchar(30)      --: email del alumno eliminado (cadena de caracteres)
);

create function guardar_alumnos_eliminados()
returns trigger
as $$
declare
new_email varchar(30);
begin
  
  insert into log_alumnos_eliminados (id_alumno,fecha_hora,nombre,apellido1,apellido2,email) 
  						  values(old.id,now(),old.nombre,old.apellido1,old.apellido2,old.email);
  return new;
end;
$$ language plpgsql;

create trigger trigger_guardar_alumnos_eliminados
after delete on alumnos_mail
for each row
execute function guardar_alumnos_eliminados();

delete from alumnos_mail where id = 1;  

select * from alumnos_mail;
select * from log_alumnos_eliminados;

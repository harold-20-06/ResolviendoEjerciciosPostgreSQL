--===================TRANSACCIONES====================
--Transacciones con procedimientos almacenados postgresql 11 en adelante

/*
Crea una base de datos llamada cine que contenga dos tablas con las siguientes columnas.
Tabla cuentas:
id_cuenta: entero (clave primaria).
saldo: real.

Tabla entradas:
id_butaca: entero(clave primaria).
nif: cadena de 9 caracteres.

Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado comprar_entrada con las siguientes 
características. El procedimiento recibe 3 parámetros de entrada (nif, id_cuenta, id_butaca) y devolverá como salida 
un parámetro llamado error que tendrá un valor igual a 0 si la compra de la entrada se ha podido realizar con éxito y
un valor igual a 1 en caso contrario.

El procedimiento de compra realiza los siguientes pasos:

Inicia una transacción.
Actualiza la columna saldo de la tabla cuentas cobrando 5 euros a la cuenta con el id_cuenta adecuado.
Inserta una fila en la tabla entradas indicando la butaca (id_butaca) que acaba de comprar el usuario (nif).
Comprueba si ha ocurrido algún error en las operaciones anteriores. Si no ocurre ningún error entonces aplica un COMMIT 
a la transacción y si ha ocurrido algún error aplica un ROLLBACK.
Deberá manejar los siguientes errores que puedan ocurrir durante el proceso.

ERROR (Out of range value)
ERROR (Duplicate entry for PRIMARY KEY)
¿Qué ocurre cuando intentamos comprar una entrada y le pasamos como parámetro un número de cuenta que no existe en la 
tabla cuentas? ¿Ocurre algún error o podemos comprar la entrada?
En caso de que exista algún error, ¿cómo podríamos resolverlo?. 
*/
drop PROCEDURE comprar_entrada(
  IN p_nif VARCHAR(9),
  IN p_id_cuenta INTEGER,
  IN p_id_butaca INTEGER,
  OUT errors INTEGER
);
CREATE OR REPLACE PROCEDURE comprar_entrada(
  IN p_nif VARCHAR(9),
  IN p_id_cuenta INTEGER,
  IN p_id_butaca INTEGER,
  OUT errors INTEGER
)
AS $$
DECLARE
  saldo_actual int;
BEGIN
  -- Verificar si la cuenta existe antes de seleccionar su saldo
  PERFORM id_cuenta FROM cuentas WHERE id_cuenta = p_id_cuenta;
  IF NOT FOUND THEN
    errors:= 1;
	raise notice 'error %',errors;
    RAISE EXCEPTION 'La cuenta con id_cuenta % no existe', p_id_cuenta;
  END IF;

  SELECT saldo INTO saldo_actual FROM cuentas WHERE id_cuenta = p_id_cuenta FOR UPDATE;
  IF saldo_actual < 5 THEN
    errors := 1;
    raise notice 'error %',errors;
	RAISE EXCEPTION 'Saldo insuficiente';
  END IF;
  UPDATE cuentas SET saldo = saldo - 5 WHERE id_cuenta = p_id_cuenta;
  -- Inserta una fila en la tabla entradas indicando la butaca (id_butaca) que acaba de comprar el usuario (nif)
  BEGIN
    INSERT INTO entradas VALUES (p_id_butaca, p_nif);
  EXCEPTION
    WHEN unique_violation THEN
      errors := 1;
	  raise notice 'error %',errors;
      RAISE EXCEPTION 'La butaca con id_butaca % ya ha sido vendida', p_id_butaca;
  WHEN numeric_value_out_of_range THEN
      RAISE EXCEPTION 'El valor de p_id_butaca está fuera del rango numérico permitido';	  
  END;
  
  -- Si hay un error, revertir el UPDATE
  IF errors = 1 THEN
    RAISE NOTICE 'Revertir UPDATE en cuentas';
    ROLLBACK;
  ELSE raise notice 'La compra de la butaca % fue realizada con exito', p_id_butaca;	
  errors:=0;
  END IF;
END;
$$ LANGUAGE plpgsql;
--------------------------
--llamada al procedure
--------------------------
do $$ 
DECLARE
  p_errors INTEGER;
begin
-- Llamar a la procedimiento almacenado y asignar el valor de errors a la variable
CALL comprar_entrada('123456789', 1235, 8787, p_errors);

-- Imprimir el valor de errors
RAISE NOTICE 'El valor de errors es: %', p_errors;
end;
$$ language plpgsql; 

/*
Ejercicio de transferencia bancaria: Crea un procedimiento que acepte dos parámetros: el número de cuenta de origen 
y el número de cuenta de destino, junto con la cantidad de dinero que se debe transferir de una cuenta a otra. 
Verifica que ambas cuentas existen en la tabla "cuentas" y que la cuenta de origen tiene suficiente saldo para 
realizar la transferencia. Si la verificación es exitosa, realiza la transferencia actualizando el saldo de ambas 
cuentas en la tabla "cuentas". Si la transferencia falla por algún motivo, se debe ejecutar un ROLLBACK para deshacer
cualquier cambio realizado en la base de datos.
*/
CREATE DATABASE transferencias;

CREATE TABLE cuentas (
    id SERIAL PRIMARY KEY,
    numero_cuenta VARCHAR(50) NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL
);

INSERT INTO cuentas (numero_cuenta, saldo) VALUES
    ('1234567890', 1000),
    ('0987654321', 500),
    ('1111111111', 2000);
drop procedure transferir(cuenta_origen varchar(50),cuenta_destino varchar(50),cantidad decimal)
create or replace procedure transferir(cuenta_origen varchar(50),cuenta_destino varchar(50),cantidad decimal)
as $$
declare
saldo_origen decimal;
begin
	perform numero_cuenta FROM cuentas WHERE numero_cuenta IN (cuenta_origen,cuenta_origen) FOR UPDATE;
	
	if not exists (select 1 from cuentas where numero_cuenta = cuenta_origen) then
	raise exception 'La cuenta % de origen no existe',cuenta_origen;
	End if;
	
	if not exists (select 1 from cuentas where numero_cuenta = cuenta_destino) then
	raise exception 'La cuenta % de destino no existe',cuenta_destino;
	End if;
	
	if cantidad <= 0 then
	raise exception 'La cantidad a transferir debe ser mayor que cero';
    end if;
	
	select saldo into saldo_origen from cuentas where numero_cuenta = cuenta_origen;
	
	if saldo_origen < cantidad then
	raise exception 'saldo insuficiente';
	END IF;
		
	begin
	     update cuentas set saldo = saldo - cantidad where numero_cuenta = cuenta_origen;
		 update cuentas set saldo = saldo + cantidad where numero_cuenta = cuenta_destino;
	exception
	  when others then 
	  rollback;
	  raise exception 'ocurrio un error, la transaccion no fue realizada';
	end;
end;
$$ language plpgsql

call transferir('0987654321','1111111111',0);
select * from cuentas;

/*
Ejercicio de actualización en dos tablas: Crea un procedimiento que acepte dos parámetros: el ID de un cliente y su 
nueva dirección. Actualiza la dirección del cliente en la tabla "clientes" y la dirección de envío de todos sus pedidos
en la tabla "pedidos". Verifica que el cliente existe en la tabla "clientes" y que al menos un pedido está asociado con
ese cliente en la tabla "pedidos". Si la verificación es exitosa, realiza ambas actualizaciones dentro de una 
transacción utilizando BEGIN, COMMIT y ROLLBACK. Si alguna de las actualizaciones falla, se debe ejecutar un ROLLBACK
para deshacer cualquier cambio realizado en la base de datos.
*/
CREATE DATABASE clientes_pedidos;
-- Creación de la tabla "clientes"
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL
);

-- Creación de la tabla "pedidos"
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES clientes(id),
    direccion_envio VARCHAR(100) NOT NULL
);

-- Inserción de 10 clientes de ejemplo
INSERT INTO clientes (nombre, direccion) VALUES
    ('Juan Pérez', 'Calle 123, Ciudad'),
    ('María Gómez', 'Avenida 456, Pueblo'),
    ('Luis Hernández', 'Carretera 789, Villa'),
    ('Ana Martínez', 'Calle 321, Ciudad'),
    ('Pedro García', 'Avenida 654, Pueblo'),
    ('Laura Torres', 'Carretera 987, Villa'),
    ('Jorge Sánchez', 'Calle 147, Ciudad'),
    ('Carla Flores', 'Avenida 258, Pueblo'),
    ('Sofía Mendoza', 'Carretera 369, Villa'),
    ('Diego Vásquez', 'Calle 753, Ciudad'),
    ('Juan Valenzuela', 'Av. camacho, NY');

-- Inserción de 30 pedidos de ejemplo (3 para cada cliente)
INSERT INTO pedidos (id_cliente, direccion_envio) VALUES
    (1, 'Calle 123, Ciudad'),
    (1, 'Calle 123, Ciudad'),
    (1, 'Avenida 456, Pueblo'),
    (2, 'Avenida 456, Pueblo'),
    (2, 'Carretera 789, Villa'),
    (2, 'Carretera 789, Villa'),
    (3, 'Calle 321, Ciudad'),
    (3, 'Calle 321, Ciudad'),
    (3, 'Avenida 654, Pueblo'),
    (4, 'Avenida 654, Pueblo'),
    (4, 'Carretera 987, Villa'),
    (4, 'Carretera 987, Villa'),
    (5, 'Calle 147, Ciudad'),
    (5, 'Calle 147, Ciudad'),
    (5, 'Avenida 258, Pueblo'),
    (6, 'Avenida 258, Pueblo'),
    (6, 'Carretera 369, Villa'),
    (6, 'Carretera 369, Villa'),
    (7, 'Calle 753, Ciudad'),
    (7, 'Calle 753, Ciudad'),
    (7, 'Avenida 123, Pueblo'),
    (8, 'Avenida 123, Pueblo'),
    (8, 'Carretera 456, Villa'),
    (8, 'Carretera 456, Villa'),
    (9, 'Calle 789, Ciudad'),
    (9, 'Calle 789, Ciudad'),
    (9, 'Avenida 654, Pueblo'),
    (10, 'Avenida 654, Pueblo'),
    (10, 'Carretera 321, Villa'),
    (10, 'Carretera 321, Villa');

select * from clientes;
select * from pedidos;

drop procedure actualizar_direccion(p_id int,p_direccion varchar(100));
create or replace procedure actualizar_direccion(p_id int,p_direccion varchar(100))
as $$
declare
cantidad integer;
begin
     perform id from clientes where id = p_id for update;
	 if not exists (select 1 from clientes where id=p_id) then 
	 raise exception 'El cliente no existe';
	 end if;
	
	 select count(id_cliente) into cantidad from pedidos where id_cliente = p_id;
	 if cantidad < 1 then
	 raise exception 'el cliente % no tiene pedidos asociados',p_id;
	 end if;
	 
	 begin
	   update clientes set direccion = p_direccion where id = p_id;
	   update pedidos set direccion_envio = p_direccion where id_cliente = p_id;
	 exception
	   when others then
	   rollback;
	   raise exception 'la actualizacion de direcion no fue realizada';
	 end;
end;
$$ language plpgsql;

call actualizar_direccion(1,'calle nueva 567');

/*
Ejercicio de eliminación con restricciones: Crea un procedimiento que acepte un parámetro: el ID de un departamento. 
Elimina el departamento de la tabla "departamentos" y todas las asociaciones con sus empleados en la tabla "empleados".
Verifica que el departamento existe en la tabla "departamentos" y que no tiene empleados asociados en la tabla 
"empleados". Si la verificación es exitosa, realiza ambas eliminaciones dentro de una transacción utilizando BEGIN, 
COMMIT y ROLLBACK. Si alguna de las eliminaciones falla debido a restricciones de clave foránea, se debe ejecutar un 
ROLLBACK para deshacer cualquier cambio realizado en la base de datos.
*/
-- Crear la base de datos
CREATE DATABASE departamentos;

-- Crear tabla departamentos
CREATE TABLE departamentos (
  id_departamento SERIAL PRIMARY KEY,
  nombre_departamento VARCHAR(100)
);

-- Crear tabla empleados
CREATE TABLE empleados (
  id_empleado SERIAL PRIMARY KEY,
  nombre_empleado VARCHAR(100),
  id_departamento INTEGER REFERENCES departamentos(id_departamento)
);

/* 
Borra las tablas e inicia los ids en 1
DELETE FROM empleados;
DELETE FROM departamentos;
SELECT setval('empleados_id_empleado_seq', 1, false);
SELECT setval('departamentos_id_departamento_seq', 1, false);
*/
select * from departamentos
-- Insertar datos en tabla departamentos
INSERT INTO departamentos (nombre_departamento) VALUES ('Ventas');
INSERT INTO departamentos (nombre_departamento) VALUES ('Recursos Humanos');
INSERT INTO departamentos (nombre_departamento) VALUES ('Finanzas');
INSERT INTO departamentos (nombre_departamento) VALUES ('Sistemas');

-- Insertar datos en tabla empleados
INSERT INTO empleados (nombre_empleado, id_departamento) VALUES ('Juan Pérez', 1);
INSERT INTO empleados (nombre_empleado, id_departamento) VALUES ('María Gómez', 1);
INSERT INTO empleados (nombre_empleado, id_departamento) VALUES ('Pedro Rodríguez', 2);
INSERT INTO empleados (nombre_empleado, id_departamento) VALUES ('Laura Martínez', 2);
INSERT INTO empleados (nombre_empleado, id_departamento) VALUES ('Carlos Sánchez', 3);
INSERT INTO empleados (nombre_empleado, id_departamento) VALUES ('Ana Ramírez', 3);

drop procedure eliminar_departamento(p_id_departamento integer);
create or replace procedure eliminar_departamento(p_id_departamento integer)
as $$
declare
cantidad integer;
begin
	 perform id_departamento from departamentos where id_departamento = p_id_departamento for update;
	 if not exists (select 1 from departamentos where id_departamento = p_id_departamento) then 
	 raise exception 'El id del departamento no existe';
	 end if;
	
	 select count(id_departamento) into cantidad from empleados where id_departamento = p_id_departamento;
	 if cantidad > 0 then
	 raise exception 'el departamento % tiene empleados asociados',p_id_departamento;
	 end if;
	 
	 begin
	   delete from departamentos where id_departamento = p_id_departamento;
	   delete from empleados where id_departamento = p_id_departamento;
	 exception
	   when others then
	   rollback;
	   raise exception 'La eliminación del departamento y empleados falló';
	 end;
end;
$$ language plpgsql;

call eliminar_departamento(5);

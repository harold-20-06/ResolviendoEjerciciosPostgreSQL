=======================funciones y procedimiento====================
FUNCIONES
=========

--Escribe una función que reciba un número entero de entrada y devuelva TRUE si el número es par o FALSE en caso contrario.
create or replace function par_impar(numero int)
returns boolean as $$
declare
response boolean := false;
begin
if numero % 2 =0 then
response = true;
end if;
return response;
end;
$$ language plpgsql

select par_impar(8);
--Escribe una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de sus lados.
create or replace function hipotenusa(lado1 DOUBLE PRECISION, lado2 DOUBLE PRECISION)
returns DOUBLE PRECISION
as $$
declare
lado1 float8:= lado1;
lado2 float8:= lado2;
hipotenusa float8; 
begin
hipotenusa = sqrt(lado1*lado1 + lado2*lado2);
return hipotenusa;
end;
$$ language plpgsql
SELECT hipotenusa(3,4)
--Escribe una función que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.
--drop function dias(int)
create or replace function dias(int)
returns text as 
$$
declare
response text;
begin
case $1
when '1' then
response := 'lunes';
when '2' then
response := 'martes';
when '3' then
response := 'miercoles';
when '4' then
response := 'jueves';
when '5' then
response := 'viernes';
else response := 'opcion invalida';
end case;
return response;
end;
$$ language plpgsql

select dias(5)
--Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el mayor de los tres.
create or replace function mayor(decimal,decimal,decimal) 
returns decimal as $$
declare
begin
RETURN GREATEST($1, $2, $3);
end;
$$ language plpgsql

select mayor(4,7,23.5)
--Escribe una función que devuelva el valor del área de un círculo a partir del valor del radio que se recibirá como parámetro de entrada.
CREATE OR REPLACE FUNCTION area_de_circulo(radio numeric)
RETURNS numeric AS $$
BEGIN
  RETURN pi() * radio * radio;
END;
$$ LANGUAGE plpgsql;

select area_de_circulo(5)
--Escribe una función que devuelva como salida el número de años que han transcurrido entre dos fechas que se reciben como parámetros de entrada. Por ejemplo, si pasamos como parámetros de entrada las fechas 2018-01-01 y 2008-01-01 la función tiene que devolver que han pasado 10 años.
CREATE OR REPLACE FUNCTION anios_transcurridos(desde DATE, hasta DATE)
RETURNS INTEGER AS $$
BEGIN
  RETURN EXTRACT(YEAR FROM age(hasta, desde));
END;
$$ LANGUAGE plpgsql;

SELECT anios_transcurridos('2008-01-01', '2018-01-01');
--Escribe una función que reciba una cadena de entrada y devuelva la misma cadena pero sin acentos. 
--La función tendrá que reemplazar todas las vocales que tengan acento por la misma vocal pero sin acento. Por ejemplo, si la función recibe como parámetro de entrada la cadena María la función debe devolver la cadena Maria.
CREATE EXTENSION unaccent;

CREATE OR REPLACE FUNCTION eliminar_acentos(texto text)
RETURNS text AS $$
DECLARE
  cadena_resultado text;
BEGIN
  cadena_resultado := unaccent(texto);
  RETURN cadena_resultado;
END;
$$ LANGUAGE plpgsql;

SELECT eliminar_acentos('María');
==================================================================================

===================PROCEDURES===========================

--Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto ¡Hola mundo!.
drop function saludo()
CREATE FUNCTION saludo() RETURNS void AS $$
    DECLARE
    BEGIN
       raise notice 'Hola mundo';
    END;
$$ LANGUAGE plpgsql;

select saludo();
--Escribe un procedimiento que reciba un número real de entrada y muestre un mensaje indicando si el número es positivo, negativo o cero.
CREATE FUNCTION numero_es(num float8) RETURNS void AS $$
    DECLARE
	numero float8:= num;
    BEGIN
       if numero = 0 then
	   raise notice 'es cero';
	   elsif numero >0 then 
	   raise notice 'es positivo';
	   else 
	   raise notice 'es negativo';
	   end if;
    END;
$$ LANGUAGE plpgsql;

select numero_es(-0.4);
--Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor un número real, y un parámetro de salida, con una cadena de caracteres indicando si el número es positivo, negativo o cero.
drop function numero_es_2(float8)
CREATE FUNCTION numero_es_2(num float8) RETURNS text AS $$
    DECLARE
	numero float8:= num;
    mensaje text;
	BEGIN
       if numero = 0 then
	   mensaje:= 'es cero';
	   elsif numero >0 then 
	   mensaje:= 'es positivo';
	   else 
	   mensaje:= 'es negativo';
	   end if;
    return mensaje;
	END;
$$ LANGUAGE plpgsql;

select numero_es_2(-0.4);
--Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de un alumno, y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes condiciones:
--[0,5) = Insuficiente
--[5,6) = Aprobado
--[6, 7) = Bien
--[7, 9) = Notable
--[9, 10] = Sobresaliente
--En cualquier otro caso la nota no será válida.
CREATE OR REPLACE FUNCTION analizar_nota2(p_nota REAL)
RETURNS void AS $$
BEGIN
  IF p_nota >= 0 AND p_nota < 5 THEN
    raise notice 'Insuficiente';
  ELSIF p_nota >= 5 AND p_nota < 6 THEN
    raise notice 'Aprobado';
  ELSIF p_nota >= 6 AND p_nota < 7 THEN
    raise notice 'Bien';
  ELSIF p_nota >= 7 AND p_nota < 9 THEN
    raise notice 'Notable';
  ELSIF p_nota >= 9 AND p_nota <= 10 THEN
    raise notice 'Sobresaliente';
  ELSE
    raise notice 'Nota no válida';
  END IF;
END;
$$
LANGUAGE plpgsql;

select analizar_nota2(4.5)
--Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor de la nota en formato numérico y un parámetro de salida, con una cadena de texto indicando la nota correspondiente.
CREATE OR REPLACE FUNCTION analizar_nota(p_nota REAL)
RETURNS TEXT AS $$
BEGIN
  IF p_nota >= 0 AND p_nota < 5 THEN
    RETURN 'Insuficiente';
  ELSIF p_nota >= 5 AND p_nota < 6 THEN
    RETURN 'Aprobado';
  ELSIF p_nota >= 6 AND p_nota < 7 THEN
    RETURN 'Bien';
  ELSIF p_nota >= 7 AND p_nota < 9 THEN
    RETURN 'Notable';
  ELSIF p_nota >= 9 AND p_nota <= 10 THEN
    RETURN 'Sobresaliente';
  ELSE
    RETURN 'Nota no válida';
  END IF;
END;
$$
LANGUAGE plpgsql;

select analizar_nota(4.5)
--Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE.
CREATE OR REPLACE FUNCTION analizar_nota3(p_nota REAL)
RETURNS TEXT AS $$
BEGIN
  RETURN CASE
    WHEN p_nota >= 0 AND p_nota < 5 THEN 'Insuficiente'
    WHEN p_nota >= 5 AND p_nota < 6 THEN 'Aprobado'
    WHEN p_nota >= 6 AND p_nota < 7 THEN 'Bien'
    WHEN p_nota >= 7 AND p_nota < 9 THEN 'Notable'
    WHEN p_nota >= 9 AND p_nota <= 10 THEN 'Sobresaliente'
    ELSE 'Nota no válida'
  END;
END;
$$
LANGUAGE plpgsql;

select analizar_nota3(4.5)
--Escribe un procedimiento que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.
create or replace function semana(int) returns text 
as $$
declare
 nombre_dia TEXT;
begin
CASE $1
        WHEN 1 THEN nombre_dia := 'lunes';
        WHEN 2 THEN nombre_dia := 'martes';
        WHEN 3 THEN nombre_dia := 'miércoles';
        WHEN 4 THEN nombre_dia := 'jueves';
        WHEN 5 THEN nombre_dia := 'viernes';
        WHEN 6 THEN nombre_dia := 'sábado';
        WHEN 7 THEN nombre_dia := 'domingo';
        ELSE nombre_dia := 'valor no válido';
    END CASE;
    
    RETURN nombre_dia;
end;
$$ language plpgsql

select semana(5);
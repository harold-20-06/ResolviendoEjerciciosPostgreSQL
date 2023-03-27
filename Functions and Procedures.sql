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


========ESTRUCTURAS CONDICIONALES Y REPETITIVAS========

    ========ESTRUCTURAS CONDICIONALES========

IF-THEN-ELSE
============

--Escribe un programa en PostgreSQL que solicite al usuario ingresar un número y determine si es par o impar. Si es par, debe imprimir "El número ingresado es par", y si es impar, debe imprimir "El número ingresado es impar".
Do $$
declare num int := 4;
begin
if num % 2=0 then
raise notice 'El número ingresado es par';
else
raise notice 'El número ingresado es impar';
end if;
end;
$$ language plpgsql

--Escribe un programa en PostgreSQL que solicite al usuario ingresar un número y determine si es positivo, negativo o cero. Si es positivo, debe imprimir "El número ingresado es positivo", si es negativo debe imprimir "El número ingresado es negativo", y si es cero, debe imprimir "El número ingresado es cero".
Do $$
declare
num int := 0;
begin
if num < 0 then
raise notice 'es negativo';
elseif num > 0 then
raise notice 'es positivo';
else raise notice 'es cero';
end if;
end;
$$ language plpgsql

--Escribe un programa en PostgreSQL que solicite al usuario ingresar su edad y determine si es mayor de edad o no. Si es mayor de edad, debe imprimir "Eres mayor de edad", y si es menor de edad, debe imprimir "Eres menor de edad".
do $$
declare
edad int := 18;
begin
if edad >=18 then
raise notice 'es mayor de edad';
else
raise notice 'es menor de edad';
end if;
end;
$$ language plpgsql

--Escribe un programa en PostgreSQL que solicite al usuario ingresar un número y determine si es divisible por 3 y por 5. Si es divisible por ambos, debe imprimir "El número es divisible por 3 y por 5", si es divisible por solo uno de ellos, debe imprimir "El número es divisible por 3" o "El número es divisible por 5", y si no es divisible por ninguno de ellos, debe imprimir "El número no es divisible por 3 ni por 5".
do $$
declare
x int := 17;
begin
if x % 3 = 0 and x%5=0 then
raise notice 'dibisible entre 3 y 5';
elsif x % 3 = 0 then
raise notice 'entre 3';
elsif x % 5 = 0 then
raise notice 'entre 5';
else 
raise notice 'ninguno';
end if;
end;
$$ language plpgsql

--Escribe un programa en PostgreSQL que solicite al usuario ingresar una letra y determine si es una vocal o una consonante. Si es una vocal, debe imprimir "La letra ingresada es una vocal", y si es una consonante, debe imprimir "La letra ingresada es una consonante".
do $$
declare
letra char := 'b';
begin
if letra in('a','e','i','o','u') then
raise notice 'es vocal';
else
raise notice 'es consonante';
end if;
end;
$$ language plpgsql
==================================================================================

CASE
====

--Escribe un programa en PostgreSQL que solicite al usuario ingresar una letra y determine si es una vocal o una consonante utilizando la estructura CASE. Si es una vocal, debe imprimir "La letra ingresada es una vocal", y si es una consonante, debe imprimir "La letra ingresada es una consonante".
do $$ 
declare
letra char := 'G';
begin
letra = lower(letra); 
case letra   
when 'a' then 
 raise notice 'es vocal';
when 'e' then 
 raise notice 'es vocal';
when 'i' then 
 raise notice 'es vocal';
when 'o' then 
 raise notice 'es vocal';
when 'u' then 
 raise notice 'es vocal';
else raise notice 'es consonante';
end case;
end;
$$ language plpgsql

--Escribe un programa en PostgreSQL que solicite al usuario ingresar un número del 1 al 7 y determine el día de la semana correspondiente utilizando la estructura CASE. Si el número ingresado es 1, debe imprimir "Lunes", si es 2 debe imprimir "Martes", y así sucesivamente hasta llegar al 7, donde debe imprimir "Domingo".
do $$
declare
x int := 4;
begin
case x
when '1' then
raise notice 'lunes';
when '2' then
raise notice 'martes';
when '3' then
raise notice 'miercoles';
when '4' then
raise notice 'jueves';
when '5' then
raise notice 'viernes';
else raise notice 'error en opcion';
end case;
end;
$$ language plpgsql 

--Escribe un programa en PostgreSQL que solicite al usuario ingresar su edad y determine su rango de edad utilizando la estructura CASE. Si la edad está entre 0 y 12, debe imprimir "Eres un niño", si está entre 13 y 18 debe imprimir "Eres un adolescente", si está entre 19 y 59 debe imprimir "Eres un adulto", y si es mayor o igual a 60 debe imprimir "Eres un adulto mayor".
do $$
declare 
edad int := 67;
begin
case 
when edad between 0 and 12 then
raise notice 'niño';
when edad between 13 and 18 then
raise notice 'adolescente';
when edad between 19 and 59 then
raise notice 'adulto';
else raise notice 'adulto mayor';
end case;
end;
$$ language plpgsql

--Escribe un programa en PostgreSQL que solicite al usuario ingresar un número y determine si es par o impar utilizando la estructura CASE. Si el número es par, debe imprimir "El número ingresado es par", y si es impar, debe imprimir "El número ingresado es impar".
do $$ 
declare 
x smallint := 21; 
begin
case  
when x % 2 = 0 then 
raise notice 'es par';
else raise notice 'es impar';
end case;
end;
$$ language plpgsql

--Escribe un programa en PostgreSQL que solicite al usuario ingresar un número del 1 al 12 y determine el mes correspondiente utilizando la estructura CASE. Si el número ingresado es 1, debe imprimir "Enero", si es 2 debe imprimir "Fe
do $$
declare x smallint := 7;  
begin
case x
when '1' then
raise notice 'enero';
when '2' then
raise notice 'febrero';
when '3' then
raise notice 'marzo';
when '4' then
raise notice 'abril';
when '5' then
raise notice 'mayo';
when '6' then
raise notice 'junio';
when '7' then
raise notice 'julio';
when '8' then
raise notice 'agosto';
when '9' then
raise notice 'septiembre';
when '10' then
raise notice 'octubre';
when '11' then
raise notice 'noviembre';
when '12' then
raise notice 'diciembre';
else raise notice 'error en la opcion';
end case;
end;
$$ language plpgsql
=============================================================================================
    
    ========ESTRUCTURAS REPETITIVAS========

Ejercicios de LOOP:
===================

--Escriba un programa que imprima los números pares del 1 al 10 utilizando una estructura LOOP.
do $$
declare 
x int:= 0;
begin
LOOP
x = x + 2;
raise notice '%',x;
IF x >= 10 THEN
exit; 
END IF;
END LOOP; 
end;
$$ language plpgsql

--Escriba un programa que calcule la suma de los primeros 100 números enteros utilizando una estructura LOOP.
do $$
declare
num int = 0;
s   int = 0;
begin 
loop
num=num+1;
s = s+num;
if num = 100 then
raise notice 'la suma de los primeros 100 numeros es = %',s;
exit;
end if;
end loop;
end;
$$ language plpgsql

--Escriba un programa que imprima una tabla de multiplicación del 1 al 5 utilizando una estructura LOOP.
DO $$
declare
x,y int := 0;
begin
loop
raise notice '=======';
x=x+1;
y=0;
loop
y=y+1;
raise notice '% x % = %',x,y,x*y;
if y >= 10 then
exit;
end if;
end loop;
if x>=5 then
exit;
end if;
end loop;
end;
$$ LANGUAGE PLPGSQL

--Escriba un programa que lea una lista de números enteros del usuario y calcule su suma utilizando una estructura LOOP.
do $$
declare nums int[] := '{1,1,1,1,1,1,1,1,1,1}';
x int := 0;
s int := 0;
begin 
loop 
x = x + 1;
s = s + nums[x];
if x >= 10 then
raise notice '%',s;
exit;
end if;
end loop;
end;
$$ language plpgsql

--Escriba un programa que lea una lista de números enteros del usuario y calcule su promedio utilizando una estructura LOOP.
do $$
declare nums int[] := '{1,2,1,1,1,1,1,1,1,1}';
x int := 0;
s int := 0;
promedio decimal;
begin 
loop
x = x + 1;
s = s + nums[x];
if x >= 10 then
promedio = s / array_length(nums,1); 
raise notice '% / % = %',s,array_length(nums,1),s / array_length(nums,1);
exit;
end if;
end loop;
end;
$$ language plpgsql
========================================================================================

Ejercicios de loop:
=====================

--Escriba un programa que imprima los números impares del 1 al 10.
DO $$
DECLARE
  x int := -1;
BEGIN 
  LOOP
    x := x + 2;
	RAISE NOTICE '%',x;
    EXIT WHEN x = 9;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

--Escriba un programa que calcule la suma de los primeros 50 números pares.
DO $$
declare 
s int := 0;
c int :=0;
begin 
loop
c=c+2;
s=s+c;
exit when c = 50;
end loop;
raise notice 'la suma es %',s;
end;
$$ language plpgsql

--Escriba un programa que lea una lista de números enteros del usuario y muestre el valor máximo.
do $$
declare
nums int[] := '{1,5,2,4,23,8,6,10,7,9}';
max int :=0;
i int :=0;
begin
loop
i=i+1;
if nums[i]>max then 
max := nums[i];
end if;
exit when array_length(nums,1) = i; 
end loop;
raise notice 'el mayor es %',max;
end;
$$ language plpgsql

--Escriba un programa que lea una lista de números enteros del usuario y muestre el valor mínimo.
do $$
declare
nums int[] := '{1,5,2,4,23,8,6,10,7,9}';
min int :=1000000;
i int :=0;
begin
loop
i=i+1;
if nums[i]<min then 
min := nums[i];
end if;
exit when array_length(nums,1) = i; 
end loop;
raise notice 'el menor es %',min;
end;
$$ language plpgsql

--Escriba un programa que lea una lista de números enteros del usuario y muestre la cantidad de números pares.
do $$
declare 
nums int[] := '{4,1,5,2,4,23,8,6,10,7,9}';
i int :=1;
c int := 0;
begin 
loop
if nums[i] % 2 = 0 then
c=c+1;
end if;
i=i+1;
exit when i = array_length(nums,1);  
end loop;
raise notice 'son % pares',c;
end;
$$ language plpgsql
=============================================================================================

Ejercicios de WHILE:
====================

--Escriba un programa que imprima los números del 1 al 10 utilizando una estructura WHILE.
do $$
declare i int = 1;
begin
while i<=10 loop
raise notice '%',i;
i=i+1;
end loop;
end
$$ language plpgsql

--Escriba un programa que calcule la suma de los primeros 25 números impares.
DO $$
DECLARE
i INTEGER := 1;
s int := 0;
c int :=0;
BEGIN
WHILE c < 25 LOOP
 if i % 2 != 0 then
 c = c+1;
 s = s+i;
 end if;
 i=i+1;
END LOOP;
raise notice 'la suma de los % impares es %',c,s;
END 
$$ language plpgsql;

--Escriba un programa que lea una lista de números enteros del usuario y muestre la cantidad de números negativos utilizando una estructura WHILE.
DO $$
DECLARE nums int []:= '{1,2,3,4,5,6,7,-1,5,-6}';
i int := 1;
c int :=0;
BEGIN
WHILE i <= array_length(nums,1) LOOP
 if nums[i] < 0 then
 c = c+1;
 end if;
 i=i+1;
END LOOP;
raise notice 'la cantidad de negativos es %',c;
END 
$$ language plpgsql;

--Lea una lista de números enteros del usuario y muestre la cantidad de números mayores a 100.
DO $$
DECLARE nums int []:= '{102,2,300,4,5,6,7,-1,5,-6,980}';
i int := 1;
cp int :=0;
ci int :=0;
BEGIN
WHILE i <= array_length(nums,1) LOOP
 if nums[i] %2 =0 then
 cp = cp+1;
 else 
 ci = ci+1;
 end if;
 i=i+1;
END LOOP;
raise notice 'Son % pares y % impares',cp,ci;
END 
$$ language plpgsql;

--Lea una lista de números enteros del usuario y muestre la cantidad de números pares y la cantidad de números impares.
DO $$
DECLARE nums int []:= '{102,2,300,4,5,6,7,-1,5,-6,980}';
i int := 1;
c int :=0;
BEGIN
WHILE i <= array_length(nums,1) LOOP
 if nums[i] > 100 then
 c = c+1;
 end if;
 i=i+1;
END LOOP;
raise notice 'la cantidad de >100 es %',c;
END 
$$ language plpgsql;
===============================================================================================

Ejercicios de FOR
=================

--Sumar los números del 1 al 10 y devolver el resultado.
do $$
declare 
s int :=0;
begin
for i in 1..10 loop
s=s+i;
raise notice '%',i;
end loop;
raise notice 'la suma de los numeros es %',s;
end
$$ language plpgsql

--Multiplicar los elementos de un array de números enteros y devolver el resultado.
do $$
declare
nums int[]:= '{1,4,2,3}';
m int=1;
begin 
for i in 1..array_length(nums,1) loop
m=m*nums[i];
end loop;
raise notice 'el producto es %',m;
end
$$ language plpgsql

--Generar una secuencia de 10 números aleatorios y devolver un array con los números generados.
do $$
declare
nums int[10];
begin 
for i in 1..10 loop
nums[i]:= floor(random() * 100) + 1;
end loop;
for i in 1..array_length(nums,1) loop
raise notice '%=> %',i,nums[i];
end loop;
end
$$ language plpgsql

--Invertir el orden de los elementos de un array de números enteros y devolver el resultado.
DO $$
DECLARE
  nums int[] := '{1, 2, 3, 4, 5}';
  len int := array_length(nums, 1);
  reversed_nums int[];
BEGIN
  FOR i IN 1..len LOOP
    reversed_nums[i] := nums[len-i+1];
  END LOOP;
  
  RAISE NOTICE 'Array original: %', nums;
  RAISE NOTICE 'Array invertido: %', reversed_nums;
END;
$$ LANGUAGE plpgsql;

--Buscar el valor máximo en un array de números enteros y devolver el resultado.
DO $$
DECLARE
  nums int[] := '{1, 2, 3, 4, 5}';
  len int := array_length(nums, 1);
 BEGIN
  FOR i IN 1..len LOOP
    reversed_nums[i] := nums[len-i+1];
  END LOOP;
  
  RAISE NOTICE 'Array original: %', nums;
  RAISE NOTICE 'Array invertido: %', reversed_nums;
END;
 $$ LANGUAGE plpgsql;
--SOLUCION EJERCICIOS PLANTEADOS SQL EN https://josejuansanchez.org/bd/ejercicios-consultas-sql/index.html
--REALIZADO en postgreSQL pgAdmin 4 V6 POR Harold Montecinos Mujiano enero 2023

--=====================================================================================================

--Computer store
--create DB

drop database if exists tienda;
create database tienda; 

--create tables

create table fabricante(
	codigo serial primary key,
	nombre varchar(100) not null
);

alter table fabricante rename column codigo to id ;

create table producto(
	id serial primary key,
	nombre varchar(100) not null,
	precio float not null,
	id_fabricante int not null,
	constraint producto_fkey
	foreign key(id_fabricante)
	references fabricante (id)	
);
 
--inserts

INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');

INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

select * from fabricante 
select * from producto

--Consultas sobre una tabla

--Lista el nombre de todos los productos que hay en la tabla producto.
select * from producto
select nombre from producto
--Lista los nombres y los precios de todos los productos de la tabla producto.
select * from producto
select nombre,precio from producto
--Lista todas las columnas de la tabla producto.
select * from producto
--Lista el nombre de los productos, el precio en euros y el precio en dólares estadounidenses (USD).
select nombre, (precio/6,97), (precio/8) from producto
--Lista el nombre de los productos, el precio en euros y el precio en dólares estadounidenses (USD). Utiliza los siguientes alias para las columnas: nombre de producto, euros, dólares.
select nombre as Nombre, (precio/6,97) as precio_Dolares, (precio/8) as precio_Euros from producto
--Lista los nombres y los precios de todos los productos de la tabla producto, convirtiendo los nombres a mayúscula.
select upper(nombre),precio from producto
--Lista los nombres y los precios de todos los productos de la tabla producto, convirtiendo los nombres a minúscula.
select lower (nombre),precio from producto
--Lista el nombre de todos los fabricantes en una columna, y en otra columna obtenga en mayúsculas los dos primeros caracteres del nombre del fabricante.
select * from producto
select nombre, upper(substring(nombre,1,2)) from producto
--Lista los nombres y los precios de todos los productos de la tabla producto, redondeando el valor del precio.
select nombre, ceiling(precio) from producto
--Lista los nombres y los precios de todos los productos de la tabla producto, truncando el valor del precio para mostrarlo sin ninguna cifra decimal.
select nombre, trunc(precio) from producto
--Lista el identificador de los fabricantes que tienen productos en la tabla producto.
select * from producto
select id_fabricante from producto
--Lista el identificador de los fabricantes que tienen productos en la tabla producto, eliminando los identificadores que aparecen repetidos.
select * from producto
select id_fabricante from producto
group by id_fabricante
--Lista los nombres de los fabricantes ordenados de forma ascendente.
select id_fabricante from producto
group by id_fabricante
order by id_fabricante asc
--Lista los nombres de los fabricantes ordenados de forma descendente.
select id_fabricante from producto
group by id_fabricante
order by id_fabricante desc
--Lista los nombres de los productos ordenados en primer lugar por el nombre de forma ascendente y en segundo lugar por el precio de forma descendente.
select nombre, precio from producto
order by nombre asc, precio desc 
--Devuelve una lista con las 5 primeras filas de la tabla fabricante.
select * from fabricante limit 5
--Devuelve una lista con 2 filas a partir de la cuarta fila de la tabla fabricante. La cuarta fila también se debe incluir en la respuesta.
select * from fabricante limit 2 offset 3
--Lista el nombre y el precio del producto más barato. (Utilice solamente las cláusulas ORDER BY y LIMIT)
select nombre,precio from producto 
order by precio asc limit 1
--Lista el nombre y el precio del producto más caro. (Utilice solamente las cláusulas ORDER BY y LIMIT)
select nombre,precio from producto 
order by precio desc limit 1
--Lista el nombre de todos los productos del fabricante cuyo identificador de fabricante es igual a 2.
select id_fabricante, nombre from producto where id_fabricante = 2
--Lista el nombre de los productos que tienen un precio menor o igual a 120€.
select nombre, precio from producto where precio <= 120
--Lista el nombre de los productos que tienen un precio mayor o igual a 400€.
select nombre,precio from producto where precio >=400
--Lista el nombre de los productos que no tienen un precio mayor o igual a 400€.
select nombre,precio from producto where precio < 400
--Lista todos los productos que tengan un precio entre 80€ y 300€. Sin utilizar el operador BETWEEN.
select * from producto where precio > 80 and precio < 300 
--Lista todos los productos que tengan un precio entre 60€ y 200€. Utilizando el operador BETWEEN.
select * from producto where precio between 60 and 300 
--Lista todos los productos que tengan un precio mayor que 200€ y que el identificador de fabricante sea igual a 6.
select * from producto where precio > 200 and id_fabricante =6
--Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. Sin utilizar el operador IN.
select * from producto where id_fabricante = 1 or id_fabricante = 3 or id_fabricante = 5 
--Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. Utilizando el operador IN.
select * from producto where id_fabricante in (1,3,5)  
--Lista el nombre y el precio de los productos en céntimos (Habrá que multiplicar
--por 100 el valor del precio). Cree un alias para la columna que contiene el precio que se
--llame céntimos.
select nombre,(precio*100) as centimos from producto 
--Lista los nombres de los fabricantes cuyo nombre empiece por la letra S.
select nombre from fabricante where nombre like 'S%'
--Lista los nombres de los fabricantes cuyo nombre termine por la vocal e.
select nombre from fabricante where nombre like '%e'
--Lista los nombres de los fabricantes cuyo nombre contenga el carácter w.
select nombre from fabricante where nombre like '%w%'
--Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres.
select nombre from fabricante where length(nombre) = 4 
--Devuelve una lista con el nombre de todos los productos que contienen la cadena Portátil en el nombre.
select nombre from producto where nombre like '%Portátil%' 
--Devuelve una lista con el nombre de todos los productos que contienen la cadena Monitor en el nombre y tienen un precio inferior a 215 €.
select nombre,precio from producto where nombre like '%Monitor%' and precio <215 
--Lista el nombre y el precio de todos los productos que tengan un precio mayor o igual a 180€. 
--Ordene el resultado en primer lugar por el precio (en orden descendente) y en segundo lugar por el
--nombre (en orden ascendente).
select nombre, precio from producto where precio >=180 order by precio desc, nombre asc
--Fin Consultas sobre una tabla


--Consultas multitabla (Composición interna)
--Utilizando sintaxis SQL1 y SQL2.


--Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos.
select p.nombre, p.precio, f.nombre from producto p, fabricante f where p.id_fabricante = f.id;
--
select p.nombre, p.precio, f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id;
--Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos de la base de datos. 
--Ordene el resultado por el nombre del fabricante, por orden alfabético.
select p.nombre as nombre_producto, p.precio, f.nombre as nombre_fabricante from producto p,fabricante f 
where p.id_fabricante = f.id order by f.nombre asc;
--
select p.nombre as nombre_producto, p.precio, f.nombre as nombre_fabricante from producto p inner join fabricante f 
on p.id_fabricante = f.id order by f.nombre asc

--Devuelve una lista con el identificador del producto, nombre del producto, identificador del 
--fabricante y nombre del fabricante, de todos los productos de la base de datos.
select p.id, p.nombre, f.id, f.nombre from producto p, fabricante f where f.id = p.id_fabricante
--
select p.id, p.nombre, f.id, f.nombre from producto p inner join fabricante f on f.id = p.id_fabricante
--Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.
select p.nombre, p.precio, f.nombre from producto p, fabricante f where p.id_fabricante = f.id
and p.precio = (select min(precio) from producto)
--
select p.nombre, p.precio, f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id
and p.precio = (select min(precio) from producto)   
--Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más caro.
select p.nombre, p.precio, f.nombre from producto p, fabricante f where p.id_fabricante = f.id
and p.precio = (select max(precio) from producto)
--
select p.nombre, p.precio, f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id
and p.precio = (select max(precio) from producto)   

--Devuelve una lista de todos los productos del fabricante Lenovo.
select p.nombre,p.precio, f.nombre from producto p, fabricante f where p.id_fabricante = f.id
and f.nombre = 'Lenovo'
--
select p.nombre,p.precio, f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id
and f.nombre = 'Lenovo'

--Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que 200€.
select * from producto p, fabricante f where p.id_fabricante = f.id and f.nombre ='Crucial' and p.precio >200
--
select * from producto p inner join fabricante f on p.id_fabricante = f.id and f.nombre ='Crucial' and p.precio >200
--Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard y Seagate. Sin utilizar el operador IN.
select * from producto p, fabricante f where p.id_fabricante = f.id and (f.nombre ='Asus' or f.nombre ='Hewlett-Packard' or f.nombre ='Seagate')
--
select * from producto p inner join fabricante f on p.id_fabricante = f.id and (f.nombre ='Asus' or f.nombre ='Hewlett-Packard' or f.nombre ='Seagate')
--Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy Seagate. Utilizando el operador IN.
select * from producto p, fabricante f where p.id_fabricante = f.id and f.nombre in ('Asus','Hewlett-Packard','Seagate')
--
select * from producto p inner join fabricante f on p.id_fabricante = f.id and f.nombre in ('Asus','Hewlett-Packard','Seagate')
--Devuelve un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre termine por la vocal e.
select p.nombre,p.precio,f.nombre from producto p, fabricante f where p.id_fabricante = f.id and f.nombre like '%e'
--
select p.nombre,p.precio,f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id and f.nombre like '%e'
--Devuelve un listado con el nombre y el precio de todos los productos cuyo nombre de fabricante contenga el carácter w en su nombre.
select p.nombre,p.precio,f.nombre from producto p, fabricante f where p.id_fabricante = f.id and f.nombre like '%w%'
--
select p.nombre,p.precio,f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id and f.nombre like '%w%'
--Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos los productos que tengan un precio mayor o igual a 180€. 
--Ordene el resultado en primer lugar por el precio (en orden descendente) y en segundo lugar por el nombre (en orden ascendente)
select p.nombre,p.precio,f.nombre from producto p, fabricante f where p.id_fabricante = f.id and p.precio >= 180
order by p.precio desc, p.nombre asc
--
select p.nombre,p.precio,f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id and p.precio >= 180
order by p.precio desc, p.nombre asc
--Devuelve un listado con el identificador y el nombre de fabricante, solamente de aquellos fabricantes que tienen productos asociados en la base de datos.
select f.id,f.nombre from producto p, fabricante f where p.id_fabricante = f.id group by f.id 
--
select f.id,f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id group by f.id 
--Fin Consultas Multitabla (Composición interna)

--Consultas Multitabla (Composición externa)
--Consultas utilizando LEFT JOIN y RIGHT JOIN.

--Devuelve un listado de todos los fabricantes que existen en la base de datos, junto con los productos que 
--tiene cada uno de ellos. El listado deberá mostrar también aquellos fabricantes que no tienen producto sasociados.
select * from producto p right join fabricante f on p.id_fabricante = f.id
--Devuelve un listado donde sólo aparezcan aquellos fabricantes que no tienen ningún producto asociado.
select * from producto p right join fabricante f on p.id_fabricante = f.id where p.id is null
--¿Pueden existir productos que no estén relacionados con un fabricante? Justifique su respuesta.
no pueden existir por que el campo id_fabricante es NOT NULL.
--Consultas Multitabla (Composición externa)

--Consultas resumen
--Calcula el número total de productos que hay en la tabla productos.
select count(id) from producto
--Calcula el número total de fabricantes que hay en la tabla fabricante.
select count(*) from fabricante
--Calcula el número de valores distintos de identificador de fabricante aparecen en la tabla productos.
select count(distinct (id_fabricante)) from producto
--Calcula la media del precio de todos los productos.
select avg(precio) from producto
--Calcula el precio más barato de todos los productos.
select min(precio) from producto
--Calcula el precio más caro de todos los productos.
select max(precio) from producto
--Lista el nombre y el precio del producto más barato.
select nombre, precio from producto where precio = (select min(precio) from producto)
--Lista el nombre y el precio del producto más caro.
select nombre, precio from producto where precio = (select max(precio) from producto)
--Calcula la suma de los precios de todos los productos.
select sum(precio) from producto
--Calcula el número de productos que tiene el fabricante Asus.
select count(p.id) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Asus'
--Calcula la media del precio de todos los productos del fabricante Asus.
select avg(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Asus'
--Calcula el precio más barato de todos los productos del fabricante Asus.
select min(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Asus'
--Calcula el precio más caro de todos los productos del fabricante Asus.
select max(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Asus'
--Calcula la suma de todos los productos del fabricante Asus.
select sum(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Asus'
--Muestra el precio máximo, precio mínimo, precio medio y el número total de productos que tiene el fabricante Crucial.
select max(precio),min(precio),avg(precio), count(p.id) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Crucial'
--Muestra el número total de productos que tiene cada uno de los fabricantes. 
--El listado también debe incluir los fabricantes que no tienen ningún producto. 
--El resultado mostrará dos columnas, una con el nombre del fabricante y otra con el número de productos 
--que tiene. Ordene el resultado descendentemente por el número de productos.
select count(p.nombre) as cantidad,f.nombre from producto p right join fabricante f on p.id_fabricante = f.id group by f.nombre order by cantidad desc
--Muestra el precio máximo, precio mínimo y precio medio de los productos de cada uno de los fabricantes. 
--El resultado mostrará el nombre del fabricante junto con los datos que se solicitan.
select max(p.precio), min(p.precio), avg(p.precio),f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id group by f.nombre 
--Muestra el precio máximo, precio mínimo, precio medio y el número total de productos de los fabricantes que
--tienen un precio medio superior a 200€. No es necesario mostrar el nombre del fabricante, 
--con el identificador del fabricante es suficiente.
select max(p.precio), min(p.precio), avg(p.precio),f.id from producto p inner join fabricante f on p.id_fabricante = f.id group by f.id having avg(p.precio) > 200
--Muestra el nombre de cada fabricante, junto con el precio máximo, precio mínimo, precio medio y 
--el número total de productos de los fabricantes que tienen un precio medio superior a 200€. 
--Es necesario mostrar el nombre del fabricante.
select max(p.precio), min(p.precio), avg(p.precio),f.id,f.nombre from producto p inner join fabricante f on p.id_fabricante = f.id group by f.id having avg(p.precio) > 200
--Calcula el número de productos que tienen un precio mayor o igual a 180€.
select count(precio) from producto where precio >= 180
--Calcula el número de productos que tiene cada fabricante con un precio mayor o igual a 180€.
select f.nombre,f.id, p.precio from producto p inner join fabricante f on f.id = p.id_fabricante where precio >= 180
--Lista el precio medio los productos de cada fabricante, mostrando solamente el identificador del fabricante.
select avg(precio),id_fabricante from producto group by id_fabricante
--Lista el precio medio los productos de cada fabricante, mostrando solamente el nombre del fabricante.
select avg(precio),f.nombre
from producto p inner join fabricante f
on p.id_fabricante = f.id
group by f.nombre
--Lista los nombres de los fabricantes cuyos productos tienen un precio medio mayor o igual a 150€.
select avg(precio),f.nombre
from producto p inner join fabricante f
on p.id_fabricante = f.id
group by f.nombre
having avg(precio)>=150
--Devuelve un listado con los nombres de los fabricantes que tienen 2 o más productos.
select f.nombre, count(p.nombre)
from producto p inner join fabricante f
on p.id_fabricante = f.id
group by f.nombre
having count(p.nombre)>=2
--Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con un precio 
--superior o igual a 220 €. No es necesario mostrar el nombre de los fabricantes que no tienen productos que cumplan la condición.
select f.nombre, count(p.nombre)
from producto p inner join fabricante f
on p.id_fabricante = f.id
where precio >= 220
group by f.nombre
--Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada uno con un precio 
--superior o igual a 220 €. El listado debe mostrar el nombre de todos los fabricantes, es decir, si hay algún
--fabricante que no tiene productos con un precio superior o igual a 220€ deberá aparecer en el listado con un 
--valor igual a 0 en el número de productos.
select f.nombre, count(p.nombre) as cantidad
from producto p right join fabricante f
on p.id_fabricante = f.id
and precio >= 220 
group by f.nombre 
order by cantidad desc

--Devuelve un listado con los nombres de los fabricantes donde la suma del precio de todos sus productos es 
--superior a 1000 €.
select f.nombre, sum(p.precio) as cantidad
from producto p inner join fabricante f
on p.id_fabricante = f.id
group by f.nombre 
having sum(p.precio) > 1000 
--Devuelve un listado con el nombre del producto más caro que tiene cada fabricante. El resultado debe tener 
--tres columnas: nombre del producto, precio y nombre del fabricante. El resultado tiene que estar ordenado 
--alfabéticamente de menor a mayor por el nombre del fabricante.
select f.nombre,max(p.precio) as maximo
from producto p inner join fabricante f
on p.id_fabricante = f.id
group by f.nombre
order by f.nombre asc

--Fin consultas resumen


--Subconsultas (En la cláusula WHERE)
--Con operadores básicos de comparación

--Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).
select p.* from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Lenovo'
--Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del 
--fabricante Lenovo. (Sin utilizar INNER JOIN).
select * from producto p 
where precio = (select max(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Lenovo')  
--Lista el nombre del producto más caro del fabricante Lenovo.
select nombre from producto 
where precio = (select max(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Lenovo')
--Lista el nombre del producto más barato del fabricante Hewlett-Packard.
select nombre from producto 
where precio = (select min(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Hewlett-Packard')
--Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al producto más caro del fabricante Lenovo.
select * from producto 
where precio >= (select max(precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Lenovo')
--Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus productos.
select * from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Asus'
and p.precio > (select avg(p.precio) from producto p, fabricante f where p.id_fabricante = f.id and f.nombre = 'Asus')

--Subconsultas con ALL y ANY

--Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER BY ni LIMIT.
select nombre, precio from producto where precio >= all (select precio from producto)
--Devuelve el producto más barato que existe en la tabla producto sin hacer uso de MIN, ORDER BY ni LIMIT.
select nombre, precio from producto where precio <= all (select precio from producto)
--Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando ALL o ANY).
select f.nombre from fabricante f 
where f.id = any (select id_fabricante from producto)
--Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando ALL o ANY).
select f.nombre from fabricante f 
where f.id <> all (select id_fabricante from producto)
--Subconsultas con IN y NOT IN

--Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).
select f.nombre from fabricante f 
where f.id in (select id_fabricante from producto)
--Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN).
select f.nombre from fabricante f 
where f.id not in (select id_fabricante from producto)
--Subconsultas con EXISTS y NOT EXISTS

--Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre,id from fabricante f
where exists (select id_fabricante from producto p where p.id_fabricante = f.id)
--Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre,id from fabricante f
where not exists (select id_fabricante from producto p where p.id_fabricante = f.id)
--Subconsultas correlacionadas

--Lista el nombre de cada fabricante con el nombre y el precio de su producto más caro.
select f.nombre, p.nombre, p.precio from producto p, fabricante f 
where p.id_fabricante = f.id and p.precio = (select max(precio) from producto)
--Devuelve un listado de todos los productos que tienen un precio mayor o igual a la media de todos los productos de su mismo fabricante.
select f.nombre, p.nombre, p.precio from producto p, fabricante f 
where p.id_fabricante = f.id and p.precio >= (select avg(precio) from producto)
--Lista el nombre del producto más caro del fabricante Lenovo.
select nombre from producto 
where precio = (select max(precio) from producto p, fabricante f 
				where p.id_fabricante = f.id and f.nombre = 'Lenovo')
--Subconsultas (En la cláusula HAVING)

--Devuelve un listado con todos los nombres de los fabricantes que tienen el mismo número de 
--productos que el fabricante Lenovo.
select count(precio), f.nombre from producto p, fabricante f  
where p.id_fabricante = f.id
group by f.nombre				
having count(precio) = (select count(precio) from producto p, fabricante f  
		            	where p.id_fabricante = f.id and f.nombre = 'Lenovo')
=============================================================================
FUNCTIONS
=========

--Función que devuelve el número total de productos en la tabla productos:
drop function num_productos();
CREATE OR REPLACE FUNCTION num_productos()
RETURNS INTEGER AS $$
BEGIN
  RETURN (SELECT COUNT(*) FROM producto);
END;
$$ LANGUAGE plpgsql;

SELECT NUM_PRODUCTOS();
--Función que devuelve el valor medio del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada:
drop function media_precio_fabricante(nom_fabricante TEXT)
CREATE OR REPLACE FUNCTION media_precio_fabricante(nom_fabricante TEXT)
RETURNS NUMERIC AS $$
BEGIN
  RETURN (SELECT AVG(precio) FROM producto WHERE nombre = nom_fabricante);
END;
$$ LANGUAGE plpgsql;

SELECT media_precio_fabricante('GeForce GTX 1080 Xtreme');
--Función que devuelve el valor máximo del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada:
CREATE OR REPLACE FUNCTION max_precio_fabricante(nom_fabricante TEXT)
RETURNS NUMERIC AS $$
BEGIN
  RETURN (SELECT MAX(precio) FROM producto WHERE nombre = nom_fabricante);
END;
$$ LANGUAGE plpgsql;

select max_precio_fabricante('GeForce GTX 1080 Xtreme')
--Función que devuelve el valor mínimo del precio de los productos de un determinado fabricante que se recibirá como parámetro de entrada:
--El parámetro de entrada será el nombre del fabricante.
drop function min_precio_fabricante(nom_fabricante TEXT)
CREATE OR REPLACE FUNCTION min_precio_fabricante(nom_fabricante TEXT)
RETURNS NUMERIC AS $$
BEGIN
  RETURN (SELECT MIN(precio) FROM producto WHERE nombre = nom_fabricante);
END;
$$ LANGUAGE plpgsql;

select min_precio_fabricante('GeForce GTX 1080 Xtreme')


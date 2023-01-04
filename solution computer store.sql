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

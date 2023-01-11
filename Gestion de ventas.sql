--SOLUCION EJERCICIOS PLANTEADOS SQL EN https://josejuansanchez.org/bd/ejercicios-consultas-sql/index.html
--REALIZADO en postgreSQL pgAdmin 4 V6 POR Harold Montecinos Mujiano enero 2023

--=====================================================================================================

--Gestion de ventas
--create DB
DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas

--create tables

CREATE TABLE cliente (
  id serial PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  ciudad VARCHAR(100),
  categoría INT
);

CREATE TABLE comercial (
  id serial PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100),
  comisión FLOAT
);

CREATE TABLE pedido (
  id serial PRIMARY KEY,
  total float NOT NULL,
  fecha DATE,
  id_cliente INT NOT NULL,
  id_comercial INT NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id),
  FOREIGN KEY (id_comercial) REFERENCES comercial(id)
);

--inserts

INSERT INTO cliente VALUES(1, 'Aarón', 'Rivero', 'Gómez', 'Almería', 100);
INSERT INTO cliente VALUES(2, 'Adela', 'Salas', 'Díaz', 'Granada', 200);
INSERT INTO cliente VALUES(3, 'Adolfo', 'Rubio', 'Flores', 'Sevilla', NULL);
INSERT INTO cliente VALUES(4, 'Adrián', 'Suárez', NULL, 'Jaén', 300);
INSERT INTO cliente VALUES(5, 'Marcos', 'Loyola', 'Méndez', 'Almería', 200);
INSERT INTO cliente VALUES(6, 'María', 'Santana', 'Moreno', 'Cádiz', 100);
INSERT INTO cliente VALUES(7, 'Pilar', 'Ruiz', NULL, 'Sevilla', 300);
INSERT INTO cliente VALUES(8, 'Pepe', 'Ruiz', 'Santana', 'Huelva', 200);
INSERT INTO cliente VALUES(9, 'Guillermo', 'López', 'Gómez', 'Granada', 225);
INSERT INTO cliente VALUES(10, 'Daniel', 'Santana', 'Loyola', 'Sevilla', 125);

INSERT INTO comercial VALUES(1, 'Daniel', 'Sáez', 'Vega', 0.15);
INSERT INTO comercial VALUES(2, 'Juan', 'Gómez', 'López', 0.13);
INSERT INTO comercial VALUES(3, 'Diego','Flores', 'Salas', 0.11);
INSERT INTO comercial VALUES(4, 'Marta','Herrera', 'Gil', 0.14);
INSERT INTO comercial VALUES(5, 'Antonio','Carretero', 'Ortega', 0.12);
INSERT INTO comercial VALUES(6, 'Manuel','Domínguez', 'Hernández', 0.13);
INSERT INTO comercial VALUES(7, 'Antonio','Vega', 'Hernández', 0.11);
INSERT INTO comercial VALUES(8, 'Alfredo','Ruiz', 'Flores', 0.05);

INSERT INTO pedido VALUES(1, 150.5, '2017-10-05', 5, 2);
INSERT INTO pedido VALUES(2, 270.65, '2016-09-10', 1, 5);
INSERT INTO pedido VALUES(3, 65.26, '2017-10-05', 2, 1);
INSERT INTO pedido VALUES(4, 110.5, '2016-08-17', 8, 3);
INSERT INTO pedido VALUES(5, 948.5, '2017-09-10', 5, 2);
INSERT INTO pedido VALUES(6, 2400.6, '2016-07-27', 7, 1);
INSERT INTO pedido VALUES(7, 5760, '2015-09-10', 2, 1);
INSERT INTO pedido VALUES(8, 1983.43, '2017-10-10', 4, 6);
INSERT INTO pedido VALUES(9, 2480.4, '2016-10-10', 8, 3);
INSERT INTO pedido VALUES(10, 250.45, '2015-06-27', 8, 2);
INSERT INTO pedido VALUES(11, 75.29, '2016-08-17', 3, 7);
INSERT INTO pedido VALUES(12, 3045.6, '2017-04-25', 2, 1);
INSERT INTO pedido VALUES(13, 545.75, '2019-01-25', 6, 1);
INSERT INTO pedido VALUES(14, 145.82, '2017-02-02', 6, 1);
INSERT INTO pedido VALUES(15, 370.85, '2019-03-11', 1, 5);
INSERT INTO pedido VALUES(16, 2389.23, '2019-03-11', 1, 5);

SELECT  * FROM cliente
select * from comercial
select * from pedido

--Consultas sobre una tabla

--1. Devuelve un listado con todos los pedidos que se han realizado. Los pedidos deben estar ordenados por la fecha de realización, mostrando en primer lugar los pedidos más recientes.
select * from pedido order by fecha
--2. Devuelve todos los datos de los dos pedidos de mayor valor.
select * from pedido order by total desc limit 2
--3. Devuelve un listado con los identificadores de los clientes que han realizado algún pedido. Tenga en cuenta que no debe mostrar identificadores que estén repetidos.
select distinct id_cliente from pedido 
--4. Devuelve un listado de todos los pedidos que se realizaron durante el año 2017, cuya cantidad total sea superior a 500€.
select * from pedido where EXTRACT(YEAR FROM fecha) = '2017' and total > 500
--5. Devuelve un listado con el nombre y los apellidos de los comerciales que tienen una comisión entre 0.05 y 0.11.
select * from comercial where comisión between 0.05 and 0.11
--6. Devuelve el valor de la comisión de mayor valor que existe en la tabla comercial.
select max(comisión) from comercial
--7. Devuelve el identificador, nombre y primer apellido de aquellos clientes cuyo segundo apellido no es NULL. El listado deberá estar ordenado alfabéticamente por apellidos y nombre.
select id, nombre, apellido1 from cliente where apellido2 is not null order by apellido1, apellido2, nombre
--8. Devuelve un listado de los nombres de los clientes que empiezan por A y terminan por n y también los nombres que empiezan por P. El listado deberá estar ordenado alfabéticamente.
select nombre from cliente where nombre like 'A%n' or nombre like 'P%' order by nombre asc
--9. Devuelve un listado de los nombres de los clientes que no empiezan por A. El listado deberá estar ordenado alfabéticamente.
select nombre from cliente where nombre not like 'A%' order by nombre asc
--10. Devuelve un listado con los nombres de los comerciales que terminan en o. Tenga en cuenta que se deberán eliminar los nombres repetidos.
select distinct nombre from comercial where nombre like '%o' 

--Consultas multitabla (Composición interna)

--Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2.

--1. Devuelve un listado con el identificador, nombre y los apellidos de todos los clientes que han realizado algún pedido. El listado debe estar ordenado alfabéticamente y se deben eliminar los elementos repetidos.
select distinct c.id,c.nombre,c.apellido1, c.apellido2 from pedido p inner join cliente c on p.id_cliente = c.id 
order by c.id 
--2. Devuelve un listado que muestre todos los pedidos que ha realizado cada cliente. El resultado debe mostrar todos los datos de los pedidos y del cliente. El listado debe mostrar los datos de los clientes ordenados alfabéticamente.
select c.*,p.* from pedido p inner join cliente c on p.id_cliente = c.id  
order by c.id, p.id
--3. Devuelve un listado que muestre todos los pedidos en los que ha participado un comercial. El resultado debe mostrar todos los datos de los pedidos y de los comerciales. El listado debe mostrar los datos de los comerciales ordenados alfabéticamente.
select * from pedido p inner join comercial c on p.id_comercial = c.id order by c.id 
--4. Devuelve un listado que muestre todos los clientes, con todos los pedidos que han realizado y con los datos de los comerciales asociados a cada pedido.
select * from cliente c inner join pedido p on c.id = p.id_cliente 
                        inner join comercial co on p.id_comercial = co.id 			
--5. Devuelve un listado de todos los clientes que realizaron un pedido durante el año 2017, cuya cantidad esté entre 300 € y 1000 €.
select * from cliente c inner join pedido p on c.id = p.id_cliente 
where extract(year from fecha) = 2017
and p.total between 300 and 1000  
--6. Devuelve el nombre y los apellidos de todos los comerciales que ha participado en algún pedido realizado por María Santana Moreno.
select distinct co.nombre, co.apellido1, co.apellido2  from cliente c inner join pedido p on c.id = p.id_cliente 
                        inner join comercial co on p.id_comercial = co.id 			
where c.nombre = 'María' and c.apellido1 = 'Santana' and c.apellido2 = 'Moreno'
--7. Devuelve el nombre de todos los clientes que han realizado algún pedido con el comercial Daniel Sáez Vega.
select distinct c.nombre,c.apellido1, c.apellido2 from cliente c inner join pedido p on c.id = p.id_cliente 
                        inner join comercial co on p.id_comercial = co.id 			
where co.nombre = 'Daniel' and co.apellido1 = 'Sáez' and co.apellido2 = 'Vega'

--Consultas multitabla (Composición externa)

--Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN.

--1. Devuelve un listado con todos los clientes junto con los datos de los pedidos que han realizado. Este listado también debe incluir los clientes que no han realizado ningún pedido. El listado debe estar ordenado alfabéticamente por el primer apellido, segundo apellido y nombre de los clientes.
select * from cliente c left join pedido p on c.id = p.id_cliente 
order by c.apellido1, c.apellido2, c.nombre
--2. Devuelve un listado con todos los comerciales junto con los datos de los pedidos que han realizado. Este listado también debe incluir los comerciales que no han realizado ningún pedido. El listado debe estar ordenado alfabéticamente por el primer apellido, segundo apellido y nombre de los comerciales.
select * from comercial co left join pedido p on co.id = p.id_comercial 
order by co.apellido1, co.apellido2, co.nombre
--3. Devuelve un listado que solamente muestre los clientes que no han realizado ningún pedido.
select * from cliente c left join pedido p on c.id = p.id_cliente 
where p.id is null
--4. Devuelve un listado que solamente muestre los comerciales que no han realizado ningún pedido.
select * from comercial co left join pedido p on co.id = p.id_comercial 
where p.id is null
--5. Devuelve un listado con los clientes que no han realizado ningún pedido y de los comerciales que no han participado en ningún pedido. Ordene el listado alfabéticamente por los apellidos y el nombre. En en listado deberá diferenciar de algún modo los clientes y los comerciales.
select c.nombre, c.apellido1,c.apellido2, 'cliente' as tipo  from cliente c left join pedido p on c.id = p.id_cliente 
where p.id is null
union all
select co.nombre, co.apellido1,co.apellido2, 'comercial' from comercial co left join pedido p on co.id = p.id_comercial 
where p.id is null
-- 1. Lista el nombre de todos los productos que hay en la tabla producto.
SELECT nombre FROM tienda.producto;
 -- 2 Lista los nombres y los precios de todos los productos de la tabla producto.
SELECT nombre, precio FROM tienda.producto;
-- 3 Lista todas las columnas de la tabla producto.
SELECT * FROM tienda.producto;
-- 4 Lista los nombres y los precios de todos los productos de la tabla producto, redondeando
-- el valor del precio.
SELECT nombre, ROUND(precio) AS precio_redondeado FROM tienda.producto;
-- 5Lista el código de los fabricantes que tienen productos en la tabla producto.
SELECT codigo FROM tienda.fabricante;
-- 6 Lista el código de los fabricantes que tienen productos en la tabla producto, sin mostrar
-- los repetidos.
SELECT DISTINCT codigo FROM tienda.fabricante;
-- 7 Lista los nombres de los fabricantes ordenados de forma ascendente.
SELECT nombre FROM tienda.fabricante ORDER BY nombre ASC;
-- 8 Lista los nombres de los productos ordenados en primer lugar por el nombre de forma
-- ascendente y en segundo lugar por el precio de forma descendente.
SELECT nombre, precio FROM tienda.producto ORDER BY nombre ASC, precio DESC;
-- 9 Devuelve una lista con las 5 primeras filas de la tabla fabricante.
SELECT * FROM tienda.fabricante LIMIT 5;
-- 10 Lista el nombre y el precio del producto más barato. (Utilice solamente las cláusulas
-- ORDER BY y LIMIT)
SELECT nombre, precio FROM tienda.producto ORDER BY precio ASC LIMIT 1;--
-- 11 Lista el nombre y el precio del producto más caro. (Utilice solamente las cláusulas ORDER
-- BY y LIMIT)
SELECT nombre, precio FROM tienda.producto ORDER BY precio DESC LIMIT 1;
-- 12 Lista el nombre de los productos que tienen un precio menor o igual a $120.
SELECT nombre FROM tienda.producto WHERE precio <= 120;
-- 13 Lista todos los productos que tengan un precio entre $60 y $200. Utilizando el operador
-- BETWEEN.
SELECT * FROM tienda.producto WHERE precio BETWEEN 60 AND 200;
-- 14 Lista todos los productos donde el código de fabricante sea 1, 3 o 5. Utilizando el operador
-- IN.
SELECT * FROM tienda.producto WHERE codigo_fabricante IN (1, 3, 5);
-- 15 Devuelve una lista con el nombre de todos los productos que contienen la cadena Portátil
-- en el nombre.
SELECT * FROM tienda.producto WHERE nombre LIKE '%Portátil%';
-- Consultas Multitabla
-- 1. Devuelve una lista con el código del producto, nombre del producto, código del fabricante
-- y nombre del fabricante, de todos los productos de la base de datos.
SELECT p.codigo, p.nombre, f.codigo, f.nombre FROM producto p, fabricante f
WHERE p.codigo_fabricante = f.codigo;
-- 2. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos
-- los productos de la base de datos. Ordene el resultado por el nombre del fabricante, por
-- orden alfabético.
SELECT p.nombre, p.precio, f.nombre FROM producto p JOIN fabricante f ON p.codigo_fabricante = f.codigo
ORDER BY f.nombre ASC;
-- 3. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto
-- más barato.
SELECT p.nombre, p.precio, f.nombre FROM producto p
INNER JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE p.precio = (SELECT MIN(precio) FROM producto);
SELECT p.nombre, p.precio, f.nombre FROM producto p, fabricante f WHERE p.codigo_fabricante = f.codigo
ORDER BY p.precio ASC LIMIT 1;
-- 4 Devuelve una lista de todos los productos del fabricante Lenovo.
SELECT producto.nombre, producto.precio, producto.codigo_fabricante FROM producto, fabricante
WHERE producto.codigo_fabricante = fabricante.codigo AND fabricante.nombre = 'Lenovo';
-- 5 Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio
-- mayor que $200.
SELECT * FROM producto p, fabricante f WHERE f.nombre LIKE '%Crucial%' AND p.precio > 200 AND p.codigo_fabricante = f.codigo;
-- 6 Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packard.
-- Utilizando el operador IN.
SELECT * FROM producto p, fabricante f WHERE p.codigo_fabricante = f.codigo AND f.nombre in ('Asus','Hewlett-Packard');
/*7. Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos
los productos que tengan un precio mayor o igual a $180. Ordene el resultado en primer
lugar por el precio (en orden descendente) y en segundo lugar por el nombre (en orden
ascendente)*/
SELECT p.nombre, p.precio, f.nombre FROM producto p, fabricante f WHERE p.codigo_fabricante = f.codigo
AND p.precio >= 180 ORDER BY p.precio DESC, p.nombre ASC;
/*Consultas Multitabla
Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN.
1. Devuelve un listado de todos los fabricantes que existen en la base de datos, junto con los
productos que tiene cada uno de ellos. El listado deberá mostrar también aquellos
fabricantes que no tienen productos asociados.*/ 
SELECT fabricante.codigo, fabricante.nombre, producto.codigo, producto.nombre FROM
fabricante LEFT JOIN producto ON producto.codigo_fabricante = fabricante.codigo;
-- 2. Devuelve un listado donde sólo aparezcan aquellos fabricantes que no tienen ningún
-- producto asociado.
SELECT p.nombre, p.precio, f.nombre FROM fabricante f LEFT JOIN producto p ON f.codigo = p.codigo_fabricante
WHERE p.nombre IS NULL;
/*Subconsultas (En la cláusula WHERE)
Con operadores básicos de comparación
1. Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).*/
SELECT p.nombre FROM producto p, fabricante f WHERE p.codigo_fabricante = f.codigo AND f.nombre = 'Lenovo';
/*4. Lista todos los productos del fabricante Asus que tienen un precio superior al precio
medio de todos sus productos.*/
SELECT AVG(precio) AS precio_medio FROM producto WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Asus');
/*Subconsultas con IN y NOT IN
1. Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o
NOT IN).*/
SELECT nombre FROM fabricante WHERE codigo IN (SELECT DISTINCT codigo_fabricante FROM producto);
/*2. Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando
IN o NOT IN).*/
SELECT nombre FROM fabricante WHERE codigo NOT IN (SELECT DISTINCT codigo_fabricante FROM producto);
/*Subconsultas (En la cláusula HAVING)
1. Devuelve un listado con todos los nombres de los fabricantes que tienen el mismo número
de productos que el fabricante Lenovo.*/
SELECT f.nombre FROM fabricante f
INNER JOIN producto p ON f.codigo = p.codigo_fabricante GROUP BY f.codigo, f.nombre
HAVING f.codigo <> (SELECT codigo FROM fabricante WHERE nombre = 'Lenovo')
AND COUNT(p.codigo) = (SELECT COUNT(p2.codigo) FROM producto p2 JOIN fabricante f2 
ON p2.codigo_fabricante = f2.codigo WHERE f2.nombre = 'Lenovo'
);



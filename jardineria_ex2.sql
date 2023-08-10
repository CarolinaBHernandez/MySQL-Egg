/*Consultas sobre una tabla
1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.*/
SELECT codigo_oficina, ciudad FROM oficina; 
-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
SELECT ciudad, telefono FROM oficina WHERE pais = 'España';
/*3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un
código de jefe igual a 7.*/
SELECT nombre, apellido1,apellido2, email FROM empleado WHERE codigo_jefe = 7; 
-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
SELECT e.puesto, e.nombre, e.apellido1, e.apellido2, e.email
FROM empleado e
WHERE e.codigo_empleado IN (SELECT codigo_jefe FROM empleado);
/*5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean
representantes de ventas.*/
SELECT nombre, apellido1, apellido2, puesto FROM empleado WHERE puesto <> 'Representante Ventas';
-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente, pais FROM cliente WHERE pais = 'Spain';
-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
SELECT DISTINCT estado FROM pedido;
/*8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago
en 2008. Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan
repetidos. Resuelva la consulta:
o Utilizando la función YEAR de MySQL.*/
SELECT DISTINCT c.codigo_cliente
FROM cliente c
JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE YEAR(p.fecha_pago) = 2008;
-- o Utilizando la función DATE_FORMAT de MySQL.
SELECT DISTINCT c.codigo_cliente
FROM cliente c
JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE DATE_FORMAT(p.fecha_pago, '%Y') = '2008';
-- o Sin utilizar ninguna de las funciones anteriores.*/
SELECT DISTINCT c.codigo_cliente
FROM cliente c
JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_pago LIKE '%2008%';
/*9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
entrega de los pedidos que no han sido entregados a tiempo.*/
SELECT p.codigo_pedido, c.codigo_cliente, p.fecha_esperada, p.fecha_entrega FROM cliente c, pedido p WHERE p.estado = 'Pendiente';
/*10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de
entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha
esperada.*/
SELECT p.codigo_pedido, c.codigo_cliente, p.fecha_esperada, p.fecha_entrega
FROM cliente c, pedido p
WHERE p.estado = 'Entregado'
AND p.fecha_entrega <= p.fecha_esperada - 2;
/*o Utilizando la función ADDDATE de MySQL.*/
SELECT p.codigo_pedido, c.codigo_cliente, p.fecha_esperada, p.fecha_entrega
FROM cliente c, pedido p
WHERE p.estado = 'Entregado'
AND p.fecha_entrega <= ADDDATE(p.fecha_esperada, INTERVAL -2 DAY);
-- o Utilizando la función DATEDIFF de MySQL.*/
SELECT p.codigo_pedido, c.codigo_cliente, p.fecha_esperada, p.fecha_entrega
FROM cliente c, pedido p
WHERE p.estado = 'Entregado'
AND DATEDIFF(p.fecha_esperada, p.fecha_entrega) >= 2;
-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
SELECT codigo_pedido FROM pedido WHERE estado = 'Rechazado'  AND YEAR(fecha_pedido) = 2009;
/*12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de
cualquier año.*/
SELECT codigo_pedido, fecha_entrega FROM pedido WHERE MONTH(fecha_entrega) = 1;
/*13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal.
Ordene el resultado de mayor a menor.*/
SELECT codigo_cliente, forma_pago, total FROM pago WHERE forma_pago = 'Paypal' AND YEAR (fecha_pago) = 2008 ORDER BY total DESC;
/*14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en
cuenta que no deben aparecer formas de pago repetidas.*/
SELECT DISTINCT forma_pago FROM pago;
/*15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que
tienen más de 100 unidades en stock. El listado deberá estar ordenado por su precio de
venta, mostrando en primer lugar los de mayor precio.*/
SELECT nombre,gama FROM producto WHERE gama = 'Ornamentales' AND cantidad_en_stock >100 ORDER BY precio_venta DESC;
/*16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo
representante de ventas tenga el código de empleado 11 o 30.*/
SELECT nombre_cliente, ciudad, codigo_empleado_rep_ventas FROM cliente WHERE ciudad= 'Madrid' AND (codigo_empleado_rep_ventas = 11 OR codigo_empleado_rep_ventas = 30);
/*Consultas multitabla (Composición interna)
Las consultas se deben resolver con INNER JOIN.
1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante
de ventas.*/
SELECT c.nombre_cliente, c.codigo_empleado_rep_ventas, e.nombre, e.apellido1, e.apellido2
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;
/*2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus
representantes de ventas.
pago*/
SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS apellido1_rep, e.apellido2 AS  apellido2_rep
FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN pago p ON p.codigo_cliente = c.codigo_cliente;
/*3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de
sus representantes de ventas.*/
SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS apellido1_rep, e.apellido2 AS apellido2_rep
FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente NOT IN (
  SELECT codigo_cliente
  FROM pago
);
/*4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes
junto con la ciudad de la oficina a la que pertenece el representante.*/
SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS apellido1_rep, e.apellido2 AS  apellido2_rep, o.ciudad AS ciudad_rep
FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
INNER JOIN pago p ON p.codigo_cliente = c.codigo_cliente;
/*5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus
representantes junto con la ciudad de la oficina a la que pertenece el representante.*/
SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS apellido1_rep, e.apellido2 AS  apellido2_rep, o.ciudad AS ciudad_rep
FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente NOT IN (
  SELECT codigo_cliente
  FROM pago
);
-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT DISTINCT concat(linea_direccion1, ' ', linea_direccion2) AS Direccion 
FROM oficina 
INNER JOIN empleado 
ON oficina.codigo_oficina = empleado.codigo_oficina 
WHERE codigo_empleado IN (SELECT codigo_empleado_rep_ventas FROM cliente 
WHERE ciudad = "Fuenlabrada");
/*7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad
de la oficina a la que pertenece el representante.*/
SELECT c.nombre_cliente, e.nombre AS nombre_representante, e.apellido1 AS apellido1_rep, e.apellido2 AS  apellido2_rep, o.ciudad AS ciudad_rep
FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;
-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT CONCAT(e1.nombre, ' ', e1.apellido1,' ', e1.apellido2) AS Nombre_empleado, CONCAT(e2.nombre, ' ', e2.apellido1,' ', e2.apellido2) AS Nombre_jefe
FROM empleado e1 
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado ORDER BY e1.nombre;
-- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.estado = 'Pendiente' OR (p.estado = 'Entregado' AND p.fecha_esperada < p.fecha_entrega);
-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
SELECT c.codigo_cliente, c.nombre_cliente, g.gama
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN detalle_pedido d ON p.codigo_pedido = d.codigo_pedido
INNER JOIN producto pr ON d.codigo_producto = pr.codigo_producto
INNER JOIN gama_producto g ON pr.gama = g.gama
GROUP BY c.codigo_cliente, c.nombre_cliente, g.gama;
/*Consultas multitabla (Composición externa)
Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, JOIN.
1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
/*2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
pedido.*/
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;
/*3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que
no han realizado ningún pedido.*/
SELECT c.nombre_cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pedido p1 ON c.codigo_cliente = p1.codigo_cliente
WHERE p.codigo_cliente IS NULL AND p1.codigo_cliente IS NULL;
/*4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina
asociada.*/
SELECT e.nombre, e.apellido1, e.apellido2
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE o.codigo_oficina IS NULL;
/*5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente
asociado.*/
SELECT e.codigo_empleado, e.nombre, e.apellido1, e.apellido2
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;
/*6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los
que no tienen un cliente asociado.*/
SELECT e.codigo_empleado, e.nombre, e.apellido1, e.apellido2
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL AND o.codigo_oficina IS NULL;
-- 7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT p.codigo_producto, p.nombre
FROM producto p
LEFT JOIN detalle_pedido de ON p.codigo_producto = de.codigo_producto
WHERE de.codigo_pedido IS NULL;
/*8. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los
representantes de ventas de algún cliente que haya realizado la compra de algún producto
de la gama Frutales.*/
SELECT o.codigo_oficina
FROM oficina o
LEFT JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
LEFT JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
WHERE pr.gama <> 'Frutales';
/*9. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizado
ningún pago.*/
SELECT c.codigo_cliente, c.nombre_cliente
FROM cliente c
JOIN pedido pe ON c.codigo_cliente = pe.codigo_cliente
LEFT JOIN pago pa ON pe.codigo_cliente = pa.codigo_cliente
WHERE pa.codigo_cliente IS NULL;
/*10. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el
nombre de su jefe asociado.*/
SELECT e1.*, CONCAT(e2.nombre, ' ', e2.apellido1, ' ', e2.apellido2) AS Nombre_jefe_Asociado
FROM empleado e1
LEFT JOIN cliente c ON e1.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN empleado e2 ON e1.codigo_jefe = e2.codigo_empleado
WHERE c.codigo_cliente IS NULL;
/*Consultas resumen
1. ¿Cuántos empleados hay en la compañía?*/
SELECT COUNT(*) AS codigo_empleado
FROM empleado;
-- 2. ¿Cuántos clientes tiene cada país?
SELECT pais, COUNT(*) AS total_clientes
FROM cliente
GROUP BY pais;
-- 3. ¿Cuál fue el pago medio en 2009?
SELECT ROUND(AVG(total), 0) AS pago_medio_2009
FROM pago
WHERE YEAR(fecha_pago) = 2009;
/*4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el
número de pedidos.*/
SELECT estado, COUNT(*) AS total_pedidos
FROM pedido
GROUP BY estado
ORDER BY total_pedidos DESC;
-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
SELECT MAX(precio_venta) AS producto_mas_caro, MIN(precio_venta) AS producto_mas_barato
FROM producto; 
-- 6. Calcula el número de clientes que tiene la empresa.
SELECT COUNT(*) AS codigo_cliente 
FROM cliente;
-- 7. ¿Cuántos clientes tiene la ciudad de Madrid?
SELECT ciudad, COUNT(*) AS total_clientes
FROM cliente
WHERE ciudad = 'Madrid'
GROUP BY ciudad;
-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
SELECT ciudad, COUNT(*) AS total_clientes
FROM cliente
WHERE ciudad LIKE 'M%'
GROUP BY ciudad;
/*9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende
cada uno.*/
SELECT CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS representante_ventas, COUNT(*) AS numero_clientes
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
GROUP BY e.codigo_empleado, e.nombre, e.apellido1, e.apellido2;
-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.
SELECT COUNT(*) AS clientes_sin_representante
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;
/*11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado
deberá mostrar el nombre y los apellidos de cada cliente.*/
SELECT CONCAT(c.nombre_cliente, ' ', c.nombre_contacto, ' ', c.apellido_contacto) AS nombre_completo,
       MIN(p.fecha_pago) AS primer_pago,
       MAX(p.fecha_pago) AS ultimo_pago
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.nombre_cliente, c.nombre_contacto, c.apellido_contacto;
-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
SELECT dp.codigo_pedido, COUNT(DISTINCT dp.codigo_producto) AS productos_diferentes
FROM detalle_pedido dp
JOIN pedido p ON dp.codigo_pedido = p.codigo_pedido
GROUP BY dp.codigo_pedido;
/*13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de
los pedidos.*/
SELECT codigo_pedido, SUM(cantidad) AS cantidad_total_productos
FROM detalle_pedido
GROUP BY codigo_pedido;
/*14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que
se han vendido de cada uno. El listado deberá estar ordenado por el número total de
unidades vendidas.*/
SELECT codigo_producto, SUM(cantidad) AS total_unidades_vendidas
FROM detalle_pedido
GROUP BY codigo_producto
ORDER BY total_unidades_vendidas DESC
LIMIT 20;
/*15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el
IVA y el total facturado. La base imponible se calcula sumando el coste del producto por el
número de unidades vendidas de la tabla detalle_pedido. El IVA es el 21 % de la base
imponible, y el total la suma de los dos campos anteriores.*/
SELECT 
  SUM(dp.cantidad * p.precio_venta) AS base_imponible,
  SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
  SUM(dp.cantidad * p.precio_venta) + (SUM(dp.cantidad * p.precio_venta) * 0.21) AS total_facturado
FROM detalle_pedido dp
JOIN producto p ON dp.codigo_producto = p.codigo_producto;
-- 16. La misma información que en la pregunta anterior, pero agrupada por código de producto.
SELECT 
  dp.codigo_producto,
  SUM(dp.cantidad * p.precio_venta) AS base_imponible,
  SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
  SUM(dp.cantidad * p.precio_venta) + (SUM(dp.cantidad * p.precio_venta) * 0.21) AS total_facturado
FROM detalle_pedido dp
JOIN producto p ON dp.codigo_producto = p.codigo_producto
GROUP BY dp.codigo_producto;
/*17. La misma información que en la pregunta anterior, pero agrupada por código de producto
filtrada por los códigos que empiecen por OR.*/
SELECT 
  dp.codigo_producto,
  SUM(dp.cantidad * p.precio_venta) AS base_imponible,
  SUM(dp.cantidad * p.precio_venta) * 0.21 AS iva,
  SUM(dp.cantidad * p.precio_venta) + (SUM(dp.cantidad * p.precio_venta) * 0.21) AS total_facturado
FROM detalle_pedido dp
JOIN producto p ON dp.codigo_producto = p.codigo_producto
GROUP BY dp.codigo_producto
HAVING dp.codigo_producto LIKE 'OR%';
/*18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se
mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21%
IVA)*/
SELECT 
  p.nombre AS nombre_producto,
  SUM(dp.cantidad) AS unidades_vendidas,
  SUM(dp.cantidad * p.precio_venta) AS total_facturado,
  SUM(dp.cantidad * p.precio_venta) * 1.21 AS total_facturado_iva
FROM detalle_pedido dp
JOIN producto p ON dp.codigo_producto = p.codigo_producto
GROUP BY p.codigo_producto, p.nombre
HAVING SUM(dp.cantidad * p.precio_venta) > 3000;
/*Subconsultas con operadores básicos de comparación
1. Devuelve el nombre del cliente con mayor límite de crédito.*/

/*2. Devuelve el nombre del producto que tenga el precio de venta más caro.
3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta
que t
endrá que calcular cuál es el número total de unidades que se han vendido de cada
producto a partir de los datos de la tabla detalle_pedido. Una vez que sepa cuál es el código
del producto, puede obtener su nombre fácilmente.)
4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar
INNER JOIN).
5. Devuelve el producto que más unidades tiene en stock.
6. Devuelve el producto que menos unidades tiene en stock.
7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto
Soria.
Subconsultas con ALL y ANY
1. Devuelve el nombre del cliente con mayor límite de crédito.
2. Devuelve el nombre del producto que tenga el precio de venta más caro.
3. Devuelve el producto que menos unidades tiene en stock.
Subconsultas con IN y NOT IN
1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún
cliente.
2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
3. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.


4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que
no sean representante de ventas de ningún cliente.
Subconsultas con EXISTS y NOT EXISTS
1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún
pago.
2. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.*/
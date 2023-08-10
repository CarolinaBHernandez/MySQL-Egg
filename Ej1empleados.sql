SELECT * FROM personal.empleados;
SELECT nombre, sal_emp FROM personal.empleados;
SELECT comision_emp FROM personal.empleados;
SELECT * FROM personal.empleados WHERE cargo_emp = 'Secretaria';
SELECT * FROM personal.empleados WHERE cargo_emp = 'Vendedor'ORDER BY nombre ASC;
SELECT nombre, cargo_emp FROM personal.empleados ORDER BY sal_emp ASC;
SELECT nombre AS Nombre, cargo_emp AS Cargo FROM personal.empleados;
SELECT sal_emp, comision_emp FROM personal.empleados WHERE id_depto = 2000 ORDER BY comision_emp ASC;
SELECT CONCAT(nombre) AS nombre_empleado, (sal_emp + comision_emp + 500) AS total_pagar
FROM personal.empleados
WHERE id_depto = 3000
ORDER BY nombre_empleado ASC;
SELECT nombre FROM personal.empleados WHERE nombre LIKE 'J%';
SELECT nombre, sal_emp, comision_emp, (sal_emp + comision_emp) AS salario_total
FROM personal.empleados
WHERE comision_emp > 1000;
SELECT nombre, sal_emp, comision_emp, (sal_emp + comision_emp) AS salario_total FROM personal.empleados
WHERE comision_emp = 0;
SELECT nombre, comision_emp, sal_emp FROM personal.empleados WHERE comision_emp > sal_emp;
SELECT nombre, comision_emp, sal_emp FROM personal.empleados WHERE comision_emp <= 0.3 *sal_emp;
SELECT nombre FROM personal.empleados WHERE nombre NOT LIKE '%MA%';
SELECT MAX(sal_emp) AS salario_mas_alto FROM personal.empleados;
SELECT nombre FROM personal.empleados ORDER BY nombre DESC LIMIT 1;
SELECT MAX(sal_emp), MIN(sal_emp), (MAX(sal_emp) - MIN(sal_emp)) AS diferencia FROM personal.empleados;
SELECT departamentos.nombre_depto, AVG(empleados.sal_emp) AS salario_promedio -- AVG PARA CALCULAR EL PROM
FROM departamentos
INNER JOIN empleados ON departamentos.id_depto = empleados.id_depto
GROUP BY departamentos.nombre_depto; -- AGRUPAR RESULTADOS
-- HAVING
SELECT COUNT(nombre), id_depto FROM personal.empleados GROUP BY id_depto HAVING COUNT(nombre) >3;
SELECT COUNT(nombre), id_depto FROM personal.empleados GROUP BY id_depto HAVING COUNT(nombre) = 0;
-- Consulta Multitabla (Uso de la sentencia JOIN/LEFT JOIN/RIGHT JOIN)
SELECT e.nombre, d.nombre_depto, d.nombre_jefe_depto
FROM personal.empleados e
JOIN personal.departamentos d ON e.id_depto = d.id_depto
LEFT JOIN personal.empleados j ON d.nombre_jefe_depto = j.nombre;
-- Consulta con Subconsulta
SELECT empleados.nombre, empleados.sal_emp FROM empleados
WHERE empleados.sal_emp >= (SELECT AVG(sal_emp) FROM empleados)
ORDER BY empleados.id_depto;











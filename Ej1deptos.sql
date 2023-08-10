SELECT * FROM personal.departamentos;
SELECT nombre_depto FROM personal.departamentos;
SELECT nombre_jefe_depto, id_depto = 3000 FROM personal.departamentos;
SELECT nombre_depto FROM personal.departamentos WHERE  nombre_depto LIKE 'Ventas%' OR nombre_depto LIKE 'Investigación%' OR nombre_depto LIKE 'Mantenimiento%';
SELECT nombre_depto FROM personal.departamentos WHERE  nombre_depto NOT LIKE 'Ventas%' OR nombre_depto LIKE 'Investigación%' OR nombre_depto LIKE 'Mantenimiento%';

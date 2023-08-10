USE nba;
-- 1 Mostrar el nombre de todos los jugadores ordenados alfabéticamente.
-- jugadores
SELECT Nombre FROM jugadores ORDER BY Nombre ASC;
/*2. Mostrar el nombre de los jugadores que sean pivots (‘C’) y que pesen más de 200 libras,
ordenados por nombre alfabéticamente.*/
SELECT Nombre, Posicion, Peso FROM jugadores WHERE Peso > 200 AND Posicion = 'C' ORDER BY Nombre ASC;
-- 3. Mostrar el nombre de todos los equipos ordenados alfabéticamente.
SELECT Nombre FROM equipos ORDER BY Nombre ASC;
-- 4. Mostrar el nombre de los equipos del este (East).
SELECT Nombre,Conferencia FROM equipos WHERE Conferencia LIKE 'East%';
-- 5. Mostrar los equipos donde su ciudad empieza con la letra ‘c’, ordenados por nombre.
SELECT Nombre,Ciudad FROM equipos WHERE Ciudad LIKE 'C%' ORDER BY Nombre ASC;
-- 6. Mostrar todos los jugadores y su equipo ordenados por nombre del equipo.
SELECT Nombre, Nombre_equipo FROM jugadores ORDER BY Nombre_equipo ASC;
-- 7. Mostrar todos los jugadores del equipo “Raptors” ordenados por nombre.
SELECT Nombre, Nombre_equipo FROM jugadores WHERE Nombre_equipo = 'Raptors' ORDER BY Nombre ASC;
-- 8. Mostrar los puntos por partido del jugador ‘Pau Gasol’.
SELECT j.Nombre, e.Puntos_Por_Partido FROM jugadores j JOIN estadisticas e ON j.codigo = e.jugador
WHERE j.Nombre = 'Pau Gasol';
-- 9. Mostrar los puntos por partido del jugador ‘Pau Gasol’ en la temporada ’04/05′.
SELECT j.Nombre, e.Puntos_Por_Partido, e.temporada FROM jugadores j JOIN estadisticas e ON j.codigo = e.jugador
WHERE j.Nombre = 'Pau Gasol'AND e.temporada = '04/05';
-- 10. Mostrar el número de puntos de cada jugador en toda su carrera.*/
SELECT j.Nombre, ROUND(SUM(e.Puntos_Por_Partido)) FROM jugadores j , estadisticas e WHERE j.codigo = e.jugador GROUP BY j.Nombre ORDER BY SUM(e.Puntos_Por_Partido);
-- 11. Mostrar el número de jugadores de cada equipo.
SELECT e.Nombre, COUNT(*) AS TotalJugadores FROM equipos e JOIN jugadores j ON e.Nombre= j.Nombre_Equipo
GROUP BY e.Nombre;
-- 12. Mostrar el jugador que más puntos ha realizado en toda su carrera.
SELECT j.Nombre, ROUND(SUM(e.Puntos_Por_Partido)) AS puntos_carrera FROM jugadores j , estadisticas e WHERE j.codigo = e.jugador GROUP BY j.Nombre ORDER BY puntos_carrera DESC LIMIT 1;
-- 13. Mostrar el nombre del equipo, conferencia y división del jugador más alto de la NBA.
SELECT e.Nombre AS Nombre_De_Equipo, e.Conferencia, e.Division, j.Nombre AS Jugador_Mas_Alto, j.Altura FROM equipos e
JOIN jugadores j ON j.Nombre_equipo = e.Nombre
WHERE j.Altura = (SELECT MAX(Altura) FROM jugadores)
LIMIT 1;
-- 14. Mostrar la media de puntos en partidos de los equipos de la división Pacific.
SELECT e.Division, ROUND(AVG(e1.Puntos_por_partido), 2) AS media_puntos FROM equipos e, estadisticas e1 WHERE e.Division = 'Pacific';
-- 15. Mostrar el partido o partidos (equipo_local, equipo_visitante y diferencia) con mayor
-- diferencia de puntos.
SELECT p.equipo_local, p.equipo_visitante, ABS(p.puntos_local - p.puntos_visitante) AS diferencia
FROM partidos p
WHERE ABS(p.puntos_local - p.puntos_visitante) = (
    SELECT MAX(ABS(puntos_local - puntos_visitante))
    FROM partidos
);
-- 16. Mostrar quien gana en cada partido (codigo, equipo_local, equipo_visitante,
-- equipo_ganador), en caso de empate sera null.
SELECT codigo, equipo_local, equipo_visitante,
    IF(puntos_local > puntos_visitante, equipo_local,
       IF(puntos_local < puntos_visitante, equipo_visitante, NULL)) AS equipo_ganador
FROM partidos;
--  -----------------------------------------------------------------------------
SELECT nba.equipos.nombre, AVG((puntos_local+puntos_visitante)/2) AS promedio_total
FROM nba.equipos
LEFT JOIN (
    SELECT nba.partidos.equipo_local, AVG(nba.partidos.puntos_local) AS puntos_local
    FROM nba.partidos
    WHERE nba.partidos.equipo_local IN (
        SELECT nba.equipos.Nombre
        FROM nba.equipos
        WHERE nba.equipos.Division = 'Pacific'
    )
    GROUP BY nba.partidos.equipo_local
) AS subquery1 ON nba.equipos.nombre = subquery1.equipo_local
LEFT JOIN (
    SELECT nba.partidos.equipo_visitante, AVG(nba.partidos.puntos_visitante) AS puntos_visitante
    FROM nba.partidos
    WHERE nba.partidos.equipo_visitante IN (
        SELECT nba.equipos.Nombre
        FROM nba.equipos
        WHERE nba.equipos.Division = 'Pacific'
    )
    GROUP BY nba.partidos.equipo_visitante
) AS subquery2 ON nba.equipos.nombre = subquery2.equipo_visitante
 WHERE nba.equipos.Division = 'Pacific'
GROUP BY nba.equipos.nombre;
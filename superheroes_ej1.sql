SELECT * FROM superheroes.personajes;
INSERT INTO personajes(nombre_real,personaje,inteligencia,fuerza,velocidad,poder,aparicion,ocupacion,id_creador) VALUES
('Bruce Banner','Hulk',160,'600 mil',75,98,1962,'Fisico Nuclear',1),
('Tony Stark','Iron man',170,'200 mil',70,123,1963,'Inventor Industrial',1),
('Thor Odinson','Thor',145,'Infinita',100,235,1962,'Rey de Azgard',1),
('Wanda Maximoff','Bruja Escarlata',170,'100 mil',90,345,1964,'Bruja',1),
('Carol Danvers','Capitana Marvel',157,'250 mil',85,128,1968,'Oficial de Inteligencia',1),
('Thanos','Thanos',170,'infinita',40,306,1973,'Adorador de la muerte',1),
('Peter Prker','Spìderman',165,'25 mil',80,74,1962,'Fotografo',1),
('Steve Rogers','Capitan America',145,'600',45,60,1941,'Oficial Federeal',1),
('Bobby Drake','Ice Man',140,'Dos mil',64,122,1963,'Contador',1),
('Barry Allen','Flash',160,'10 mil',120,168,1956,'Cientifico Forence',2),
('Bruce Wayne','Batman',170,'500',32,47,1939,'Hombre de negocios',2),
('Clark Kent','Superman',165,'Infinita',120,182,1948,'Reportero',2),
('Diana Price','Mujer Maravilla',160,'Infinita',95,127,1949,'Princesa Guerrera',2);


UPDATE superheroes.personajes SET aparicion = 1938 WHERE id_personaje =12;
DELETE FROM superheroes.personajes WHERE nombre_real = 'Barry Allen';
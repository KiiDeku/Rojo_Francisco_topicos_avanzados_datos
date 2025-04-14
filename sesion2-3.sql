
-- Expresiones regulares

-- Clientes cuyo correo es de Gmail
SELECT Nombre, Correo
FROM Clientes
WHERE REGEXP_LIKE(Correo, '@gmail\.com$', 'i');

-- Clientes cuyos nombres comienzan con una vocal
SELECT Nombre
FROM Clientes
WHERE REGEXP_LIKE(Nombre, '^[AEIOUaeiou]');

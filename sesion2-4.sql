
-- Funciones agregadas

-- Total de ventas por ciudad
SELECT Ciudad, SUM(Total) AS TotalVentas
FROM Clientes C
JOIN Pedidos P ON C.ClienteID = P.ClienteID
GROUP BY Ciudad;

-- Promedio del total por cliente
SELECT ClienteID, AVG(Total) AS PromedioCompras
FROM Pedidos
GROUP BY ClienteID;

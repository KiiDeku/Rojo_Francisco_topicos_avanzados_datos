
-- Crear vistas

-- Vista de clientes que han comprado más de $1000 en total
CREATE OR REPLACE VIEW Vista_Clientes_VIP AS
SELECT C.ClienteID, C.Nombre, SUM(P.Total) AS TotalComprado
FROM Clientes C
JOIN Pedidos P ON C.ClienteID = P.ClienteID
GROUP BY C.ClienteID, C.Nombre
HAVING SUM(P.Total) > 1000;

-- Vista de pedidos con más de $500
CREATE OR REPLACE VIEW Vista_Pedidos_Altos AS
SELECT PedidoID, ClienteID, Total
FROM Pedidos
WHERE Total > 500;

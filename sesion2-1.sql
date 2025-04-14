SELECT Nombre, Ciudad
FROM Clientes
WHERE Ciudad = 'La Serena'
ORDER BY Nombre;

SELECT PedidoID, Total
FROM Pedidos
WHERE Total > 500
ORDER BY Total DESC;


SET SERVEROUTPUT ON;

/******************************************************************************
 * ACTIVIDAD 1: Analizar y optimizar consulta de pedidos por cliente.
 ******************************************************************************/
DBMS_OUTPUT.PUT_LINE('--- Plan de Ejecución ANTES de optimizar (Actividad 1) ---');
EXPLAIN PLAN FOR
SELECT c.Nombre, COUNT(p.PedidoID) AS TotalPedidos
 FROM Clientes c, Pedidos p
 WHERE c.ClienteID = p.ClienteID
 AND c.Ciudad = 'Santiago'
 AND p.FechaPedido >= TO_DATE('2025-03-01', 'YYYY-MM-DD')
 GROUP BY c.Nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

DBMS_OUTPUT.PUT_LINE('--- Plan de Ejecución DESPUÉS de optimizar (Actividad 1) ---');
EXPLAIN PLAN FOR
SELECT
    c.Nombre,
    COUNT(p.PedidoID) AS TotalPedidos
FROM
    Clientes c
JOIN
    Pedidos p ON c.ClienteID = p.ClienteID
WHERE
    c.Ciudad = 'Santiago'
    AND p.FechaPedido BETWEEN TO_DATE('2025-03-01', 'YYYY-MM-DD') AND TO_DATE('2025-03-31', 'YYYY-MM-DD');

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


/******************************************************************************
 * ACTIVIDAD 2: Optimizar consulta de ventas totales por producto.
 ******************************************************************************/
DBMS_OUTPUT.PUT_LINE('--- Plan de Ejecución ANTES de optimizar (Actividad 2) ---');
EXPLAIN PLAN FOR
SELECT p.Nombre, SUM(dp.Cantidad * p.Precio) AS TotalVentas
 FROM Productos p, DetallesPedidos dp
 WHERE p.ProductoID = dp.ProductoID
 GROUP BY p.Nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

BEGIN
   EXECUTE IMMEDIATE 'CREATE INDEX idx_detalles_prod_id ON DetallesPedidos(ProductoID)';
   DBMS_OUTPUT.PUT_LINE('Índice idx_detalles_prod_id creado para optimizar el JOIN.');
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE = -955 THEN
         DBMS_OUTPUT.PUT_LINE('Índice idx_detalles_prod_id ya existía.');
      ELSE
         RAISE;
      END IF;
END;
/

DBMS_OUTPUT.PUT_LINE('--- Plan de Ejecución DESPUÉS de optimizar (Actividad 2) ---');
EXPLAIN PLAN FOR
SELECT
    p.Nombre,
    SUM(dp.Cantidad * p.Precio) AS TotalVentas
FROM
    Productos p
JOIN
    DetallesPedidos dp ON p.ProductoID = dp.ProductoID
GROUP BY
    p.Nombre;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
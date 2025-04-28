
-- Procedimiento 1: aumentar_precio_producto
CREATE OR REPLACE PROCEDURE aumentar_precio_producto(
    p_producto_id IN NUMBER,
    p_porcentaje IN NUMBER
) AS
    v_precio_actual NUMBER;
BEGIN
    -- Obtener precio actual
    SELECT Precio INTO v_precio_actual
    FROM Productos
    WHERE ProductoID = p_producto_id;

    -- Aumentar precio
    UPDATE Productos
    SET Precio = v_precio_actual * (1 + p_porcentaje / 100)
    WHERE ProductoID = p_producto_id;

    DBMS_OUTPUT.PUT_LINE('Precio actualizado correctamente.');
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Producto con ID ' || p_producto_id || ' no existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/

-- Procedimiento 2: contar_pedidos_cliente
CREATE OR REPLACE PROCEDURE contar_pedidos_cliente(
    p_cliente_id IN NUMBER,
    p_cantidad OUT NUMBER
) AS
BEGIN
    SELECT COUNT(*) INTO p_cantidad
    FROM Pedidos
    WHERE ClienteID = p_cliente_id;

    IF p_cantidad IS NULL THEN
        p_cantidad := 0;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        p_cantidad := 0;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Ejecución de ejemplo para aumentar_precio_producto
-- EXEC aumentar_precio_producto(1, 10);

-- Ejecución de ejemplo para contar_pedidos_cliente
-- DECLARE
--     v_cantidad NUMBER;
-- BEGIN
--     contar_pedidos_cliente(1, v_cantidad);
--     DBMS_OUTPUT.PUT_LINE('Cantidad de pedidos: ' || v_cantidad);
-- END;
/ 

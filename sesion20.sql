
SET SERVEROUTPUT ON;

/******************************************************************************
 * ACTIVIDAD 1: Procedimiento para actualizar precios.
 ******************************************************************************/

-- Función de ayuda
CREATE OR REPLACE FUNCTION precio_promedio_por_pedido(
    p_producto_id IN Productos.ProductoID%TYPE
) RETURN NUMBER AS
    v_promedio NUMBER;
BEGIN
    SELECT AVG(p.Precio * d.Cantidad) INTO v_promedio
    FROM DetallesPedidos d
    JOIN Productos p ON d.ProductoID = p.ProductoID
    WHERE d.ProductoID = p_producto_id;
    RETURN NVL(v_promedio, 0);
END;
/

-- Procedimiento principal
CREATE OR REPLACE PROCEDURE actualizar_precios_por_categoria(
    p_porcentaje_aumento IN NUMBER
) AS
    CURSOR producto_cursor IS SELECT ProductoID, Precio FROM Productos FOR UPDATE;
BEGIN
    FOR prod IN producto_cursor LOOP
        IF precio_promedio_por_pedido(prod.ProductoID) > 500 THEN
            UPDATE Productos
            SET Precio = prod.Precio * (1 + p_porcentaje_aumento / 100)
            WHERE CURRENT OF producto_cursor;
            DBMS_OUTPUT.PUT_LINE('Precio del producto ' || prod.ProductoID || ' actualizado.');
        END IF;
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        ROLLBACK;
END;
/

/******************************************************************************
 * ACTIVIDAD 2: Trigger para auditar eliminación de pedidos.
 ******************************************************************************/

-- Tabla de auditoría
BEGIN
    EXECUTE IMMEDIATE '
    CREATE TABLE AuditoriaPedidos (
        AuditoriaID       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        PedidoID_Borrado  NUMBER,
        ClienteID_Borrado NUMBER,
        Total_Borrado     NUMBER,
        FechaEliminacion  DATE,
        Usuario_Accion    VARCHAR2(100)
    )';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF;
END;
/

-- Trigger de auditoría
CREATE OR REPLACE TRIGGER auditar_eliminacion_pedido
AFTER DELETE ON Pedidos
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaPedidos (PedidoID_Borrado, ClienteID_Borrado, Total_Borrado, FechaEliminacion, Usuario_Accion)
    VALUES (:OLD.PedidoID, :OLD.ClienteID, :OLD.Total, SYSDATE, USER);
END;
/

DBMS_OUTPUT.PUT_LINE('Objetos de la Sesión 20 creados correctamente.');
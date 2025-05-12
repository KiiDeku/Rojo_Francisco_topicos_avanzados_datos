
-- ========================================
-- Script de Actividad Práctica - Sesión 12 (Actualizado con secuencia)
-- Basado en la base de datos de sesion1.sql
-- ========================================

-- PASO 0: Crear secuencia para DetalleID si no existe
BEGIN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_detalle_id START WITH 100 INCREMENT BY 1';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN -- ORA-00955: name is already used
            RAISE;
        END IF;
END;
/

-- PASO 1: Función calcular_total_con_descuento
CREATE OR REPLACE FUNCTION calcular_total_con_descuento(p_pedido_id IN NUMBER)
RETURN NUMBER AS
    v_total NUMBER := 0;
BEGIN
    SELECT SUM(p.Precio * d.Cantidad) INTO v_total
    FROM DetallesPedidos d
    JOIN Productos p ON d.ProductoID = p.ProductoID
    WHERE d.PedidoID = p_pedido_id;

    IF v_total > 1000 THEN
        v_total := v_total * 0.9; -- Aplica 10% de descuento
    END IF;

    RETURN NVL(v_total, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/

-- PASO 2: Procedimiento aplicar_descuento_pedido
CREATE OR REPLACE PROCEDURE aplicar_descuento_pedido(p_pedido_id IN NUMBER) AS
    v_total NUMBER;
BEGIN
    v_total := calcular_total_con_descuento(p_pedido_id);

    UPDATE Pedidos
    SET Total = v_total
    WHERE PedidoID = p_pedido_id;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Pedido no encontrado.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('Total actualizado con descuento: ' || v_total);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/

-- PASO 3: Trigger validar_cantidad_detalle
CREATE OR REPLACE TRIGGER validar_cantidad_detalle
BEFORE INSERT OR UPDATE ON DetallesPedidos
FOR EACH ROW
BEGIN
    IF :NEW.Cantidad <= 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'La cantidad debe ser mayor a 0.');
    END IF;
END;
/

-- PASO 4: Pruebas usando secuencia
-- Insertar detalles válidos
INSERT INTO DetallesPedidos (DetalleID, PedidoID, ProductoID, Cantidad)
VALUES (seq_detalle_id.NEXTVAL, 101, 1, 1);

INSERT INTO DetallesPedidos (DetalleID, PedidoID, ProductoID, Cantidad)
VALUES (seq_detalle_id.NEXTVAL, 101, 2, 5);

-- Ejecutar el procedimiento para aplicar el descuento
BEGIN
    aplicar_descuento_pedido(101);
END;
/

/*************************************************
1. Cursor explícito basado en objeto para listar atributos
2. Cursor explícito con parámetro para actualizar registros
*************************************************/

-- Crear tipo de objeto para clientes
CREATE OR REPLACE TYPE tipo_cliente AS OBJECT (
    ClienteID NUMBER,
    Nombre VARCHAR2(50)
);
/

-- Bloque para listar clientes
DECLARE
    CURSOR cliente_cursor IS
        SELECT tipo_cliente(ClienteID, Nombre)
        FROM Clientes
        ORDER BY Nombre DESC;

    v_cliente tipo_cliente;
BEGIN
    OPEN cliente_cursor;
    LOOP
        FETCH cliente_cursor INTO v_cliente;
        EXIT WHEN cliente_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('ClienteID: ' || v_cliente.ClienteID || ', Nombre: ' || v_cliente.Nombre);
    END LOOP;
    CLOSE cliente_cursor;
END;
/
-- =======================================================

-- Crear tipo de objeto para pedidos
CREATE OR REPLACE TYPE tipo_pedido AS OBJECT (
    PedidoID NUMBER,
    Total NUMBER
);
/

-- Bloque para actualizar pedidos
DECLARE
    CURSOR pedido_cursor(p_min_total NUMBER) IS
        SELECT tipo_pedido(PedidoID, Total)
        FROM Pedidos
        WHERE Total < p_min_total
        FOR UPDATE;

    v_pedido tipo_pedido;
    v_total_actualizado NUMBER;
BEGIN
    OPEN pedido_cursor(400);
    LOOP
        FETCH pedido_cursor INTO v_pedido;
        EXIT WHEN pedido_cursor%NOTFOUND;

        v_total_actualizado := v_pedido.Total * 1.1;

        UPDATE Pedidos
        SET Total = v_total_actualizado
        WHERE PedidoID = v_pedido.PedidoID;

        DBMS_OUTPUT.PUT_LINE('Pedido ' || v_pedido.PedidoID);
        DBMS_OUTPUT.PUT_LINE('  Total original: ' || v_pedido.Total);
        DBMS_OUTPUT.PUT_LINE('  Total actualizado: ' || v_total_actualizado);
    END LOOP;
    CLOSE pedido_cursor;
END;
/

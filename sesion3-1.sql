
-- Actividad 1: Verificación de valor con excepción personalizada y manejo de NO_DATA_FOUND
DECLARE
    v_valor NUMBER;
    bias CONSTANT NUMBER := 10;
    valor_bajo EXCEPTION;
BEGIN
    -- Intentamos obtener un valor de una tabla (simulada aquí como Productos)
    SELECT Precio INTO v_valor
    FROM Productos
    WHERE ProductoID = 10;

    -- Verificamos si el valor es menor al bias
    IF v_valor < bias THEN
        RAISE valor_bajo;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Valor aceptable: ' || v_valor);

EXCEPTION
    WHEN valor_bajo THEN
        DBMS_OUTPUT.PUT_LINE('Error: El valor (' || v_valor || ') es menor que el bias (' || bias || ').');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se encontró el producto con ID 10.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/

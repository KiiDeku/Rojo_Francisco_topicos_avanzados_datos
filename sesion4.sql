DECLARE
    -- Variables para almacenar el total y la categoría
    v_total NUMBER := 850; -- Simulamos un valor total obtenido
    v_categoria VARCHAR2(20);

    -- Criterios definidos por el usuario:
    -- Alto: v_total >= 1000
    -- Medio: v_total >= 500 y < 1000
    -- Bajo: v_total < 500
BEGIN
    -- Clasificación del total según los criterios
    IF v_total >= 1000 THEN
        v_categoria := 'Alto';
    ELSIF v_total >= 500 THEN
        v_categoria := 'Medio';
    ELSE
        v_categoria := 'Bajo';
    END IF;

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('Total: ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Clasificación: ' || v_categoria);
END;
/

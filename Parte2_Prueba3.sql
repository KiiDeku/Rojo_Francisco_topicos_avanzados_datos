-- ========================
-- PARTE 2 - EJERCICIOS PRÁCTICOS
-- Francisco Rojo Alfaro
-- ========================

-- Ejercicio 1: 
1. Escribe un procedimiento registrar_tiempo que reciba un
AsignacionID, Fecha y HorasTrabajadas (parámetros IN). El
procedimiento debe
○ Insertar un nuevo registro en RegistrosTiempo (usa el
próximo RegistroID disponible).
○ Validar que las horas no excedan 8 por día para esa
asignación.
○ Usar savepoints para manejar errores (por ejemplo, si las
horas exceden el límite).
○ Manejar excepciones y transacciones adecuadamente



CREATE OR REPLACE PROCEDURE registrar_tiempo (
    p_AsignacionID IN NUMBER,
    p_Fecha IN DATE,
    p_HorasTrabajadas IN NUMBER
)
IS
    v_TotalHoras NUMBER := 0;
BEGIN
    SAVEPOINT inicio;

    SELECT NVL(SUM(HorasTrabajadas), 0)
    INTO v_TotalHoras
    FROM RegistrosTiempo
    WHERE AsignacionID = p_AsignacionID AND Fecha = p_Fecha;

    IF v_TotalHoras + p_HorasTrabajadas > 8 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Excede el limite de 8 horas por dia.');
    END IF;

    INSERT INTO RegistrosTiempo (AsignacionID, Fecha, HorasTrabajadas)
    VALUES (p_AsignacionID, p_Fecha, p_HorasTrabajadas);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Registro insertado correctamente.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO inicio;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Ejercicio 2:
Diseña una tabla de hechos Fact_HorasTrabajadas y una
dimensión Dim_Proyecto para un Data Warehouse basado en la
base de datos de la prueba. Escribe una consulta analítica
que muestre las horas totales trabajadas por proyecto y mes



CREATE TABLE Dim_Proyecto (
    ProyectoID NUMBER PRIMARY KEY,
    NombreProyecto VARCHAR2(100)
);


INSERT INTO Dim_Proyecto (ProyectoID, NombreProyecto)
SELECT ProyectoID, Nombre FROM Proyectos;

CREATE TABLE Fact_HorasTrabajadas (
    FactID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ProyectoID NUMBER,
    Fecha DATE,
    HorasTrabajadas NUMBER(5,2)
);

INSERT INTO Fact_HorasTrabajadas (ProyectoID, Fecha, HorasTrabajadas)
SELECT A.ProyectoID, R.Fecha, R.HorasTrabajadas
FROM RegistrosTiempo R
JOIN Asignaciones A ON R.AsignacionID = A.AsignacionID;

-- Consulta analítica: horas por proyecto y mes
SELECT 
    D.NombreProyecto,
    TO_CHAR(F.Fecha, 'YYYY-MM') AS Mes,
    SUM(F.HorasTrabajadas) AS TotalHoras
FROM Fact_HorasTrabajadas F
JOIN Dim_Proyecto D ON F.ProyectoID = D.ProyectoID
GROUP BY D.NombreProyecto, TO_CHAR(F.Fecha, 'YYYY-MM')
ORDER BY D.NombreProyecto, Mes;

-- Ejercicio 3:
Crea un índice compuesto en RegistrosTiempo para las
columnas AsignacionID y Fecha. Luego, particiona la tabla
RegistrosTiempo por rango de fechas (mensual, para 2025).
Escribe una consulta que muestre las horas trabajadas por
asignación en marzo de 2025 y analiza su plan de ejecución.



-- Índice compuesto
CREATE INDEX idx_asig_fecha ON RegistrosTiempo (AsignacionID, Fecha);



 -- Si quieres eliminar índices o tablas viejos
DROP INDEX idx_asig_fecha;
DROP TABLE RegistrosTiempo_2025;

-- Crear tabla particionada
CREATE TABLE RegistrosTiempo_2025 (
    RegistroID NUMBER PRIMARY KEY,
    AsignacionID NUMBER,
    Fecha DATE,
    HorasTrabajadas NUMBER(5,2)
)
PARTITION BY RANGE (Fecha) (
    PARTITION mar2025 VALUES LESS THAN (TO_DATE('2025-04-01', 'YYYY-MM-DD')),
    PARTITION abr2025 VALUES LESS THAN (TO_DATE('2025-05-01', 'YYYY-MM-DD')),
    PARTITION may2025 VALUES LESS THAN (TO_DATE('2025-06-01', 'YYYY-MM-DD'))
);

-- Consulta para marzo 2025
SELECT AsignacionID, SUM(HorasTrabajadas) AS TotalHoras
FROM RegistrosTiempo
WHERE Fecha BETWEEN TO_DATE('2025-03-01', 'YYYY-MM-DD') AND TO_DATE('2025-03-31', 'YYYY-MM-DD')
GROUP BY AsignacionID;

-- Para ver plan de ejecución:
EXPLAIN PLAN FOR
SELECT AsignacionID, SUM(HorasTrabajadas)
FROM RegistrosTiempo
WHERE Fecha BETWEEN TO_DATE('2025-03-01', 'YYYY-MM-DD') AND TO_DATE('2025-03-31', 'YYYY-MM-DD');

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

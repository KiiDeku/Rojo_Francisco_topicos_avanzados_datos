

SET SERVEROUTPUT ON;

/******************************************************************************
 * ACTIVIDAD 1: Definir roles y permisos para el proyecto. 
 ******************************************************************************/
BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE rol_usuario_proyecto';
    DBMS_OUTPUT.PUT_LINE('Rol rol_usuario_proyecto creado.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -1921 THEN NULL; ELSE RAISE; END IF;
END;
/
BEGIN
    EXECUTE IMMEDIATE 'CREATE ROLE rol_admin_proyecto';
    DBMS_OUTPUT.PUT_LINE('Rol rol_admin_proyecto creado.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -1921 THEN NULL; ELSE RAISE; END IF;
END;
/

-- Asignar permisos 
GRANT CONNECT, RESOURCE TO rol_usuario_proyecto;
GRANT SELECT, INSERT ON curso_topicos.Productos TO rol_usuario_proyecto;
GRANT SELECT, INSERT ON curso_topicos.Pedidos TO rol_usuario_proyecto;
GRANT ALL PRIVILEGES ON curso_topicos.Productos TO rol_admin_proyecto;
GRANT ALL PRIVILEGES ON curso_topicos.Pedidos TO rol_admin_proyecto;
GRANT ALL PRIVILEGES ON curso_topicos.Clientes TO rol_admin_proyecto;
GRANT CONNECT, RESOURCE, DBA TO rol_admin_proyecto; -- Rol de admin con más poder

-- Crear usuarios y asignar roles 
BEGIN
    EXECUTE IMMEDIATE 'CREATE USER usuario_p1 IDENTIFIED BY user123';
    DBMS_OUTPUT.PUT_LINE('Usuario usuario_p1 creado.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -1920 THEN NULL; ELSE RAISE; END IF;
END;
/
GRANT rol_usuario_proyecto TO usuario_p1;

BEGIN
    EXECUTE IMMEDIATE 'CREATE USER admin_p1 IDENTIFIED BY admin123';
    DBMS_OUTPUT.PUT_LINE('Usuario admin_p1 creado.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -1920 THEN NULL; ELSE RAISE; END IF;
END;
/
GRANT rol_admin_proyecto TO admin_p1;
DBMS_OUTPUT.PUT_LINE('Roles y usuarios del proyecto configurados.');


/******************************************************************************
 * ACTIVIDAD 2: Optimizar una consulta crítica del proyecto. 
 ******************************************************************************/

-- Paso 1: Analizar consulta ANTES de la optimización
DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Plan de Ejecución ANTES de optimizar ---');
EXPLAIN PLAN FOR
SELECT c.Nombre, SUM(p.Total) AS TotalVentas
 FROM Clientes c
 JOIN Pedidos p ON c.ClienteID = p.ClienteID
 GROUP BY c.Nombre;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Paso 2: Crear índice para la mejora 
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX idx_pedidos_cliente_fk ON Pedidos(ClienteID)';
    DBMS_OUTPUT.PUT_LINE('Índice idx_pedidos_cliente_fk creado para optimizar.');
EXCEPTION WHEN OTHERS THEN IF SQLCODE = -955 THEN NULL; ELSE RAISE; END IF;
END;
/

-- Paso 3: Analizar consulta DESPUÉS de la optimización
DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Plan de Ejecución DESPUÉS de optimizar ---');
EXPLAIN PLAN FOR
SELECT c.Nombre, SUM(p.Total) AS TotalVentas
 FROM Clientes c
 JOIN Pedidos p ON c.ClienteID = p.ClienteID
 GROUP BY c.Nombre;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
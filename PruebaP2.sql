---------------------------------Parte 2: Codigos------------------------------------

/*1)Escribe un bloque PL/SQL con un cursor explícito que liste
los departamentos con un salario promedio mayor a 600000,
mostrando el nombre del departamento y el promedio de
salario de sus empleados. Usa un JOIN entre Departamentos y
Empleados.*/

DECLARE
    CURSOR c_dept_sueldo IS
        SELECT d.Nombre, AVG(e.Salario) AS promedio_sueldo
        FROM Departamentos d
        JOIN Empleados e ON d.DepartamentoID = e.DepartamentoID
        GROUP BY d.Nombre
        HAVING AVG(e.Salario) > 600000;
BEGIN
    FOR rec IN c_dept_sueldo LOOP
        DBMS_OUTPUT.PUT_LINE('Departamento: ' || rec.Nombre || ' - Promedio Sueldo: ' || rec.promedio_sueldo);
    END LOOP;
END;
/





/*2)Escribe un bloque PL/SQL con un cursor explícito que reduzca
un 5% el presupuesto de los proyectos que tienen un
presupuesto mayor a 1500000. Usa FOR UPDATE y maneja
excepciones.*/

DECLARE
	CURSOR dismi_cursor IS
	SELECT EmpleadoID, Salario
	FROM Empleados
	WHERE Salario < 1500000
	FOR UPDATE;
	v_Empleadoid NUMBER;
	v_Salario NUMBER;
	v_dismi NUMBER := 5;
BEGIN
	OPEN dismi_cursor;
	LOOP
		FETCH dismi_cursor INTO v_Empleadoid, v_Salario;
		EXIT WHEN dismi_cursor%NOTFOUND;
		UPDATE Empleados
		SET Salario = v_Salario - (v_Salario / (v_dismi*100))
		WHERE CURRENT OF dismi_cursor;
		DBMS_OUTPUT.PUT_LINE('Salario ' || v_Empleadoid || ' actualizado a: ' || (v_Salario - (v_Salario * (v_dismi / 100))));
	END LOOP;
	CLOSE dismi_cursor;
	COMMIT;
EXCEPTION
	WHEN OTHERS THEN
	 DBMS_OUTPUT.PUT_LINE('Algo paso: ' || SQLERRM);
	 IF dismi_cursor%ISOPEN THEN
	 	CLOSE dismi_cursor;
	 END IF;
END;
/


/*3)Crea un tipo de objeto empleado_obj con atributos
empleado_id, nombre, y un método get_info. Luego, crea una
tabla basada en ese tipo y transfiere los datos de Empleados
a esa tabla. Finalmente, escribe un cursor explícito que
liste la información de los empleados usando el método
get_info.*/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE empleados_obj_tabla';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN
   EXECUTE IMMEDIATE 'DROP TYPE empleado_obj';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

CREATE OR REPLACE TYPE empleado_obj AS OBJECT (
    EmpleadoID NUMBER,
    Nombre VARCHAR2(50),
    MEMBER FUNCTION get_info RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY empleado_obj AS
    MEMBER FUNCTION get_info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Empleado ID: ' || EmpleadoID || ' - Nombre: ' || Nombre;
    END;
END;
/

CREATE TABLE empleados_obj_tabla OF empleado_obj;

BEGIN
    INSERT INTO empleados_obj_tabla
    SELECT empleado_obj(EmpleadoID, Nombre)
    FROM Empleados;
    COMMIT;
END;
/

DECLARE
    CURSOR c_empleados IS
        SELECT VALUE(e) FROM empleados_obj_tabla e;
    v_empleado empleado_obj;
BEGIN
    OPEN c_empleados;
    LOOP
        FETCH c_empleados INTO v_empleado;
        EXIT WHEN c_empleados%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_empleado.get_info());
    END LOOP;
    CLOSE c_empleados;
END;
/

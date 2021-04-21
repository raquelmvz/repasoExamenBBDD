/* 1. Para la base de datos “empresa_clase” obtener, dado el código de un 
empleado, la contraseña de acceso formada por:
	i. Inicial del nombre + 10 caracteres.
	ii. Tres primeras letras del primer apellido + 5 caracteres.
	iii. Tres primeras letras del segundo apellido (o “LMN” en caso de no tener 
    2o apellido) + 5 caracteres.
	iv. El último dígito del dni (sin la letra). */
DROP FUNCTION IF EXISTS ejer_U6_R6_1;
DELIMITER $$

CREATE FUNCTION ejer_U6_R6_1(empleado int)
  RETURNS CHAR(8)
    LANGUAGE SQL
    DETERMINISTIC
    reads sql data

BEGIN    
	/*
     PARA EVA TORTOSA SÁNCHEZ DNI 25000000
		A ==> E+10 ==> O
        B ==> T+5-O+5-R+5 ==> Z-T-W
        C ==> S+5-A+5-N+5 ==> X-F-S
        D ==> 0
        REVERSE(OZTWXFS0)
    */

    return (SELECT reverse(concat(
							char(ascii(left(nomem,1))+10),
							concat(CHAR(ASCII(LEFT(ape1em,1))+5),
								   CHAR(ASCII(substring(ape1em,2,1))+5),
								   CHAR(ASCII(substring(ape1em,3,1))+5)
								),
							concat(CHAR(ASCII(ifnull(LEFT(ape2em,1),'L'))+5),
								   CHAR(ASCII(ifnull(substring(ape2em,2,1),'M'))+5),
								   CHAR(ASCII(ifnull(substring(ape2em,3,1),'N'))+5)
								),
							substring(ifnull(dniem,'3'),-2,1)
							)
                            )
			FROM empleados
			WHERE numem = empleado);
            
            -- char(x) --> devuelve el caracter con ese cod ascii
            -- ascii(x) --> devuelve el valor ascii de un caracter
	/* NOTA.- En el caso de utilizar variables y devolver variables, 
    es posible que sea necesario usar la función CONVERT para convertir a "CHAR(n)" el resultado de
    ejecutar CHAR(ASCII(X))
    */
   
END $$

DELIMITER ;

/* 2. Para la base de datos “BDAlmacen” obtener por separado el nombre, 
el primer apellido y el segundo apellido de los
proveedores. */
use bdalmacen;
DROP PROCEDURE IF EXISTS ejer_U6_R6_2;
DELIMITER $$

CREATE PROCEDURE ejer_U6_R6_2()
    LANGUAGE SQL
    DETERMINISTIC

BEGIN
-- call ejer_U6_R6_2();

/* 
OJO:
TODO LO QUE VAMOS A HACER FUNCIONA SOLO PARA NOMBRES DE CONTACTO CON NOMBRES 
SIMPLES Y 2 APELLIDOS 
(SI NO TENEMOS EL 2º APELLIDO, HABRÍA QUE USAR IFNULL)
LOS APELLIDOS COMPUESTOS TAMPOCO SE ESTÁN TRATANDO BIEN.
SE PODRÍA HACER, PERO HABRÍA QUE COMPLICARLO MUCHO MÁS.
CONCLUSIÓN ==> LA PRIMERA FORMA NORMAL ES MUY IMPORTANTE

VEAMOSLO POR PARTES, VAMOS A IR HACIENDO SELECTS QUE ME PERMITAN VER POCO A 
POCO LO QUE NECESITAMOS:
-- para obtener una posición de una cadena:
select nomcontacto, locate(' ', nomcontacto)
from proveedores;
-- obtenemos el nombre y la cadena sin el nombre:
select nomcontacto, left(nomcontacto, locate(' ', nomcontacto)-1) as nombre, 
	substring(nomcontacto, locate(' ', nomcontacto)+1) as sin_nombre 
from proveedores;
-- obtenemos el nombre y el primer apellido:
select nomcontacto, left(nomcontacto, locate(' ', nomcontacto)-1) as nombre, 
	left(substring(nomcontacto, locate(' ', nomcontacto)+1), locate(' ', substring(nomcontacto, locate(' ', nomcontacto)+1))) as apellido1 
from proveedores;
-- para el 2º apellido voy a usar right hasta la segunda aparición de espacio en blanco + 1 ==>
select nomcontacto, 
     substring(nomcontacto, locate(' ', nomcontacto)+1),
	locate(' ', substring(nomcontacto, locate(' ', nomcontacto)+1)) as posicion2ape,
	right(substring(nomcontacto, locate(' ', nomcontacto)+1), locate(' ', substring(nomcontacto, locate(' ', nomcontacto)+1))) as apellido2
from proveedores;

PROBEMOS LA FUNCIÓN SUBSTRING_INDEX:
select SUBSTRING_INDEX('Eva Tortosa Sánchez', ' ',-1); -- Devuelve: Sánchez
select SUBSTRING_INDEX('Eva Tortosa Sánchez', ' ',1); -- Devuelve: Eva

select SUBSTRING_INDEX('Eva Tortosa Sánchez', ' ',2); -- Devuelve: Eva Tortosa
select substring('Eva Tortosa Sánchez', locate(' ', 'Eva Tortosa Sánchez',1)+1) -- Devuelve: Tortosa Sánchez
set @cadena = substring('Eva Tortosa Sánchez', locate(' ', 'Eva Tortosa Sánchez',1)+1); -- @cadena ==> Tortosa Sánchez
select SUBSTRING_INDEX(@cadena, ' ',1); -- Devuelve: Tortosa

POR TANTO:
*/
select nomcontacto, SUBSTRING_INDEX(nomcontacto, ' ',1) as nombre, 
	substring(nomcontacto, locate(' ', nomcontacto)+1) as sin_nombre,
	SUBSTRING_INDEX(substring(nomcontacto, locate(' ', nomcontacto,1)+1), ' ',1) 
    as apellido1,
	SUBSTRING_INDEX(nomcontacto, ' ',-1) as apellido2
from proveedores;
END $$
DELIMITER ;

/* 3.  Obtener un procedimiento que obtenga el salario de los empleados incrementado 
en un 5%. El formato de salida del
salario incrementado debe ser con dos decimales.*/
DROP PROCEDURE IF EXISTS ejer_U6_R6_3;
DELIMITER $$
CREATE PROCEDURE ejer_U6_R6_3
		()
	LANGUAGE SQL
    DETERMINISTIC
    COMMENT 'MÓDULO: BASES DE DATOS - UNIDAD 6 - RELACION 6- EJERCICIO 3'
BEGIN
/* call  ejer_U6_R6_3(); */
	select numem, nomem, salarem, round(salarem*1.05,2)
    from empleados;
END $$
DELIMITER ;

/* 4. Prepara una función que determine si un valor que se pasa como 
parámetro es una fecha correcta o no. */
drop function if exists esfecha_ejer_6_6_4;
delimiter $$
create function esfecha_ejer_6_6_4 
	(cadena char(15) )
returns char(10)
	NO SQL
    DETERMINISTIC
     COMMENT 'MÓDULO: BASES DE DATOS - UNIDAD 6 - RELACION 6- EJERCICIO 4'
begin
	declare resultado bit;
if str_to_date(cadena,'%d%m%a') is null then
		set resultado = 'false';
else
	set resultado = 'verdadero';
end if;
return resultado;
end $$
delimiter ;

/* 5. Para la base de datos “Empresa_clase” prepara un procedimiento que 
devuelva la edad de un empleado. */
drop procedure if exists calculaedad_ejer_6_6_5;
delimiter $$
create procedure calculaedad_ejer_6_6_5 (in empleado int, out edad int )

LANGUAGE SQL
    DETERMINISTIC
    reads sql data
	COMMENT 'MÓDULO: BASES DE DATOS - UNIDAD 6 - RELACION 6- EJERCICIO 5'
begin
	-- call calculaedad_ejer_6_6_5(110, @edad);
	-- select @edad;
	set edad = (select timestampdiff(year,curdate(),fecnaem)
				from empleados
				where numem = empleado);
end $$
delimiter ;

/* 6. Para la base de datos “EMPRESA_CLASE” obtener el día que termina el 
periodo de prueba de un empleado, dado su
código de empleado. El periodo de prueba será de 3 meses. */
drop function if exists periodoprueba_ejer_6_6_6;
delimiter $$
create function periodoprueba_ejer_6_6_6 
	(empleado int)
returns date
	LANGUAGE SQL
    DETERMINISTIC
    
    COMMENT 'MÓDULO: BASES DE DATOS - UNIDAD 6 - RELACION 6- EJERCICIO 6'
begin
	-- PROBAMOS ==> select periodoprueba_ejer_6_6_6(110);
    -- NOTA.- Inserta un empleado nuevo y prueba con dicho empleado
	declare resultado date;
    
    select date_add(ifnull(fecinem, curdate()), interval 3 month)  into resultado
    from empleados
    where numem = empleado;
    
    return resultado;
end $$
delimiter ;

/* 7. Nuestro sistema MS Sql Server tiene como primer día de la semana el 
domingo. Cámbialo al lunes. Obtén el nombre del
primer día de la semana del sistema. */
*/
/*********** ACLARACIÓN  ***************/
/*
En todos los motores de BBDD, o casi todos, el primer día de la semana es el domingo, por tanto, si ejecutamos la siguiente 
función, en nuestro caso es una función de MySQL, pero que tiene su equivalente en otros motores:
SELECT DAYOFWEEK(CURDATE()); ==> si hoy fuera domingo devolverá 1
							 ==> si hoy fuera lunes devolverá 2
                             ...
En MS Sql Server se puede modificar el primer día de la semana del sistema a través de una variable, igual que se puede
modificar por ejemplo, el formato en el que se almacena la fecha y no tendríamos que escribir "año/mes/día"

En MySQL, creo que no se puede.... aunque puede que lo incluyan/hayan incluido en alguna versión.

En cualquier caso, nosotros podemos modificar este comportamiento mediante una función:
*/
/*********** FIN DE ACLARACIÓN  ***************/
drop function if exists numDiaSemana_ejer_6_6_7;
delimiter $$
create function numDiaSemana_ejer_6_6_7
	(fecha date)
returns int
	NO SQL
    DETERMINISTIC
    
    COMMENT 'MÓDULO: BASES DE DATOS - UNIDAD 6 - RELACION 6- EJERCICIO 7'
begin
	-- PROBAMOS ==> select numDiaSemana_ejer_6_6_7(curdate());
	-- select numDiaSemana_ejer_6_6_7('2020/3/22');
	declare resultado int;
    
    set resultado =if(dayofweek(fecha)=1, 7,dayofweek(fecha)-1);
    /* aclaración:
    dayofweek(fecha) si fecha es domingo ==> 1 , por tanto lo cambio a 7
	dayofweek(fecha) si fecha es lunes ==> 2, por tanto es  dayofweek(fecha)-1
    dayofweek(fecha) si fecha es martes ==> 3, por tanto es  dayofweek(fecha)-1
    ...
    */
    return resultado;
end $$
delimiter ;

/* 8. Obtener el nombre completo de los empleados y la fecha de nacimiento 
con los siguientes formatos:
a. “05/03/1978”
b. 5/3/1978
c. 5/3/78
d. 05-03-78
e. 05 Mar 1978 */
/* date_format varios formatos 
1. “05/03/1978”
2. 5/3/1978
3. 5/3/78
4. 05-03-78
5. 05 Mar 1978
6. 5 de marzo de 1978
7. Miércoles, 25 de marzo de 2015
*/
select date_format(curdate(), '%d/%m/%Y'),
date_format(Curdate(), '%e/%c/%Y'),
date_format(curdate(), '%e/%c/%y'),
date_format(curdate(), '%d-%m-%y'),
date_format(curdate(), '%d %b %Y'),
date_format(curdate(), '%e de %M de %Y'),
date_format(curdate(), '%W, %2 de %M de %Y');

select date_format(curdate(),'En Estepona a %e de %M de %Y');


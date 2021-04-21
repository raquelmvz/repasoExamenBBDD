/* 1. Prepara un procedimiento almacenado que obtenga el salario máximo de la empresa */
drop procedure if exists proc_ejer_6_3_1;
delimiter $$
create procedure proc_ejer_6_3_1(out maxsalario decimal(7,2))
begin
	/* call proc_ejer_6_3_1(@maximosalar);
		select @maximosalar;
	*/	
    set maxsalario = (select max(salarem)
						from empleados);
end $$
delimiter ;


/* 3. Prepara un procedimiento almacenado que obtenga el salario medio de la empresa */
drop procedure if exists proc_ejer_6_3_3;
delimiter $$
create procedure proc_ejer_6_3_3(out salarmedio decimal(7,2))
begin
	/* call proc_ejer_6_3_3(@avgsalar);
		select @avgsalar;
    */
    set salarmedio = (select avg(salarem)
						from empleados);
end $$
delimiter ;

/* 4. Prepara 1 procedimiento almacenado que obtenga el salario máximo, 
mínimo y medio del departamento “Organización” */
drop procedure if exists proc_ejer_6_3_4;
delimiter $$
create procedure proc_ejer_6_3_4(out salariomax decimal(7,2), 
		out salariomin decimal(7,2), out salariomedio decimal(7,2))
begin
	/* call proc_ejer_6_3_4(@salarmax, @salarmin, @salarmed);
		select @salarmax, @salarmin, @salarmed;
	*/
    select max(empleados.salarem), min(empleados.salarem), 
			avg(empleados.salarem) into salariomax, salariomin, salariomedio
				from empleados join departamentos
				on empleados.numde = departamentos.numde
				where departamentos.nomde = 'Organización';
                        
end $$
delimiter ;

/* 5. Prepara un procedimiento almacenado que obtenga lo mismo que el del 
apartado anterior pero de forma que podamos cambiar el departamento para el 
que se obtiene dichos resultados.
*/
drop procedure if exists proc_ejer_6_3_5;
delimiter $$

create procedure proc_ejer_6_3_5(in dpto varchar(60),
								 out maxsalario decimal(7,2),
								 out minsalario decimal(7,2),
								 out salariomedio decimal(7,2)
								 )
begin
	/* call proc_ejer_6_3_5('Organización',@maxsalario,@minsalario, @salariomedio);
		select @maxsalario;
        set @maxsalario = @maxsalario+ 1000;
		select @minsalario;
		select @salariomedio;
        select @maxsalario as maxSalario, @minsalario as minSalario, @salariomedio as medioSalario
	*/	
	select max(empleados.salarem), min(empleados.salarem),
		avg(empleados.salarem) into maxsalario, minsalario, salariomedio
	from empleados join departamentos 
		on empleados.numde = departamentos.numde
	where departamentos.nomde = dpto;
end $$
delimiter ;

/* 6. Prepara un procedimiento almacenado que obtenga lo que se paga en 
salarios para un departamento en cuestión */
drop procedure if exists proc_ejer_6_3_6;
delimiter $$
create procedure proc_ejer_6_3_6(in numdpto int, 
								 out coste_empleados decimal(9,2))
begin
	/* call proc_ejer_6_3_6(110, @coste_emp);
		select @coste_emp;
	*/	
	set coste_empleados = (select sum(empleados.salarem+ifnull(empleados.comisem,0))
						   from empleados
						   where numde = numdpto);
                           
	/*
    o también:
    select sum(empleados.salarem+ifnull(empleados.comisem,0)) into coste_empleados
	from empleados
	where numde = numdpto;
    
    */
end $$
delimiter ;

/* con un procedimiento que únicamente muestre el resultado*/
drop procedure if exists proc_ejer_6_3_6_ver2;
delimiter $$
create procedure proc_ejer_6_3_6_ver2(in numdpto int)
begin
	/* call proc_ejer_6_3_6_ver2(110);

	*/	
	select sum(empleados.salarem+ifnull(empleados.comisem,0))
	from empleados
	where numde = numdpto;
end $$
delimiter ;

/* 7. Prepara un procedimiento almacenado nos dé el presupuesto total de la empresa. */
drop procedure if exists proc_ejer_6_3_7;
delimiter $$
create procedure proc_ejer_6_3_7(out gasto decimal(9,2))

begin
	/* call proc_ejer_6_3_7(@gasto_total);
	   select @gasto_total;
	*/
	declare salarios, presupuestos decimal(9,2);
	
	set salarios = func_ejer_6_3_6_ver_B();
	set presupuestos = (
						select sum(presude)
						from departamentos
					   );
	
	set gasto= salarios + presupuestos;

	/* o también: 
	set gasto= func_ejer_6_3_6_ver_B() + (select sum(presude)
									  from departamentos);*/
end $$
delimiter ;

/* 8. Prepara un procedimiento almacenado que obtenga el salario máximo, 
mínimo y medio para cada departamento. */
drop procedure if exists proc_ejer_6_3_8;
delimiter $$

create procedure proc_ejer_6_3_8()
begin
	/* call proc_ejer_6_3_8();
	*/	
	select departamentos.nomde as departamento,
		  max(empleados.salarem) as maxsalario, 
		  min(empleados.salarem) as minsalario,
		avg(empleados.salarem) as salariomedio
	from empleados join departamentos 
		on empleados.numde = departamentos.numde
	group by departamentos.nomde;
end $$
delimiter ;

/* 9. Prepara un procedimiento almacenado que obtenga el número de extensiones 
de teléfono diferentes que hay en la empresa */
drop procedure if exists proc_ejer_6_3_9;
delimiter $$

create procedure proc_ejer_6_3_9()
begin
	/* call proc_ejer_6_3_9();
	*/	
	select count(distinct extelem) -- , count(*), count(extelem)
	from empleados
    group by extelem;

/** Si me pidieran 
"obtener cuantos empleados utilizan cada extensión telefónica"
sería:

select extelem, count(*)
from empleados
group by extelem;
    
*/    
end $$
delimiter ;

/*ejer 9 - con parámetros de salida*/

drop procedure if exists proc_ejer_6_3_9_ver2;
delimiter $$

create procedure proc_ejer_6_3_9_ver2(out numextensiones int)
begin
	/* call proc_ejer_6_3_9_ver2(@numextensiones);
		select @numextensiones;
	*/	
	set @numextensiones = (select count(distinct extelem)
						   from empleados);
end $$
delimiter ;

/* 10. Prepara un procedimiento almacenado que obtenga el número de 
extensiones de teléfono diferentes que utiliza un departamento */
drop procedure if exists proc_ejer_6_3_10;
delimiter $$
create procedure proc_ejer_6_3_10(in numdpto int, 
								  out numexten int)
begin
	/* call proc_ejer_6_3_10(110, @numextensiones);
		select concat('El depto 110 tiene ', @numextensiones, ' extensiones');
	*/	
	/*set numexten = (select count(distinct extelem) 
					from empleados
					where numde = numdpto);
*/
	select count(distinct extelem) into numexten
	from empleados
	where numde = numdpto;
end $$
delimiter ;

/* 11. Prepara un procedimiento almacenado que obtenga el número de 
extensiones de teléfono diferentes que utiliza cada departamento.
*/
drop procedure if exists proc_ejer_6_3_11;
delimiter $$
create procedure proc_ejer_6_3_11()
begin
	/* call proc_ejer_6_3_11();
	*/	
	select departamentos.nomde, count(distinct extelem) 
	from empleados join departamentos on empleados.numde = departamentos.numde
	group by departamentos.nomde ;
end $$
delimiter ;





                        




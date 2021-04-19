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
                        
        



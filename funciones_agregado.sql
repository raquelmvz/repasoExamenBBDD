/* Prepara un procedimiento almacenado que obtenga el salario máximo de la empresa */
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

/* Prepara un procedimiento almacenado que obtenga el salario medio de la empresa */
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

/* Prepara 1 procedimiento almacenado que obtenga el salario máximo, 
mínimo y medio del departamento “Organización” */




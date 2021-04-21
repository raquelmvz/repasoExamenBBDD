/** EJERCICIO 1 **/
select clientes.codcli, nomcli, sum(precioventa)
from clientes join ventas
		on clientes.codcli = ventas.codcli
    join detalleVenta
		on ventas.codventa = detalleVenta.codventa
group by clientes.codcli
order by sum(precioventa) desc;

/** EJERCICIO 2 **/
select desart, concat(nomart,' (',descat,')'), date_format(fecventa, '%M - %Y, %d (%W)')
from articulos join categorias
		on articulos.codcat = categorias.codcat
    join detalleVenta
		on articulos.refart = detalleVenta.refart
	join ventas
		on ventas.codventa = detalleVenta.codventa
order by categorias.descat;


/** EJERCICIO 3 **/

select despromo, avg(precioartpromo)
from articulos join catalogospromos
		on articulos.refart = catalogospromos.refart
	join promociones
		on catalogospromos.codpromo = promociones.codpromo
where year(fecinipromo)=2012
group by promociones.codpromo;


delimiter $$

/** EJERCICIO 4 **/
drop procedure if exists exam_2019_5_2_4 $$
create procedure exam_2019_5_2_4()
begin
	-- call exam_2019_5_2_4()
    -- NOTA: para probar, da de alta una promoción de este año con dos artículos, por ejemplo el 'C1_01' y el 'C2_01'
	select refart, nomart, codcat
    from articulos
    where refart not in (select refart
						 from catalogospromos join promociones
							on catalogospromos.codpromo = promociones.codpromo
						 where year(fecinipromo) = year(curdate())
                         );
end $$

/** EJERCICIO 5 **/
delimiter $$
drop function if exists exam_2019_5_2_5 $$
create function exam_2019_5_2_5
	(correo varchar(30),
	telefono char(9))
returns char(7)
begin
	-- select exam_2019_5_2_5('EliseaPabonAngulo@dodgit.com', '984 208 4')
	return (
			select concat(left(trim(nomcli),1), 
						  substring(email, 3,1),
						  substring(email, 4,1),
						  substring(email, 5,1), 
						  length(concat(trim(nomcli), trim(ape1cli), ifnull(trim(ape2cli),'')))
						)
			from clientes
			where email = correo and tlfcli = telefono
        );
        
end $$
delimiter ;

/** EJERCICIO 6 **/

/* PROBAR CON:
UPDATE `gestventapromos`.`vendedores` SET `nomvende` = 'Pedro González Sánchez' WHERE (`codvende` = '1');
UPDATE `gestventapromos`.`vendedores` SET `nomvende` = 'María Pérez Lima' WHERE (`codvende` = '2');
UPDATE `gestventapromos`.`vendedores` SET `nomvende` = 'Germán Torres Campos' WHERE (`codvende` = '3');
UPDATE `gestventapromos`.`vendedores` SET `nomvende` = 'Anaís Rubio García' WHERE (`codvende` = '4');
*/
select nomvende, concat(
						substring(nomvende,1,1),
						substring(nomvende,
								  locate(' ',nomvende)+1,3),
						substring(nomvende,locate(' ',nomvende,locate(' ',nomvende) + 1)+1,3)
					)
from vendedores;

/** EJERCICIO 7 **/
delimiter $$
drop procedure if exists exam_2019_5_2_7 $$
create procedure exam_2019_5_2_7
	(in anyo int)
begin    
	-- call exam_2019_5_2_7(2012);
	select despromo, avg(precioartpromo)
	from catalogospromos join promociones
		on catalogospromos.codpromo = promociones.codpromo
	-- NOTA: quitar where para probar, ya que no hay datos de este año
	where year(fecinipromo)=year(curdate()) and month(fecinipromo)=month(curdate())
	group by promociones.codpromo
	having avg(precioartpromo) in (select avg(precioartpromo)
								   from catalogospromos join promociones
										on catalogospromos.codpromo = promociones.codpromo
								   where year(fecinipromo)=anyo
								   group by promociones.codpromo
								   );
end $$
delimiter ;

/** EJERCICIO 8 **/

select refart, nomart
from articulos
where precioventa = any (
						select precioartpromo
						from catalogospromos
						where catalogospromos.refart = articulos.refart
						);

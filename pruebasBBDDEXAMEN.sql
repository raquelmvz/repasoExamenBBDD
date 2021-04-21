/* un select de los emails que esten mal es decir tengan mas de un "@ o un . seguido de 2 o 3 caracteres */
select *
from clientes
where not email rlike '@[a-z]*\\.(com|net|es|eu)$';

select clientes.codcli, nomcli, sum(precioventa)
from clientes join ventas
		on clientes.codcli = ventas.codcli
    join detalleVenta
		on ventas.codventa = detalleVenta.codventa
group by clientes.codcli
order by sum(precioventa) desc;


select desart, concat(nomart,' (',descat,')'), date_format(fecventa, '%M - %Y, %d (%W)')
from articulos join categorias
		on articulos.codcat = categorias.codcat
    join detalleVenta
		on articulos.refart = detalleVenta.refart
	join ventas
		on ventas.codventa = detalleVenta.codventa
order by categorias.descat; -- aparecen juntos por cat

select promociones.codpromo, promociones.despromo, avg(catalogospromos.precioartpromo), articulos.desart
from articulos join catalogospromos on articulos.refart = catalogospromos.refart
	join promociones on catalogospromos.codpromo = promociones.codpromo
where year(promociones.fecinipromo)= 2012
group by promociones.codpromo; -- si no se usa el group by
-- solo aparece primavera 2012

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





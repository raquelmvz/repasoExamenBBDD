-- EJERCICIO PROPUESTO:

-- PARA LA BD DE PROMOCIONES:
/*
QUEREMOS TENER PREPARADO SIEMPRE (VISTA) UN LISTADO CON LOS PRECIOS A DÍA DE HOY (CUANDO SE CONSULTE) DE LOS ARTÍCULOS
NECESITO: refart, nomarticulo preciobase, pecioHoy, codcat

*/
create view catalogoprecios

(referencia, descripcion, preciobase, precioHoy, categoria)

as


select refart, nomart, preciobase, precioventa, codcaat

from articulos

where refarticulo not in
		
	(select catalogospromos.refarticulo
		 
	from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo	
	where curdate() between promociones.fecinipromo
	
				and date_add (promociones.fecinipromo,
 interval promociones.duracion day)

	)


union all /* se repiten */
-- union  /* no se repiten */


select articulos.desarticulo, catalogospromos.precioventa

from catalogospromos join promociones on catalogospromos.codpromo = promociones.codpromo	
	where curdate() between promociones.fecinipromo
	
				and date_add (promociones.fecinipromo,
 interval promociones.duracion day)

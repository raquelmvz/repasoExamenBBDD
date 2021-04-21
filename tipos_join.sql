/* 1. Queremos obtener un listado en el que se muestren los nombres de 
departamento y el número de empleados de cada uno. 
Ten en cuenta que algunos departamentos no tienen empleados, 
queremos que se muestren también estos departamentos sin empleados. 
(En este caso, el número de empleados se mostrará como null ==> no tiene sentido). 
*/
select departamentos.numde,departamentos.nomde, 
		count(departamentos.numde) 
        /*valdrá 1 para los departamentos sin empleados*/, 
        count(empleados.numde) as 'Número Empleados por depto'
from departamentos left join empleados
	on departamentos.numde = empleados.numde
group by departamentos.numde;

/* ejemplo de clase:
¿Cuantas veces ha sido director un empleado. Aquellos 
empleados que no hayan dirigido departamentos deben aparecer */

select numem, nomem, count(*), count(dirigir.numempdirec) as 'num veces director/a', 
	count(distinct dirigir.numempdirec), 
	count(dirigir.numdepto) as 'num veces director/a también', 
    count(distinct dirigir.numdepto) as 'num de deptos distintos dirigidos'
from empleados left join dirigir on empleados.numem = dirigir.numempdirec
group by numem;


/* 2. Queremos averiguar si tenemos algún departamento sin dirección, 
para ello queremos mostrar el nombre de cada departamento 
y el nombre del director actual, para aquellos departamentos que en 
la actualidad no tengan director, queremos mostrar el nombre 
del departamento y el nombre de la dirección como null.*/

select departamentos.numde, departamentos.nomde, empleados.nomem -- , dirigir.fecfindir
from departamentos left join dirigir on departamentos.numde = dirigir.numdepto
	left join empleados on dirigir.numempdirec = empleados.numem
where ifnull(dirigir.fecfindir,curdate()) >= curdate()
union
select distinct departamentos.numde, departamentos.nomde, null -- , dirigir.fecfindir
from departamentos left join dirigir on departamentos.numde = dirigir.numdepto
	left join empleados on dirigir.numempdirec = empleados.numem
where ifnull(dirigir.fecfindir,curdate()) < curdate() 
	and departamentos.numde not in (select numde
									from departamentos join dirigir on departamentos.numde = dirigir.numdepto
									where ifnull(dirigir.fecfindir,curdate()) >= curdate()
									)
;
/*
Para la base de datos turRural:
*/
USE gbdturrural2015;
/* 3. Queremos saber el código de las reservas hechas y anuladas este año, 
el código de casa reservada, la fecha de inicio de estancia y 
la duración de la misma. También queremos que se muestre el importe de la 
devolución en aquellas que hayan producido dicha devolución.
*/
select reservas.codreserva, reservas.codcasa, reservas.feciniestancia, 
	date_add(reservas.feciniestancia, interval reservas.numdiasestancia day),
	reservas.numdiasestancia, 
	ifnull(devoluciones.importedevol, 0)
from reservas left  join devoluciones on reservas.codreserva = devoluciones.codreserva 
where year(reservas.fecreserva) = year(curdate()) and
	reservas.fecanulacion is not null;

/* 4. Queremos mostrar un listado de todas las casas de la zona 1 en el 
que se muestre el nombre de casa y el número de reservas que se han 
hecho para cada casa. Si una casa nunca se ha reservado, deberá aparecer en el listado.
*/
select casas.codcasa, casas.nomcasa, count(*), count(reservas.codreserva)
from reservas right join casas on reservas.codcasa = casas.codcasa join zonas 
	on casas.codzona = zonas.numzona
where zonas.numzona = 1
group by casas.codcasa;

/* 5. Queremos elaborar un listado de casas en el que se muestre el nombre 
de zona y el nombre de la casa. Ten en cuenta que de algunas zonas 
no tenemos todavía ninguna casa en el sistema, queremos que se muestren 
estas zonas también. */
select zonas.nomzona, casas.nomcasa
from zonas left join casas on zonas.numzona = casas.codzona
order by zonas.nomzona;

/*
Para la base de datos Promociones:
*/
use ventapromoscompleta;

/* 6. Queremos mostrar un listado de productos organizados por categorías y 
el número de unidades vendidas. Ten en cuenta que algunos productos 
no se han vendido, en cuyo caso el número de unidades vendidas se mostrará como null.*/
select categorias.nomcat, articulos.nomart, ifnull(sum(detalleventa.cant), 0)
from  categorias join articulos on categorias.codcat = articulos.codcat
	 left join detalleventa on articulos.refart = detalleventa.refart
group by articulos.refart
order by categorias.nomcat;

/* 7. Dada una promoción determinada, queremos que se muestre el número 
de productos que hay en cada categoría incluidos en dicha promoción. 
Ten en cuenta que hay algunas promociones que no incluyen productos 
de todas las categorías, en cuyo caso debe aparecer la categoría 
y el número de productos como null.
*/
select categorias.nomcat, count(articulos.refart)
from categorias left join articulos on categorias.codcat = articulos.codcat
group by nomcat;

select categorias.nomcat, catalogospromos.codpromo, count(articulos.refart) as 'Núm artículos de categoría', count(catalogospromos.refart) as 'Núm artic. incluidos en promoción'
from categorias left join articulos on categorias.codcat = articulos.codcat
	left join catalogospromos on catalogospromos.refart = articulos.refart
where catalogospromos.codpromo = 1
group by categorias.nomcat, catalogospromos.codpromo
order by categorias.nomcat;
 
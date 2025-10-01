select
 p.nombre as nombre_procurador,
 count(ap.numero_expediente) as cantidad_asuntos
 from
  procuradores p
join 
 asuntos_procuradores ap on p.id_procurador = ap.id_procurador
group by
 p.nombre
order by
 cantidad_asuntos desc, p.nombre;
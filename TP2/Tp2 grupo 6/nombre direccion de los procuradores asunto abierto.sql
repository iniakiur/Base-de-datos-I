select
 p.nombre,
 p.direccion
from Procuradores P 
join 
 Asuntos_procuradores ap on p.id_procurador= ap.id_procurador
join 
 asuntos a on ap.numero_expediente =a.numero_expediente
where
 a.estado='abierto';

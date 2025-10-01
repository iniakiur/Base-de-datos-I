select distinct
 c.nombre as clientes,
 c.dni,
 a.numero_expediente
from
 Clientes c
 JOIN
    Asuntos A ON C.dni = A.dni_cliente
join
 asuntos_procuradores ap on a.numero_expediente = ap.numero_expediente
join 
 procuradores p on ap.id_procurador = p.id_procurador
where
 p.nombre ='Carlos Lopez';
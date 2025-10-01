select
 a.numero_expediente,
 a.fecha_inicio
from
 asuntos a
join 
 clientes c  on a.dni_cliente=c.dni
where
 c.direccion like '%buenos aires%';
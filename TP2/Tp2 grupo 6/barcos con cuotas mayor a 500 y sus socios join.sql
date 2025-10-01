select
 b.nombre as nombre_barco,
 b.cuota,
 s.nombre as nombre_socio
from
 barcos b
join
 socios s on b.id_socio = s.id_socio
where
 b.cuota >500.00;
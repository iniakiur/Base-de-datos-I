select 
 b.nombre as nombre_barco,
 b.cuota,
 (select 
  s.nombre
from 
 socios s
where 
 s.id_socio=b.id_socio)
 as nombre_socio
 from 
  barcos b
  where
   b.cuota>500.00;
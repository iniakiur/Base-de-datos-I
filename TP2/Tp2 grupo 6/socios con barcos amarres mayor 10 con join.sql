select 
 s.nombre
from
 socios s 
join
 barcos b on s.id_socio =b.id_socio
where
 b.numero_amarre>10;
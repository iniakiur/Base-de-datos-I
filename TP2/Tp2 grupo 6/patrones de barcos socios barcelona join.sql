select
 s.patron_nombre,
 s.patron_direccion
from
 salidas s 
join
 barcos b on s.matricula =b.matricula
join
 socios so on b.id_socio = so.id_socio
where
 so.direccion like '%barcelona%';
select 
 b.nombre as barco
from
 barcos b
join
 salidas s on b.matricula =s.matricula
where
 s.destino ='mallorca';
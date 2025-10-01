select 
 nombre
from
 barcos
where 
 matricula in (
         select
          matricula
		from
         salidas
         where
         destino='mallorca'
);
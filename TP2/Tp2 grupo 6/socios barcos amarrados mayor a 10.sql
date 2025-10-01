select 
  nombre
from 
  socios
where
  id_socio in (
       select
         id_socio
	   from
         barcos
	   where
        numero_amarre>10
	);

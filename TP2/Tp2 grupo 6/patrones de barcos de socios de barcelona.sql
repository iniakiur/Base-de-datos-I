select 
  patron_nombre,
  patron_direccion
from
  salidas
where
  matricula in (
      select
        matricula
	  from
        barcos
	  where
        id_socio in (
           select
             id_socio
		   from
              socios
			where
              direccion like '%barcelona%'
              )
);
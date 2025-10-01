select nombre, cuota
from barcos
where id_socio =(
    select id_socio
    from Socios
    where nombre = 'Juan Perez'
);
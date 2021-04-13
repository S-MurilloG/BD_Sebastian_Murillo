
-- BD SAKILA 
--
-- Sebastián Murillo, 12 abril 2021


/*
 * 1. En formato human-readable, ¿cuál es el promedio de tiempo entre cada pago por cliente?
 */

-- Creación de la vista prom_t_pagos	(Promedio de tiempo de pagos por cliente)
create view prom_t_pagos as (
	with pf as ( 
		select p1.payment_id p_id, p1.payment_date fecha from payment p1 
		where p1.payment_id > 1
		order by p1.customer_id 
	),
	pp as ( 
		select avg(age(pf.fecha, p2.payment_date)) tiempo, p2.customer_id c_id from payment p2
		join pf on (p2.payment_id = pf.p_id-1)
		where age(pf.fecha,p2.payment_date) > '00:00'::interval 
		group by p2.customer_id
	)
	select c.customer_id cus_id_p, concat(c.first_name,' ',c.last_name) "Nombre", extract('day' from pp.tiempo) dias_prom from payment p3
	join pp on (p3.customer_id = pp.c_id)
	join customer c using (customer_id)
	group by c.customer_id, dias_prom
	order by c.customer_id
);

-- Visualización de la vista prom_t_pagos
select * from prom_t_pagos pp;

-- Dropeo de la vista prom_t_pagos
drop view prom_t_pagos;


/*
 * 2. ¿Sigue una distribución normal?
 */

select * from histogram('prom_t_pagos', 'dias_prom');
-- Al correr este querie podemos observar que el promedio de tiempo de pago entre cada cliente
-- no sigue una distribución normal.


/*
 * 3. ¿Qué tanto difiere ese promedio del tiempo entre rentas por cliente?
 */

-- Creación de secuencias que ayudan al querie
create sequence seq_1 minvalue 0 maxvalue 100000 increment by 1;	
create sequence seq_2 minvalue 1 maxvalue 100000 increment by 1;

-- Querie
with fi as ( 
	select nextval('seq_1') seq_fi, r1.rental_id, r1.rental_date fecha_i, r1.customer_id fi_cus_id from rental r1
	order by r1.customer_id, fecha_i
),
ff as ( 
	select nextval('seq_2') seq_ff, r2.rental_id, r2.rental_date fecha_f, r2.customer_id from rental r2
	where r2.rental_id <> 76
	order by r2.customer_id, fecha_f 
),
rp as(
	select avg(age(fi.fecha_i, ff.fecha_f)) tiempo, fi.fi_cus_id c_id_r from fi
	join ff on (ff.seq_ff = fi.seq_fi-1)
	where age(fi.fecha_i,ff.fecha_f) > '00:00'::interval 
	group by c_id_r
),
prom_r as ( 
	select rp.c_id_r cus_id_r, rp.tiempo dias_prom_r from rp
	group by cus_id_r, dias_prom_r
),
pf as ( 
	select p1.payment_id p_id, p1.payment_date fecha from payment p1 
	where p1.payment_id > 1
),
pp as ( 
	select avg(age(pf.fecha, p2.payment_date)) tiempo, p2.customer_id c_id_p from payment p2
	join pf on (p2.payment_id = pf.p_id-1)
	where age(pf.fecha,p2.payment_date) > '00:00'::interval 
	group by c_id_p
),
prom_p as (
	select pp.c_id_p cus_id_p, pp.tiempo dias_prom_p from  pp
	group by cus_id_p, dias_prom_p
)
select c.customer_id, concat(c.first_name,' ',c.last_name) "Nombre", extract('hour' from (prom_r.dias_prom_r - prom_p.dias_prom_p)) dif_horas from customer c
join prom_r on (c.customer_id = prom_r.cus_id_r)
join prom_p on (c.customer_id = prom_p.cus_id_p)
order by c.customer_id ;

-- Dropeo de las secuencias utilizadas en el querie
drop sequence seq_1, seq_2;






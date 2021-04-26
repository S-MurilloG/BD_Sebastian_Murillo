
-- BD NORTHWIND 
--
-- Sebastián Murillo, 23 abril 2021

/*
 * Promedio mensual de la diferencia de los valores de los pagos de sus órdenes para cada cliente
 * para conocer su comportamiento de los montos pagados en relación con el tiempo.
 */
with dif_pagos as (
	select t.cus_0, (t.precio_0 - t.precio_1) dif_precio
	from (
		select o.customer_id cus_0, o.order_date date_0, sum(od.unit_price*od.quantity) precio_0,
		lag(o.customer_id) over w cus_1, lag(o.order_date) over w date_1, lag(sum(od.unit_price*od.quantity)) over w precio_1
		from order_details od join orders o using (order_id)
		group by o.order_id
		window w as (order by o.customer_id, o.order_date)
	) t where (t.cus_0 = t.cus_1)
)
select dp.cus_0 "ID Customer" , avg(dp.dif_precio) "Promedio", count(dp.cus_0) "No. Pagos" from dif_pagos dp
group by dp.cus_0;
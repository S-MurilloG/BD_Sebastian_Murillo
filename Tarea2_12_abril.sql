
-- BD NORTHWIND 
--
-- Sebastián Murillo, 12 abril 2021

------------------------------------- Cálculos generales -------------------------------------------------------------

/*
 * 1. Número de películas que caben en un cilindro basándonos en su peso
 */
select (50000/500) num_peli_x_cilindro;


/*
 * 2. Cálculo del apotema del icoságono
 */
select concat(ceiling(8/(2*tand(18/2))),' ','cm') apotema_icosagono;

/*
 * 3. Cálculo del radio del cilindro exterior
 */
with a as(
	select ceiling(8/(2*tand(18/2))) as apotema_icosagono
)
select concat(ceiling(a.apotema_icosagono+22.5),' ','cm') radio_exterior from a;


-------- Por nivel
/*
 * 4. Altura de un nivel
 */
select concat(30,' ','cm') altura;

/*
 * 5. Cálculo del volumen (en cm cúbicos) del cilindro por nivel
 */
with vol as( 
	select ((pi() * power(49,2) * 30)-(pi() * power(26,2) * 30))::numeric cil
)
select concat(round(vol.cil,2),' ','cm cúbicos') volumen_cil_x_nivel from vol;

/*
 * 6. Dimensión (en cm cúbicos) del total de las películas en un nivel
 */
select concat(5040*20,' ','cm cúbicos') volumen_peli_x_nivel;

/*
 * 7. Desperdicio de espacio (en cm cúbicos) por nivel
 */
with d as (
	select ((pi() * power(49,2) * 30)-(pi() * power(26,2) * 30) - 5040*20)::numeric vol
)
select concat(round(d.vol,2),' ','cm cúbicos') vol_desperdiciado_nivel from d;


-------- En el cilindro general
/*
 * 8. Cálculo de la altura del cilindro
 */
select concat(30*5,' ','cm') altura;

/*
 * 9. Cálculo del volumen (en cm cúbicos) del cilindro
 */
with cil as (
	select (((pi() * power(49,2) * 30)-(pi() * power(26,2) * 30)) * 5)::numeric vol
)
select concat(round(cil.vol,2),' ','cm cúbicos') vol_cilindro_total from cil;

/*
 * 10. Dimensión (en cm cúbicos) del total de las películas en el cilindro
 */
select concat(5040*100,' ','cm cúbicos') vol_peli_total;

/*
 * 11. Desperdicio de espacio (en cm cúbicos) por nivel
 */
with des as (
	select ((((pi() * power(49,2) * 30)-(pi() * power(26,2) * 30)) * 5 ) - 5040*100)::numeric vol
)
select concat(round(des.vol,2),' ','cm cúbicos') vol_desperdiciado_total from des;

/*
 * 12. Desperdicio de espacio (en porcentaje) por nivel
 */
with p as (
	select (((((pi() * power(49,2) * 30)-(pi() * power(26,2) * 30)) * 5 ) - 5040*100)*100/(((pi() * power(49,2) * 30)-(pi() * power(26,2) * 30)) * 5))::numeric por
)
select concat(round(p.por,2),' ','%') vol_desperdiciado_total from p;



---------------------- Datos sobre los cilindros solicitados y las stores --------------------------------------------

/*
 * 13. Número de películas que tiene cada store en su inventario.
 */
select i.store_id, count(i.inventory_id) cant_peli_x_store from inventory i 
group by i.store_id;

/*
 * 14. Número de cilindros necesarios por store basándonos en su peso
 */
select i.store_id, ceil(count(i.inventory_id)::decimal/(50000/500)) num_cil_x_store from inventory i 
group by i.store_id;

/*
 * 15. Número de slots vacíos que tendría el último cilindro por store
 */
select i.store_id, (ceil(count(i.inventory_id)::decimal/(50000/500))*100)-ceil(count(i.inventory_id)) num_slots_vacios 
from inventory i 
group by i.store_id;




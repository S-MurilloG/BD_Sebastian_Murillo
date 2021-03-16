-- BD SAKILA 
--
-- Sebastián Murillo, 15 marzo 2021

/*
 * 1. ¿Cómo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campaña?
 */
select concat(c.first_name,' ',c.last_name), c.email  from customer c 
join address a using (address_id)
join city c2 using (city_id)
where c2.country_id = 20;

/*
 * 2. ¿Qué cliente ha rentado más de nuestra sección de adultos?
 */
select concat(c.first_name,' ',c.last_name), count(f.film_id)  from customer c 
join rental r using (customer_id)
join inventory i using (inventory_id)
join film f using (film_id)
where f.rating = 'NC-17'
group by c.customer_id 
order by count(f.film_id) desc limit 2;

/*
 * 3.a ¿Qué películas son las más rentadas en todas nuestras stores?
 */
select f.title, count(i.film_id) as "Num. rentas" from rental r 
join inventory i using (inventory_id)
join film f using (film_id)
group by f.film_id 
order by "Num. rentas" desc limit 5;

/*
 * 3.b ¿Qué películas son las más rentadas por tienda?
 */
select i.store_id, f.title , count(i.film_id) as "Num. rentas" from rental r 
join inventory i using (inventory_id)
join film f using (film_id)
group by f.film_id, i.store_id 
order by "Num. rentas" desc limit 2;

/*
 * 4. ¿Cuál es nuestro revenue por store?
 */
select i.store_id, sum(p.amount) as "Revenue" from payment p 
join rental r using (rental_id)
join inventory i using (inventory_id)
group by i.store_id
order by i.store_id;

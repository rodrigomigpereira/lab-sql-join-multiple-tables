##  Lab | SQL Joins on multiple tables.
## In this lab, you will be using the Sakila database of movie rentals.

use sakila; ## Use the database sakila 

## Instructions
## Write a query to display for each store its store ID, city, and country.

select * from store; ## columns --- store_id, manager_staff_id, address_id, last_update
select * from address; ## columns ---- address_id, address, address2, district, city_id, postal_code, phone, location, last_update
select * from city; ## columns --- city_id, city, country_id, last_update
select * from country; ## columns --- country_id, country, last_update

select s.store_ID, ci.city, co.country
	from store s
		join address a
		on s.address_id = a.address_id
			join city ci
            on a.city_id = ci.city_id
				join country co
                on ci.country_id = co.country_id;                

## Write a query to display how much business, in dollars, each store brought in.

select * from store; ## columns --- store_id, manager_staff_id, address_id, last_update
select * from customer; ## columns --- customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update
select * from payment; ## columns --- payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update

select c.store_ID, SUM(p.amount) as dollars_each_store_brought
	from customer c
		join payment p
        on c.customer_id = p.customer_id
			group by c.store_id
				order by dollars_each_store_brought desc;
            
## What is the average running time of films by category?

select * from film; ## columns --- film_id, title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update
select * from film_category; ## columns ---  film_id, category_id, last_update
select * from category; ## columns --- category_id, name, last_update

select c.category_id, c.name, avg(f.length) as average_running_time_of_films
	from film f
		join film_category fc
        on f.film_id = fc.film_id
			join category c
            on fc.category_id = c.category_id
				group by c.category_id
					order by average_running_time_of_films desc;

## Which film categories are longest?

select c.category_id, c.name, avg(f.length) as average_running_time_of_films
	from film f
		join film_category fc
        on f.film_id = fc.film_id
			join category c
            on fc.category_id = c.category_id
				group by c.category_id
					order by average_running_time_of_films desc
						limit 1;

## Display the most frequently rented movies in descending order.

select * from customer; ## columns --- customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update
select * from film; ## columns --- film_id, title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update
select * from inventory; ## columns --- inventory_id, film_id, store_id, last_update
select * from rental; ## columns --- rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update 
select * from payment;  ## columns --- payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update

select f.film_id, f.title, COUNT(p.payment_id) as number_times_rented
	from film f
		join inventory i
        on f.film_id = i.film_id
			join rental r
            on i.inventory_id = r.inventory_id
				join payment p
                on r.rental_id = p.rental_id
					group by f.film_id
						order by number_times_rented desc;

## List the top five genres in gross revenue in descending order.

select * from film_category; ## columns ---  film_id, category_id, last_update
select * from category; ## columns --- category_id, name, last_update
select * from inventory; ## columns --- inventory_id, film_id, store_id, last_update
select * from rental; ## columns --- rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update 
select * from payment;  ## columns --- payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update

select fc.category_id, c.name as category_name, sum(p.amount) as total_revenue
	from film_category fc
		join category c
		on fc.category_id = c.category_id
			join inventory i
			on fc.film_id = i.film_id
				join rental r
                on i.inventory_id = r.inventory_id
					join payment p
                    on r.rental_id = p.rental_id
						group by fc.category_id
							order by total_revenue desc
								limit 5;
        
## Is "Academy Dinosaur" available for rent from Store 1?

select * from film; ## columns --- film_id, title, description, release_year, language_id, original_language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features, last_update
select * from inventory;  ## columns --- inventory_id, film_id, store_id, last_update

select f.title, i.inventory_id, i.store_id
	from film f
		join inventory i
		on f.film_id = i.film_id
			where title = "Academy Dinosaur";  ## I can see that the title "Academy Dinosaur" is avaiable for rent from both Store 1 and Store 2 

	## Find below an alternative solution for the same exercise:

SELECT CASE
           WHEN i.inventory_id IS NULL THEN 'Not Available'
           ELSE 'Available'
       END AS availability
FROM inventory i
JOIN film f ON i.film_id = f.film_id
WHERE f.title = 'Academy Dinosaur' AND i.store_id = 2
AND i.inventory_id NOT IN (
    SELECT r.inventory_id
    FROM rental r
    WHERE r.return_date IS NULL
)
LIMIT 1;
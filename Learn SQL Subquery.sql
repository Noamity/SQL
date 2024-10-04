##BELOW ARE QUESTION AND ANSWER OF UDEMY ELEARNING
LEARN SQL SUBQUERY

##SECTION 13
##Which films have not been rented by any customers?

SELECT film.film_id, film.title

FROM film

WHERE NOT EXISTS

    (SELECT *

     FROM rental

     JOIN inventory ON rental.inventory_id = inventory.inventory_id

     WHERE inventory.film_id = film.film_id);
	 
	 
	 
 ##Which cities have not had any rentals?
 
 SELECT city.city_id, city.city

FROM city

WHERE NOT EXISTS

    (SELECT *

     FROM address

     JOIN store ON address.address_id = store.address_id

     JOIN inventory ON store.store_id = inventory.store_id

     JOIN rental ON inventory.inventory_id = rental.inventory_id

     WHERE address.city_id = city.city_id);
	 
	 
	 
	 
	 ##What is the list of cities that have no active rentals at any stores within the city, in the Sakila database?
	 
	 SELECT city.city_id, city.city

FROM city

WHERE NOT EXISTS

    (SELECT *

     FROM address

     JOIN store ON address.address_id = store.address_id

     JOIN customer ON customer.store_id = store.store_id

     JOIN rental ON customer.customer_id = rental.customer_id

     WHERE address.city_id = city.city_id);
	 
	 
	 
	 
	 
	 What are the top 5 most popular actors in terms of the number of movies they have appeared in?
	 
	 
	 SELECT actor.actor_id, actor.first_name, actor.last_name,

       (SELECT COUNT(*) FROM film_actor WHERE film_actor.actor_id = actor.actor_id) AS movie_count

FROM actor

ORDER BY movie_count DESC

LIMIT 5;


What is the total number of rentals for each customer, sorted by the number of rentals in descending order?
	 
	 SELECT customer.customer_id, customer.first_name, customer.last_name,

       (SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id) AS rental_count

FROM customer

ORDER BY rental_count DESC;




What are the top 5 most frequently rented movies, along with the number of rentals?

SELECT film.film_id, film.title,

       (SELECT COUNT(*) FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id

                        WHERE inventory.film_id = film.film_id) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 5;


Get the name of the customer who has rented the most number of films in the past month, and the rental count:

SELECT

  CONCAT(first_name, ' ', last_name) AS Customer,

  COUNT(rental.rental_id) AS Rentals

FROM

  customer

INNER JOIN rental ON customer.customer_id = rental.customer_id

WHERE

  rental.rental_date BETWEEN (

    SELECT DATE(MAX(rental_date) - INTERVAL 30 DAY) FROM rental

  ) AND (

    SELECT MAX(rental_date) FROM rental

  )

GROUP BY

  Customer

ORDER BY

  Rentals DESC

LIMIT 1;


Get the name of the category that has the highest total rental revenue, and the revenue amount:

SELECT name, (

    SELECT SUM(amount)

    FROM payment

    JOIN rental ON payment.rental_id = rental.rental_id

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN film_category ON inventory.film_id = film_category.film_id

    JOIN category ON film_category.category_id = category.category_id

    WHERE category.category_id = c.category_id

) AS total_revenue

FROM category c

ORDER BY total_revenue DESC

LIMIT 1;


Get the name of the customer who has paid the most in late fees, and the total late fee amount:

SELECT CONCAT(first_name, ' ', last_name) AS customer_name, (

    SELECT SUM(amount)

    FROM payment

    JOIN rental ON payment.rental_id = rental.rental_id

    JOIN customer ON rental.customer_id = customer.customer_id

    WHERE customer.customer_id = c.customer_id AND payment.amount < 0

) AS total_late_fees

FROM customer c

ORDER BY total_late_fees DESC

LIMIT 1;


Get the name of the actor who has appeared in the most number of films that are part of a series, and the film count:

SELECT CONCAT(first_name, ' ', last_name) AS actor_name, COUNT(*) AS film_count

FROM actor a

JOIN film_actor fa ON a.actor_id = fa.actor_id

JOIN film f ON fa.film_id = f.film_id

WHERE f.rating = 'PG-13'

GROUP BY a.actor_id

ORDER BY film_count DESC

LIMIT 1;

Get the name of the actor who has appeared in the most number of films that were rented on a Sunday, and the film count:

SELECT CONCAT(first_name, ' ', last_name) AS actor_name, COUNT(*) AS film_count

FROM actor a

JOIN film_actor fa ON a.actor_id = fa.actor_id

JOIN inventory i ON fa.film_id = i.film_id

JOIN rental r ON i.inventory_id = r.inventory_id

WHERE WEEKDAY(rental_date) = 6

GROUP BY a.actor_id

ORDER BY film_count DESC

LIMIT 1;



Get the name of the customer who has the highest total payment amount, and the amount:


SELECT CONCAT(first_name, ' ', last_name) AS customer_name, SUM(amount) AS total_payment_amount

FROM customer c

JOIN payment p ON c.customer_id = p.customer_id

GROUP BY c.customer_id

ORDER BY total_payment_amount DESC

LIMIT 1;



What is the total number of rentals for each customer, sorted by the number of rentals in descending order?

SELECT customer.customer_id, customer.first_name, customer.last_name,

       (SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id) AS rental_count

FROM customer

ORDER BY rental_count DESC;


What are the top 5 most frequently rented movies, along with the number of rentals?

SELECT film.film_id, film.title,

       (SELECT COUNT(*) FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id

                        WHERE inventory.film_id = film.film_id) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 5;


Get the names of the customers who have the highest total payment amount, and their payment amounts:


SELECT CONCAT(first_name, ' ', last_name) AS customer_name, (

    SELECT SUM(amount)

    FROM payment

    WHERE customer.customer_id = payment.customer_id

) AS total_payments

FROM customer

ORDER BY total_payments DESC

LIMIT 1;


Get the names of the customers who have rented the most number of movies, and the movie counts for each customer:

SELECT CONCAT(first_name, ' ', last_name) AS customer_name, (

    SELECT COUNT(*)

    FROM rental

    WHERE customer.customer_id = rental.customer_id

) AS movie_count

FROM customer

ORDER BY movie_count DESC

LIMIT 1;


Get the names of the films that have the most number of rentals, and the rental counts for each film:

SELECT title, (

    SELECT COUNT(*)

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 1;


Get the name of the actor who has appeared in the most number of films, and the film count:


SELECT

    actor_name,

    film_count

FROM (

    SELECT

        CONCAT(first_name, ' ', last_name) AS actor_name,

        COUNT(title) AS film_count

    FROM

        actor

    INNER JOIN

        film_actor USING(actor_id)

    INNER JOIN

        film USING(film_id)

    GROUP BY

        actor_name

) AS subquery

ORDER BY

    film_count DESC

LIMIT 1;


Get the email address of the staff member who has the highest number of rentals, and the rental count:


SELECT email, (

    SELECT COUNT(*)

    FROM rental

    WHERE staff.staff_id = rental.staff_id

) AS rental_count

FROM staff

ORDER BY rental_count DESC

LIMIT 1;


##Section 15


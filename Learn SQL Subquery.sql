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
	 
	 
	 
	 
	 
	## What are the top 5 most popular actors in terms of the number of movies they have appeared in?
	 
	 
	 SELECT actor.actor_id, actor.first_name, actor.last_name,

       (SELECT COUNT(*) FROM film_actor WHERE film_actor.actor_id = actor.actor_id) AS movie_count

FROM actor

ORDER BY movie_count DESC

LIMIT 5;


##What is the total number of rentals for each customer, sorted by the number of rentals in descending order?
	 
	 SELECT customer.customer_id, customer.first_name, customer.last_name,

       (SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id) AS rental_count

FROM customer

ORDER BY rental_count DESC;




##What are the top 5 most frequently rented movies, along with the number of rentals?

SELECT film.film_id, film.title,

       (SELECT COUNT(*) FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id

                        WHERE inventory.film_id = film.film_id) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 5;


##Get the name of the customer who has rented the most number of films in the past month, and the rental count:

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


##Get the name of the category that has the highest total rental revenue, and the revenue amount:

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


##Get the name of the customer who has paid the most in late fees, and the total late fee amount:

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


##Get the name of the actor who has appeared in the most number of films that are part of a series, and the film count:

SELECT CONCAT(first_name, ' ', last_name) AS actor_name, COUNT(*) AS film_count

FROM actor a

JOIN film_actor fa ON a.actor_id = fa.actor_id

JOIN film f ON fa.film_id = f.film_id

WHERE f.rating = 'PG-13'

GROUP BY a.actor_id

ORDER BY film_count DESC

LIMIT 1;

##Get the name of the actor who has appeared in the most number of films that were rented on a Sunday, and the film count:

SELECT CONCAT(first_name, ' ', last_name) AS actor_name, COUNT(*) AS film_count

FROM actor a

JOIN film_actor fa ON a.actor_id = fa.actor_id

JOIN inventory i ON fa.film_id = i.film_id

JOIN rental r ON i.inventory_id = r.inventory_id

WHERE WEEKDAY(rental_date) = 6

GROUP BY a.actor_id

ORDER BY film_count DESC

LIMIT 1;



##Get the name of the customer who has the highest total payment amount, and the amount:


SELECT CONCAT(first_name, ' ', last_name) AS customer_name, SUM(amount) AS total_payment_amount

FROM customer c

JOIN payment p ON c.customer_id = p.customer_id

GROUP BY c.customer_id

ORDER BY total_payment_amount DESC

LIMIT 1;



##What is the total number of rentals for each customer, sorted by the number of rentals in descending order?

SELECT customer.customer_id, customer.first_name, customer.last_name,

       (SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id) AS rental_count

FROM customer

ORDER BY rental_count DESC;


##What are the top 5 most frequently rented movies, along with the number of rentals?

SELECT film.film_id, film.title,

       (SELECT COUNT(*) FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id

                        WHERE inventory.film_id = film.film_id) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 5;


##Get the names of the customers who have the highest total payment amount, and their payment amounts:


SELECT CONCAT(first_name, ' ', last_name) AS customer_name, (

    SELECT SUM(amount)

    FROM payment

    WHERE customer.customer_id = payment.customer_id

) AS total_payments

FROM customer

ORDER BY total_payments DESC

LIMIT 1;


##Get the names of the customers who have rented the most number of movies, and the movie counts for each customer:

SELECT CONCAT(first_name, ' ', last_name) AS customer_name, (

    SELECT COUNT(*)

    FROM rental

    WHERE customer.customer_id = rental.customer_id

) AS movie_count

FROM customer

ORDER BY movie_count DESC

LIMIT 1;


##Get the names of the films that have the most number of rentals, and the rental counts for each film:

SELECT title, (

    SELECT COUNT(*)

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 1;


##Get the name of the actor who has appeared in the most number of films, and the film count:


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


##Get the email address of the staff member who has the highest number of rentals, and the rental count:


SELECT email, (

    SELECT COUNT(*)

    FROM rental

    WHERE staff.staff_id = rental.staff_id

) AS rental_count

FROM staff

ORDER BY rental_count DESC

LIMIT 1;


##Section 15

## Get the name of the actor who has appeared in the most number of films in the "Action" category, and the film count:

SELECT

    CONCAT(first_name, ' ', last_name) AS actor_name,

    (

        SELECT

            COUNT(*)

        FROM

            film_actor fa

        JOIN

            film_category fc ON fa.film_id = fc.film_id

        JOIN

            category c ON fc.category_id = c.category_id

        WHERE

            c.name = 'Action'

            AND fa.actor_id = actor.actor_id

    ) AS film_count,

    'Action' AS category_name

FROM

    actor

ORDER BY

    film_count DESC

LIMIT 1;


## Get the title of the film that has the highest average rental duration, and the average duration in days:


SELECT title, (

    SELECT AVG(DATEDIFF(return_date, rental_date))

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS avg_duration_days

FROM film

ORDER BY avg_duration_days DESC

LIMIT 1;



## Get the title of the film that has the highest number of rentals, and the rental count:

SELECT title, (

    SELECT COUNT(*)

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 1;


## Which films have been rented the least number of times, and how many times have they been rented?

SELECT film.title,

       (SELECT COUNT(*)

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.film_id = film.film_id) AS rental_count

FROM film

ORDER BY rental_count ASC

LIMIT 10;


Get the first and last name of the staff member who has the highest number of rentals in the past week, and the rental count:

-- Step 1: Determine the latest rental date in the dataset

SET @latest_rental_date = (SELECT MAX(rental_date) FROM rental);

-- Step 2: Get the staff member with the highest number of rentals in the past week based on the latest rental date

SELECT

    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,

    COUNT(r.rental_id) AS rental_count

FROM

    staff s

JOIN

    rental r ON s.staff_id = r.staff_id

WHERE

    r.rental_date > DATE_SUB(@latest_rental_date, INTERVAL 1 WEEK)

GROUP BY

    s.staff_id

ORDER BY

    rental_count DESC

LIMIT 1;


## Get the name of the actor who has the highest average rating in the "Comedy" category, and the average rating:

SELECT

    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,

    'Comedy' AS category,

    AVG(f.rental_rate) AS avg_rental_rate

FROM

    actor a

JOIN

    film_actor fa ON a.actor_id = fa.actor_id

JOIN

    film f ON fa.film_id = f.film_id

JOIN

    film_category fc ON f.film_id = fc.film_id

JOIN

    category c ON fc.category_id = c.category_id

WHERE

    c.name = 'Comedy'

GROUP BY

    a.actor_id

ORDER BY

    avg_rental_rate DESC

LIMIT 1;


## Get the title of the film that has the highest total rental revenue, and the revenue amount:

SELECT title, (

    SELECT SUM(amount)

    FROM payment

    JOIN rental ON payment.rental_id = rental.rental_id

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS total_revenue

FROM film

ORDER BY total_revenue DESC

LIMIT 1;


## Get the email address of the staff member who has rented the most number of films in the "Horror" category, and the rental count:

SELECT email, (

    SELECT COUNT(*)

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN film ON inventory.film_id = film.film_id

    JOIN film_category ON film.film_id = film_category.film_id

    JOIN category ON film_category.category_id = category.category_id

    WHERE category.name = 'Horror' AND staff.staff_id = rental.staff_id

) AS rental_count

FROM staff

ORDER BY rental_count DESC

LIMIT 1;



## Get the name of the actor who has appeared in the most number of films in the "Drama" category, and the film count:

SELECT CONCAT(first_name, ' ', last_name) AS actor_name, (

    SELECT COUNT(*)

    FROM film_category

    JOIN film_actor ON film_category.film_id = film_actor.film_id

    JOIN actor ON film_actor.actor_id = actor.actor_id

    JOIN category ON film_category.category_id = category.category_id

    WHERE category.name = 'Drama' AND actor.actor_id = film_actor.actor_id

) AS film_count

FROM actor

ORDER BY film_count DESC

LIMIT 1;


## Get the title of the film with the highest average rating, and the average rating:

SELECT title, (

    SELECT AVG(rating)

    FROM film

    JOIN inventory ON film.film_id = inventory.film_id

    JOIN rental ON inventory.inventory_id = rental.inventory_id

    JOIN customer ON rental.customer_id = customer.customer_id

    JOIN address ON customer.address_id = address.address_id

    WHERE film.film_id = inventory.film_id

) AS avg_rating

FROM film

ORDER BY avg_rating DESC

LIMIT 1;



Section 16

##What are the top 5 most popular actors in terms of the number of movies they have appeared in?


SELECT actor.actor_id, actor.first_name, actor.last_name,

       (SELECT COUNT(*) FROM film_actor WHERE film_actor.actor_id = actor.actor_id) AS movie_count

FROM actor

ORDER BY movie_count DESC

LIMIT 5;


## What is the average rental duration for each customer, sorted by the average duration in ascending order?

SELECT customer.customer_id, customer.first_name, customer.last_name,

       (SELECT AVG(DATEDIFF(return_date, rental_date))

        FROM rental WHERE rental.customer_id = customer.customer_id) AS avg_rental_duration

FROM customer

ORDER BY avg_rental_duration;


## What is the total number of rentals for each customer who has rented a movie for more than 7 days?

SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       (SELECT COUNT(*)

        FROM rental

        WHERE customer_id = customer.customer_id AND DATEDIFF(return_date, rental_date) > 7) AS rental_count

FROM customer;


## Get the names of the actors who have appeared in movies released in the year 2006:

SELECT DISTINCT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN film ON film_actor.film_id = film.film_id

WHERE YEAR(film.release_year) = 2006;


## Which films have never been rented?

SELECT film.film_id, film.title

FROM film

WHERE NOT EXISTS

    (SELECT * FROM rental

     JOIN inventory ON rental.inventory_id = inventory.inventory_id

     WHERE inventory.film_id = film.film_id);
	 
	 
	 
## Which categories have more than 10 movies?
	 
 SELECT category.category_id, category.name, COUNT(*) AS movie_count

FROM category

JOIN film_category ON category.category_id = film_category.category_id

GROUP BY category.category_id

HAVING COUNT(*) > 10;


## What is the average number of rentals per customer for the customers who have rented more than 10 movies?

SELECT AVG(rental_count) AS avg_rentals_per_customer

FROM

    (SELECT customer_id, COUNT(*) AS rental_count

     FROM rental

     GROUP BY customer_id

     HAVING rental_count > 10) AS rental_counts;
	 
	 
	## What is the average rental rate for each category, sorted by the average rental rate in ascending order? 
	
	SELECT category.category_id, category.name,

       (SELECT AVG(rental_rate) FROM film

        WHERE film.film_id IN (

            SELECT film_id FROM film_category WHERE category_id = category.category_id

        )

       ) AS avg_rental_rate

FROM category

ORDER BY avg_rental_rate DESC;


## What are the top 5 customers with the most number of distinct movies rented?

SELECT customer.customer_id, customer.first_name, customer.last_name,

       (SELECT COUNT(DISTINCT inventory.film_id)

        FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE rental.customer_id = customer.customer_id) AS distinct_movie_count

FROM customer

ORDER BY distinct_movie_count DESC

LIMIT 5;

## What is the average rental duration for each combination of customer and store?

SELECT customer.customer_id, store.store_id,

       AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN store ON inventory.store_id = store.store_id

GROUP BY customer.customer_id, store.store_id;


Section 17

## Which films have been rented the most number of days, and how many days have they been rented for?

SELECT film.title,

       COALESCE(SUM(DATEDIFF(return_date, rental_date)), 0) AS rental_duration

FROM film

JOIN inventory ON film.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY inventory.film_id

ORDER BY rental_duration DESC

LIMIT 10;



## Get the titles of the movies that have not been rented in the past month:


SELECT title

FROM film

WHERE film_id NOT IN (

    SELECT DISTINCT inventory.film_id

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE rental_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)

);

## Get the names of the customers who have rented more than 10 movies in the past month, and the rental counts for each customer:

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       COUNT(*) AS rental_count

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

WHERE rental.rental_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)

GROUP BY rental.customer_id

HAVING rental_count > 10;


## Get the rental ids and dates for rentals made by the customer who has made the highest payment in total:

SELECT rental.rental_id, rental.rental_date

FROM rental

JOIN payment ON rental.rental_id = payment.rental_id

JOIN (

    SELECT payment.customer_id

    FROM payment

    GROUP BY payment.customer_id

    ORDER BY SUM(amount) DESC

    LIMIT 1

) AS top_customer ON payment.customer_id = top_customer.customer_id;


## Get the names of the films that have the longest duration, and their duration in hours:


SELECT title, length / 60 AS duration_hours

FROM film

WHERE length = (

    SELECT MAX(length)

    FROM film

);


##Get the names of the films that have the lowest rental rate, and their rental rate:

SELECT title, rental_rate

FROM film

WHERE rental_rate = (

    SELECT MIN(rental_rate)

    FROM film

);

Get the first and last name of the staff member who has the highest total payment amount, and their payment amount:

SELECT CONCAT(first_name, ' ', last_name) AS staff_name, (

    SELECT SUM(amount)

    FROM payment

    WHERE staff.staff_id = payment.staff_id

) AS total_payments

FROM staff

ORDER BY total_payments DESC

LIMIT 1;


## Get the title of the film with the highest replacement cost, and the replacement cost:


SELECT title, replacement_cost

FROM film

WHERE replacement_cost = (

    SELECT MAX(replacement_cost)

    FROM film

);

## Get the first and last name of the staff member who has the highest number of rentals, and the rental count:


SELECT CONCAT(first_name, ' ', last_name) AS staff_name, (

    SELECT COUNT(*)

    FROM rental

    WHERE staff.staff_id = rental.staff_id

) AS rental_count

FROM staff

ORDER BY rental_count DESC

LIMIT 1;


## What are the top 10 highest grossing films in the Sakila database?

SELECT film.title, (SELECT SUM(payment.amount)

                     FROM payment JOIN rental ON payment.rental_id = rental.rental_id

                                  JOIN inventory ON rental.inventory_id = inventory.inventory_id

                                  JOIN film ON inventory.film_id = film.film_id

                     WHERE film.film_id = inventory.film_id) AS gross

FROM film

ORDER BY gross DESC

LIMIT 10;













































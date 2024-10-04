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


Section 18 


## What is the total revenue for each store, sorted by the revenue in descending order?

SELECT store.store_id, CONCAT(address.address, ', ', city.city) AS location,

       (SELECT SUM(payment.amount)

        FROM payment JOIN rental ON payment.rental_id = rental.rental_id

                     JOIN inventory ON rental.inventory_id = inventory.inventory_id

                     JOIN store ON inventory.store_id = store.store_id

        WHERE store.store_id = inventory.store_id) AS revenue

FROM store JOIN address ON store.address_id = address.address_id

           JOIN city ON address.city_id = city.city_id

ORDER BY revenue DESC;



## What are the top 5 most rented movies in each category?


SELECT category.category_id, category.name, film.film_id, film.title, COUNT(*) AS rental_count

FROM rental

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

JOIN category ON film.film_id = category.category_id

GROUP BY category.category_id, film.film_id

ORDER BY category.category_id, rental_count DESC

LIMIT 5;


## Get the email address of the staff member who has the highest number of late rentals (rentals that were returned after their due date), and the number of late rentals:

SELECT email, (

    SELECT COUNT(*)

    FROM rental

    WHERE staff.staff_id = rental.staff_id AND return_date > rental.return_date

) AS late_rental_count

FROM staff

ORDER BY late_rental_count DESC

LIMIT 1;

## Get the first and last name of the customer who has rented the most number of films, and the rental count:


SELECT CONCAT(first_name, ' ', last_name) AS customer_name, (

    SELECT COUNT(*)

    FROM rental

    WHERE customer.customer_id = rental.customer_id

) AS rental_count

FROM customer

ORDER BY rental_count DESC

LIMIT 1;


## Get the email address of the staff member who has processed the most number of rentals in the past week, and the rental count:

SELECT email, (

    SELECT COUNT(*)

    FROM rental

    WHERE staff.staff_id = rental.staff_id AND rental_date > NOW() - INTERVAL 1 WEEK

) AS rental_count

FROM staff

ORDER BY rental_count DESC

LIMIT 1;

## Get the title of the film that has the highest total rental duration, and the duration in days:


SELECT title, (

    SELECT SUM(DATEDIFF(return_date, rental_date))

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS total_duration_days

FROM film

ORDER BY total_duration_days DESC

LIMIT 1;

## Get the title of the film that has the highest average rental rate, and the average rate:

SELECT title, AVG(rental_rate) AS avg_rate

FROM film

JOIN inventory ON film.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY film.film_id

ORDER BY avg_rate DESC

LIMIT 1;


## Get the name of the film that has the highest number of rentals, and the rental count:

SELECT title, (

    SELECT COUNT(*)

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 1;

## Get the name of the actor who has the highest total rental revenue for the films in which they have appeared, and the revenue amount:

SELECT CONCAT(first_name, ' ', last_name) AS actor_name, SUM(amount) AS total_revenue

FROM actor a

JOIN film_actor fa ON a.actor_id = fa.actor_id

JOIN inventory i ON fa.film_id = i.film_id

JOIN rental r ON i.inventory_id = r.inventory_id

JOIN payment p ON r.rental_id = p.rental_id

GROUP BY a.actor_id

ORDER BY total_revenue DESC

LIMIT 1;


## What is the total number of rentals for each staff member, sorted by the number of rentals in descending order?

SELECT staff.staff_id, staff.first_name, staff.last_name,

       (SELECT COUNT(*)

        FROM rental

        WHERE staff_id = staff.staff_id) AS rental_count

FROM staff

ORDER BY rental_count DESC;



## Section 19


## What is the average number of rentals per customer for each store?


SELECT store.store_id, CONCAT(address.address, ', ', city.city) AS location,

       (SELECT AVG(num_rentals)

        FROM (SELECT COUNT(*) AS num_rentals

              FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id

              WHERE inventory.store_id = store.store_id

              GROUP BY rental.customer_id) AS rental_counts) AS avg_rentals_per_customer

FROM store JOIN address ON store.address_id = address.address_id

           JOIN city ON address.city_id = city.city_id;
		   

## What are the top 10 highest-grossing films in the Sakila database? 

SELECT film.title, (SELECT SUM(payment.amount)

                     FROM payment JOIN rental ON payment.rental_id = rental.rental_id

                                  JOIN inventory ON rental.inventory_id = inventory.inventory_id

                                  JOIN film ON inventory.film_id = film.film_id

                     WHERE film.film_id = inventory.film_id) AS gross

FROM film

ORDER BY gross DESC

LIMIT 10;


## What is the average rental rate for each category, sorted by the average rental rate in ascending order?


SELECT category.category_id, category.name,

       (SELECT AVG(rental_rate) FROM film

        WHERE film.film_id IN (SELECT film_id FROM film_category WHERE category_id = category.category_id))

        AS avg_rental_rate

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


## What is the average length of rental for each film, sorted by the average length in ascending order?

SELECT film.film_id, film.title,

       (SELECT AVG(DATEDIFF(return_date, rental_date))

        FROM rental WHERE rental.inventory_id IN

            (SELECT inventory_id FROM inventory WHERE inventory.film_id = film.film_id)) AS avg_rental_length

FROM film

ORDER BY avg_rental_length;



## What is the average rental duration for each movie, sorted by the rental duration in descending order?

SELECT film.film_id, film.title,

       (SELECT AVG(DATEDIFF(return_date, rental_date))

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.film_id = film.film_id) AS avg_rental_duration

FROM film

ORDER BY avg_rental_duration DESC;


## What is the total number of rentals for each film, sorted by the number of rentals in descending order?

SELECT film.film_id, film.title,

       (SELECT COUNT(*)

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.film_id = film.film_id) AS rental_count

FROM film

ORDER BY rental_count DESC;


## What are the top 5 most rented movies by customers who have rented over 10 movies?

SELECT film.film_id, film.title, COUNT(*) AS rental_count

FROM rental

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

WHERE rental.customer_id IN

    (SELECT rental.customer_id

     FROM rental

     GROUP BY rental.customer_id

     HAVING COUNT(*) > 10)

GROUP BY film.film_id

ORDER BY rental_count DESC

LIMIT 5;




## What is the total number of rentals for each actor who has appeared in at least 40 movies?

SELECT actor.actor_id, actor.first_name, actor.last_name,

       (SELECT COUNT(*)

        FROM film_actor JOIN film ON film_actor.film_id = film.film_id

                       JOIN inventory ON film.film_id = inventory.film_id

                       JOIN rental ON inventory.inventory_id = rental.inventory_id

        WHERE film_actor.actor_id = actor.actor_id) AS rental_count

FROM actor

WHERE actor.actor_id IN

    (SELECT actor_id

     FROM film_actor

     GROUP BY actor_id

     HAVING COUNT(*) >= 40)

ORDER BY rental_count DESC;



## Which customers have rented more than one movie with the same title?


SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name

FROM customer

WHERE EXISTS

    (SELECT *

     FROM rental AS r1

     JOIN rental AS r2 ON r1.customer_id = r2.customer_id AND r1.inventory_id != r2.inventory_id

     JOIN inventory AS i1 ON r1.inventory_id = i1.inventory_id

     JOIN inventory AS i2 ON r2.inventory_id = i2.inventory_id AND i1.film_id = i2.film_id

     WHERE r1.customer_id = customer.customer_id);


	 
## SECTION 20

## What is the average rental duration for each movie, but only include movies that have been rented more than once?

SELECT film.film_id, film.title,

       (SELECT AVG(DATEDIFF(return_date, rental_date))

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.film_id = film.film_id

        HAVING COUNT(*) > 1) AS avg_rental_duration

FROM film;


## What is the total number of rentals for each film, but only include films that have been rented more than once?

SELECT film.film_id, film.title, COUNT(*) AS rental_count

FROM rental

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

GROUP BY film.film_id

HAVING rental_count > 1

ORDER BY rental_count DESC;


## What is the title of the movie with the longest rental duration? 


SELECT title

FROM film

WHERE film_id =

    (SELECT inventory.film_id

     FROM rental

     JOIN inventory ON rental.inventory_id = inventory.inventory_id

     ORDER BY DATEDIFF(return_date, rental_date) DESC

     LIMIT 1);
	 
	 
## Which customers have rented movies with a total duration of more than 100 days?

SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

GROUP BY customer.customer_id

HAVING SUM(DATEDIFF(return_date, rental_date)) > 100;


## What is the total number of rentals for each actor who has appeared in at least 10 movies?

SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(*) AS rental_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN inventory ON film_actor.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

WHERE actor.actor_id IN

    (SELECT actor_id

     FROM film_actor

     GROUP BY actor_id

     HAVING COUNT(*) >= 10)

GROUP BY actor.actor_id

ORDER BY rental_count DESC;




## Which customers have rented more than 5 movies with a rental duration of less than 3 days?


SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

WHERE DATEDIFF(return_date, rental_date) < 3

GROUP BY customer.customer_id

HAVING COUNT(*) > 5;

## Which actors have appeared in movies rented by the most customers?

SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(DISTINCT rental.customer_id) AS rental_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN inventory ON film_actor.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY actor.actor_id

ORDER BY rental_count DESC

LIMIT 10;


## What is the total number of rentals for each customer who has rented more than 10 movies?

SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, COUNT(*) AS rental_count

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

WHERE customer.customer_id IN

    (SELECT rental.customer_id

     FROM rental

     GROUP BY rental.customer_id

     HAVING COUNT(*) > 10)

GROUP BY customer.customer_id

ORDER BY rental_count DESC;



## Which films have been rented by the most customers?


SELECT film.film_id, film.title, COUNT(DISTINCT rental.customer_id) AS rental_count

FROM film

JOIN inventory ON film.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY film.film_id

ORDER BY rental_count DESC

LIMIT 10;



## What is the average rental duration for each film category?


SELECT category.name, AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration

FROM category

JOIN film_category ON category.category_id = film_category.category_id

JOIN inventory ON film_category.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY category.name;



## Section 21

## Get the titles of the top 5 movies that have been rented the longest, and their rental durations, using a CTE to compute the rental durations:


WITH rental_durations AS (

    SELECT inventory.film_id, DATEDIFF(return_date, rental_date) AS rental_duration

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

)

SELECT film.title, rental_durations.rental_duration

FROM film

JOIN inventory ON film.film_id = inventory.film_id

JOIN rental_durations ON inventory.film_id = rental_durations.film_id

ORDER BY rental_durations.rental_duration DESC

LIMIT 5;

## What is the name of the customer who has rented the most movies, and how many movies have they rented?

SELECT CONCAT(first_name, ' ', last_name) AS customer_name,

       (SELECT COUNT(*)

        FROM rental

        WHERE customer_id = customer.customer_id) AS rental_count

FROM customer

ORDER BY rental_count DESC

LIMIT 1;


## What is the name of the actor who has appeared in the most movies, and how many movies have they appeared in?

SELECT CONCAT(first_name, ' ', last_name) AS actor_name,

       (SELECT COUNT(*)

        FROM film_actor

        WHERE actor_id = actor.actor_id) AS movie_count

FROM actor

ORDER BY movie_count DESC

LIMIT 1;


## Which movies have been rented the most times, and how many times have they been rented? 

SELECT film.title,

       (SELECT COUNT(*)

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.film_id = film.film_id) AS rental_count

FROM film

ORDER BY rental_count DESC

LIMIT 10;


## Which movies have the highest average rental duration, and what is their average rental duration ?


SELECT film.title, AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration

FROM film

JOIN inventory ON film.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY film.film_id

ORDER BY avg_rental_duration DESC

LIMIT 10;


## What is the rental rate for the most frequently rented movie for each customer?

SELECT rental.customer_id, customer.first_name, customer.last_name,

       (SELECT MAX(film.rental_rate)

        FROM film JOIN inventory ON film.film_id = inventory.film_id

                  JOIN rental ON inventory.inventory_id = rental.inventory_id

        WHERE rental.customer_id = customer.customer_id

        GROUP BY film.film_id

        ORDER BY COUNT(*) DESC

        LIMIT 1) AS rental_rate

FROM rental JOIN customer ON rental.customer_id = customer.customer_id

GROUP BY rental.customer_id;


## What is the total revenue for each customer, including the sum of late fees?


SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       (SELECT COALESCE(SUM(amount), 0)

        FROM payment

        WHERE rental_id IN (SELECT rental_id

                            FROM rental

                            WHERE customer_id = customer.customer_id)) +

       (SELECT COALESCE(SUM(amount), 0)

        FROM payment

        WHERE rental_id IN (SELECT rental_id

                            FROM rental

                            WHERE customer_id = customer.customer_id AND

                                  payment_date > DATE_ADD(return_date, INTERVAL 1 DAY))) AS total_revenue

FROM customer;




##  What is the total revenue for each actor who has appeared in at least 10 movies?


SELECT a.actor_id, a.first_name, a.last_name,

       (SELECT SUM(payment.amount)

        FROM payment

        JOIN rental ON payment.rental_id = rental.rental_id

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        JOIN film_actor ON inventory.film_id = film_actor.film_id

        JOIN actor ON film_actor.actor_id = actor.actor_id

        WHERE actor.actor_id = a.actor_id) AS revenue

FROM actor AS a

WHERE a.actor_id IN (SELECT fa.actor_id

                     FROM film_actor AS fa

                     JOIN film AS f ON fa.film_id = f.film_id

                     GROUP BY fa.actor_id

                     HAVING COUNT(DISTINCT f.title) >= 10)

ORDER BY revenue DESC;



## What are the top 10 customers who have paid the most in late fees?

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,

       (SELECT SUM(payment.amount)

        FROM payment JOIN rental ON payment.rental_id = rental.rental_id

                     JOIN customer AS cust ON rental.customer_id = cust.customer_id

                     JOIN inventory ON rental.inventory_id = inventory.inventory_id

                     JOIN film ON inventory.film_id = film.film_id

                     WHERE cust.customer_id = c.customer_id

                     AND payment.payment_date > DATE_ADD(rental.return_date, INTERVAL 1 DAY)) AS late_fee

FROM customer AS c

ORDER BY late_fee DESC

LIMIT 10;



## What is the average number of rentals per day for each store?

SELECT store.store_id, address.address, city.city, country.country,

       COUNT(*) / DATEDIFF(MAX(return_date), MIN(rental_date)) AS avg_rentals_per_day

FROM store

JOIN address ON store.address_id = address.address_id

JOIN city ON address.city_id = city.city_id

JOIN country ON city.country_id = country.country_id

JOIN inventory ON store.store_id = inventory.store_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY store.store_id

ORDER BY avg_rentals_per_day DESC;



## Section 22


##Which actors have appeared in the most number of movies with a rating of "G", and how many movies have they appeared in? 

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name,

       COUNT(*) AS movie_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN film ON film_actor.film_id = film.film_id

WHERE film.rating = 'G'

GROUP BY actor.actor_id

ORDER BY movie_count DESC

LIMIT 10;


## Get the titles of the movies that have not been rented in the past month, using a CTE to compute the set of rented movies:


WITH rented_movies AS (

    SELECT DISTINCT inventory.film_id

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE rental.return_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)

)

SELECT film.title

FROM film

LEFT JOIN rented_movies ON film.film_id = rented_movies.film_id

WHERE rented_movies.film_id IS NULL;



## Get the names of the actors who have appeared in more than 20 movies, using a CTE to compute the movie counts:


WITH movie_counts AS (

    SELECT actor.actor_id, COUNT(*) AS movie_count

    FROM actor

    JOIN film_actor ON actor.actor_id = film_actor.actor_id

    GROUP BY actor.actor_id

)

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, movie_count

FROM actor

JOIN movie_counts ON actor.actor_id = movie_counts.actor_id

WHERE movie_count > 20

ORDER BY movie_count DESC;



## Get the names of the top 5 customers who have rented the most movies, and their rental counts, using a CTE to compute the top 5 rental counts:

WITH top_rentals AS (

    SELECT customer_id, COUNT(*) AS rental_count

    FROM rental

    GROUP BY customer_id

    ORDER BY rental_count DESC

    LIMIT 5

)

SELECT CONCAT(first_name, ' ', last_name) AS customer_name, rental_count

FROM customer

JOIN top_rentals ON customer.customer_id = top_rentals.customer_id

ORDER BY rental_count DESC;


## Which films have the highest revenue per day, and what is their revenue per day?

SELECT film.film_id, film.title,

       (SELECT COALESCE(SUM(amount), 0)

        FROM payment

        JOIN rental ON payment.rental_id = rental.rental_id

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.film_id = film.film_id) /

       (SELECT COALESCE(SUM(DATEDIFF(return_date, rental_date)), 0)

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.film_id = film.film_id) AS revenue_per_day

FROM film

ORDER BY revenue_per_day DESC

LIMIT 10;


## Which customers have rented the most movies for a single rental, and how many movies have they rented in a single rental?

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

COUNT(*) AS rental_count

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

GROUP BY rental.rental_id, rental.customer_id

HAVING rental_count > 1

ORDER BY rental_count DESC

LIMIT 10;



## Get the names of the actors who have appeared in more than 20 movies, using a CTE to compute the movie counts:

WITH movie_counts AS (

    SELECT actor.actor_id, COUNT(*) AS movie_count

    FROM actor

    JOIN film_actor ON actor.actor_id = film_actor.actor_id

    GROUP BY actor.actor_id

)

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, movie_count

FROM actor

JOIN movie_counts ON actor.actor_id = movie_counts.actor_id

WHERE movie_count > 20

ORDER BY movie_count DESC;



## Get the titles of the movies that were rented by the customer with the highest rental count:

SELECT title

FROM film

WHERE film_id IN (

    SELECT inventory.film_id

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE rental.customer_id = (

        SELECT customer_id

        FROM rental

        GROUP BY customer_id

        ORDER BY COUNT(*) DESC

        LIMIT 1

    )

);



## Get the titles of the movies that have been rented more than 100 times:

SELECT title

FROM film

WHERE film_id IN (

    SELECT inventory.film_id

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    GROUP BY inventory.film_id

    HAVING COUNT(*) > 100

);


## Get the names of the actors who have appeared in at least one movie with the actor whose actor_id is 5:


SELECT CONCAT(first_name, ' ', last_name) AS actor_name

FROM actor

WHERE actor_id IN (

    SELECT DISTINCT film_actor.actor_id

    FROM film_actor

    JOIN film ON film_actor.film_id = film.film_id

    WHERE film_actor.film_id IN (

        SELECT film_id

        FROM film_actor

        WHERE actor_id = 5

    )
	
	
## Section 23 
	
	
## Get the names of the customers who have rented more than 10 movies, and the titles of the movies they rented:

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, title

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

WHERE customer.customer_id IN (

    SELECT customer_id

    FROM rental

    GROUP BY customer_id

    HAVING COUNT(*) > 10

)

ORDER BY rental.rental_date;


## Get the names of the actors who have appeared in movies with the genre "Comedy" and the rating "PG-13":

SELECT DISTINCT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN film ON film_actor.film_id = film.film_id

JOIN film_category ON film.film_id = film_category.film_id

JOIN category ON film_category.category_id = category.category_id

WHERE category.name = 'Comedy' AND film.rating = 'PG-13';


## What is the average rental rate for each actor who has appeared in at least 10 movies?

SELECT actor.actor_id, actor.first_name, actor.last_name,

       (SELECT AVG(film.rental_rate)

        FROM film JOIN film_actor ON film.film_id = film_actor.film_id

        WHERE film_actor.actor_id = actor.actor_id) AS avg_rental_rate

FROM actor

WHERE actor.actor_id IN (SELECT film_actor.actor_id

                         FROM film_actor

                         GROUP BY film_actor.actor_id

                         HAVING COUNT(*) >= 10)

ORDER BY avg_rental_rate DESC;




## Get the names of the actors who have appeared in the top 5 longest movies (in terms of length in minutes):

SELECT DISTINCT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN (

    SELECT film_id

    FROM film

    ORDER BY length DESC

    LIMIT 5

) AS subquery ON film_actor.film_id = subquery.film_id;


## Get the average rental duration for all customers who have made more than 50 payments:


SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_duration

FROM rental

WHERE customer_id IN (

    SELECT customer_id

    FROM payment

    GROUP BY customer_id

    HAVING COUNT(*) > 50

);



## Get the total amount paid by customers who rented the movie with the longest rental duration:


SELECT SUM(amount) AS total_amount

FROM payment

WHERE rental_id IN (

    SELECT rental_id

    FROM rental

    WHERE DATEDIFF(return_date, rental_date) = (

        SELECT MAX(DATEDIFF(return_date, rental_date))

        FROM rental

    )

);



## Which films have been rented by the same customer more than once within 3 days?

SELECT rental1.rental_id, film.title, customer.customer_id

FROM rental AS rental1

JOIN rental AS rental2 ON rental1.customer_id = rental2.customer_id

JOIN inventory ON rental1.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

JOIN customer ON rental1.customer_id = customer.customer_id

WHERE rental1.rental_date <> rental2.rental_date AND DATEDIFF(rental2.rental_date, rental1.rental_date) <= 3

GROUP BY rental1.rental_id

ORDER BY rental1.customer_id, rental1.rental_date;



## Which categories have the highest average rental duration?


SELECT category.category_id, category.name, AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration

FROM category

JOIN film_category ON category.category_id = film_category.category_id

JOIN inventory ON film_category.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

GROUP BY category.category_id

ORDER BY avg_rental_duration DESC;


## Which stores have not had any rentals in the past 30 days?


SELECT store.store_id, address.address, city.city, country.country

FROM store

JOIN address ON store.address_id = address.address_id

JOIN city ON address.city_id = city.city_id

JOIN country ON city.country_id = country.country_id

WHERE NOT EXISTS

    (SELECT *

     FROM inventory

     JOIN rental ON inventory.inventory_id = rental.inventory_id

     WHERE inventory.store_id = store.store_id AND rental.rental_date >= DATE_SUB(NOW(), INTERVAL 30 DAY));
	 
	 
	 
## Get the payment ids and amounts for payments made by customers who rented movies with the genre "Action":

SELECT payment.payment_id, payment.amount

FROM payment

JOIN rental ON payment.rental_id = rental.rental_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

JOIN film_category ON film.film_id = film_category.film_id

JOIN category ON film_category.category_id = category.category_id

WHERE category.name = 'Action';



##Section 24

## Get the names of the customers who rented movies that were rented by the customer whose customer_id is 1:

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

WHERE inventory.film_id IN (

    SELECT inventory.film_id

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE rental.customer_id = 1

);


## Get the names of the actors who have appeared in the most movies, and the movie counts for each actor:

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(*) AS movie_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

GROUP BY actor.actor_id

HAVING movie_count = (

    SELECT COUNT(*) AS movie_count

    FROM film_actor

    GROUP BY actor_id

    ORDER BY COUNT(*) DESC

    LIMIT 1

)

ORDER BY movie_count DESC;


## Get the names of the customers who have rented the most movies from the "Family" category, and the titles of the movies they rented:


SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, f.title

FROM (

    SELECT rental.customer_id, COUNT(*) AS rental_count

    FROM rental

    GROUP BY rental.customer_id

    ORDER BY rental_count DESC

    LIMIT 1

) AS top_customer

JOIN customer c ON top_customer.customer_id = c.customer_id

JOIN rental r ON c.customer_id = r.customer_id

JOIN inventory i ON r.inventory_id = i.inventory_id

JOIN film f ON i.film_id = f.film_id

JOIN film_category fc ON f.film_id = fc.film_id

JOIN category cat ON fc.category_id = cat.category_id AND cat.name = 'Family'

ORDER BY r.rental_date;



## Get the titles of all the movies that have a rental duration longer than the average rental duration for all movies:

WITH average_duration AS (

    SELECT AVG(rental_duration) AS avg_duration

    FROM (

        SELECT inventory.film_id, DATEDIFF(return_date, rental_date) AS rental_duration

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

    ) AS durations

)

SELECT film.title

FROM film

JOIN inventory ON film.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

CROSS JOIN average_duration

WHERE DATEDIFF(rental.return_date, rental.rental_date) > avg_duration;



## Get the total revenue for each store in the past month, using a CTE to compute the date range:


WITH date_range AS (

    SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AS start_date, CURDATE() AS end_date

)

SELECT store.store_id, address.address, city.city, country.country,

       COALESCE(SUM(amount), 0) AS total_revenue

FROM store

JOIN address ON store.address_id = address.address_id

JOIN city ON address.city_id = city.city_id

JOIN country ON city.country_id = country.country_id

JOIN inventory ON store.store_id = inventory.store_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

JOIN payment ON rental.rental_id = payment.rental_id

CROSS JOIN date_range

WHERE payment.payment_date BETWEEN start_date AND end_date

GROUP BY store.store_id

ORDER BY total_revenue DESC;



## Which stores have the most rentals in the past month, and how many rentals have they had?

SELECT store.store_id, address.address, city.city, country.country,

       (SELECT COUNT(*)

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.store_id = store.store_id AND rental.rental_date >= DATE_SUB(NOW(), INTERVAL 1 MONTH)) AS rental_count

FROM store

JOIN address ON store.address_id = address.address_id

JOIN city ON address.city_id = city.city_id

JOIN country ON city.country_id = country.country_id

ORDER BY rental_count DESC

LIMIT 10;



 ## Which categories have the highest total revenue, and what is their total revenue?
 
 
 SELECT category.category_id, category.name,

       (SELECT COALESCE(SUM(amount), 0)

        FROM payment

        JOIN rental ON payment.rental_id = rental.rental_id

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        JOIN film_category ON inventory.film_id = film_category.film_id

        WHERE film_category.category_id = category.category_id) AS total_revenue

FROM category

ORDER BY total_revenue DESC;


## What is the total revenue for each store in the past month?

SELECT store.store_id, address.address, city.city, country.country,

       COALESCE(SUM(amount), 0) AS total_revenue

FROM store

JOIN address ON store.address_id = address.address_id

JOIN city ON address.city_id = city.city_id

JOIN country ON city.country_id = country.country_id

JOIN inventory ON store.store_id = inventory.store_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

JOIN payment ON rental.rental_id = payment.rental_id

WHERE payment.payment_date >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)

GROUP BY store.store_id

ORDER BY total_revenue DESC;


## Which stores have the highest total revenue, and what is their total revenue?


SELECT store.store_id, address.address, city.city, country.country,

       (SELECT COALESCE(SUM(amount), 0)

        FROM payment

        JOIN rental ON payment.rental_id = rental.rental_id

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        WHERE inventory.store_id = store.store_id) AS total_revenue

FROM store

JOIN address ON store.address_id = address.address_id

JOIN city ON address.city_id = city.city_id

JOIN country ON city.country_id = country.country_id

ORDER BY total_revenue DESC

LIMIT 10;



## Get the names of the actors who have appeared in more than 5 movies with the actor whose actor_id is 5:

SELECT CONCAT(first_name, ' ', last_name) AS actor_name

FROM actor

WHERE actor_id != 5 AND actor_id IN (

    SELECT DISTINCT film_actor.actor_id

    FROM film_actor

    JOIN film ON film_actor.film_id = film.film_id

    WHERE film_actor.film_id IN (

        SELECT film_id

        FROM film_actor

        WHERE actor_id = 5

    )

    GROUP BY film_actor.actor_id

    HAVING COUNT(*) > 5

);





##SECTION 25



## Get the rental ids and dates for rentals made by the staff member who has rented the most movies:


SELECT rental.rental_id, rental.rental_date

FROM rental

WHERE rental.staff_id IN (

    SELECT staff_id

    FROM (

        SELECT staff_id, COUNT(*) AS rental_count

        FROM rental

        GROUP BY staff_id

        ORDER BY rental_count DESC

        LIMIT 1

    ) AS subquery

);





## Get the names of the staff members who have rented the most movies, and the rental counts for each staff member:


SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS staff_name, COUNT(*) AS rental_count

FROM staff

JOIN rental ON staff.staff_id = rental.staff_id

GROUP BY rental.staff_id

HAVING rental_count = (

    SELECT MAX(rental_count)

    FROM (

        SELECT COUNT(*) AS rental_count

        FROM rental

        GROUP BY staff_id

    ) AS subquery

);




## Get the names of the actors who have acted in the most number of movies, and the movie counts for each actor:


SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(*) AS movie_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

GROUP BY actor.actor_id

HAVING movie_count = (

    SELECT MAX(movie_count)

    FROM (

        SELECT COUNT(*) AS movie_count

        FROM film_actor

        GROUP BY actor_id

    ) AS subquery

);





## Get the names of the categories with the most number of movies, and the movie counts for each category:


SELECT category.name, COUNT(*) AS movie_count

FROM category

JOIN film_category ON category.category_id = film_category.category_id

GROUP BY category.category_id

HAVING movie_count = (

    SELECT MAX(movie_count)

    FROM (

        SELECT COUNT(*) AS movie_count

        FROM film_category

        GROUP BY category_id

    ) AS subquery

);


## What is the average length of rental for each film, sorted by the average length in ascending order?

SELECT film.film_id, film.title,

       (SELECT AVG(DATEDIFF(return_date, rental_date))

        FROM rental WHERE rental.inventory_id IN

            (SELECT inventory_id FROM inventory WHERE inventory.film_id = film.film_id)) AS avg_rental_length

FROM film

ORDER BY avg_rental_length;


## What is the total revenue for each store, sorted by the revenue in descending order?

SELECT store.store_id, CONCAT(address.address, ', ', city.city) AS location,

       (SELECT SUM(payment.amount)

        FROM payment JOIN rental ON payment.rental_id = rental.rental_id

                     JOIN inventory ON rental.inventory_id = inventory.inventory_id

                     JOIN store ON inventory.store_id = store.store_id

        WHERE store.store_id = inventory.store_id) AS revenue

FROM store JOIN address ON store.address_id = address.address_id

           JOIN city ON address.city_id = city.city_id

ORDER BY revenue DESC;





## Get the names of the top 5 customers who have rented the most movies, and their rental counts, using a CTE to compute the top 5 rental counts:


WITH top_rentals AS (

    SELECT customer_id, COUNT(*) AS rental_count

    FROM rental

    GROUP BY customer_id

    ORDER BY rental_count DESC

    LIMIT 5

)

SELECT CONCAT(first_name, ' ', last_name) AS customer_name, rental_count

FROM customer

JOIN top_rentals ON customer.customer_id = top_rentals.customer_id

ORDER BY rental_count DESC;



## Get the titles of the top 10 movies that have been rented the most times, and their rental counts, using a CTE to compute the top 10 rental counts:

WITH top_rentals AS (

    SELECT inventory.film_id, COUNT(*) AS rental_count

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    GROUP BY inventory.film_id

    ORDER BY rental_count DESC

    LIMIT 10

)

SELECT film.title, rental_count

FROM film

JOIN top_rentals ON film.film_id = top_rentals.film_id

ORDER BY rental_count DESC;



## Get the average rental duration for each category of movies, using a CTE to compute the category durations:

WITH category_durations AS (

    SELECT category.category_id, AVG(DATEDIFF(return_date, rental_date)) AS avg_duration

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN film_category ON inventory.film_id = film_category.film_id

    JOIN category ON film_category.category_id = category.category_id

    GROUP BY category.category_id

)

SELECT category.name, avg_duration

FROM category

JOIN category_durations ON category.category_id = category_durations.category_id;


## Get the number of rentals and total revenue for each customer in the past month, using a CTE to compute the date range:

WITH date_range AS (

    SELECT DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AS start_date, CURDATE() AS end_date

)

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       COUNT(*) AS rental_count,

       SUM(amount) AS total_revenue

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN payment ON rental.rental_id = payment.rental_id

CROSS JOIN date_range

WHERE payment.payment_date BETWEEN start_date AND end_date

GROUP BY customer.customer_id

ORDER BY rental_count DESC;



## Section 26


## Get the names of the actors who have acted in the most number of movies with the rating "PG-13", and the movie counts for each actor:



SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(*) AS movie_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN film ON film_actor.film_id = film.film_id

WHERE film.rating = 'PG-13'

GROUP BY actor.actor_id

HAVING movie_count = (

    SELECT MAX(movie_count)

    FROM (

        SELECT COUNT(*) AS movie_count

        FROM film_actor

        JOIN film ON film_actor.film_id = film.film_id

        WHERE film.rating = 'PG-13'

        GROUP BY actor_id

    ) AS subquery

);



## Which customers have rented the most number of films, and what are the titles of those films?

SELECT c.customer_id, c.first_name, c.last_name, (

    SELECT COUNT(*)

    FROM rental r

    WHERE r.customer_id = c.customer_id

) AS num_rentals

FROM customer c

ORDER BY num_rentals DESC

LIMIT 5;

What are the top 5 films with the highest revenue, and what are the titles of the actors who starred in those films?

SELECT f.title, (

    SELECT SUM(p.amount)

    FROM payment p

    INNER JOIN rental r ON p.rental_id = r.rental_id

    INNER JOIN inventory i ON r.inventory_id = i.inventory_id

    WHERE i.film_id = f.film_id

) AS revenue, GROUP_CONCAT(DISTINCT CONCAT(a.first_name, ' ', a.last_name) SEPARATOR ', ') AS actors

FROM film f

INNER JOIN film_actor fa ON f.film_id = fa.film_id

INNER JOIN actor a ON fa.actor_id = a.actor_id

GROUP BY f.film_id

ORDER BY revenue DESC

LIMIT 5;


## Get the names of the categories with the most number of movies with the rating "R", and the movie counts for each category:


SELECT category.name, COUNT(*) AS movie_count

FROM category

JOIN film_category ON category.category_id = film_category.category_id

JOIN film ON film_category.film_id = film.film_id

WHERE film.rating = 'R'

GROUP BY category.category_id

HAVING movie_count = (

    SELECT MAX(movie_count)

    FROM (

        SELECT COUNT(*) AS movie_count

        FROM film_category

        JOIN film ON film_category.film_id = film.film_id

        WHERE film.rating = 'R'

        GROUP BY category_id

    ) AS subquery

);


##Get the name of the country with the highest total rental revenue, and the revenue amount: 

SELECT country.country, (

    SELECT SUM(amount)

    FROM rental

    JOIN payment ON rental.rental_id = payment.rental_id

    JOIN customer ON rental.customer_id = customer.customer_id

    JOIN address ON customer.address_id = address.address_id

    JOIN city ON address.city_id = city.city_id

    JOIN country ON city.country_id = country.country_id

    WHERE country.country_id = city.country_id

) AS total_revenue

FROM country

ORDER BY total_revenue DESC

LIMIT 1;


## Get the name of the country with the highest average rental duration, and the average duration in days:

SELECT country.country, (

    SELECT AVG(DATEDIFF(return_date, rental_date))

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN store ON inventory.store_id = store.store_id

    JOIN address ON store.address_id = address.address_id

    JOIN city ON address.city_id = city.city_id

    JOIN country ON city.country_id = country.country_id

    WHERE country.country_id = city.country_id

) AS avg_duration_days

FROM country

ORDER BY avg_duration_days DESC

LIMIT 1;



## Get the title of the film with the highest total rental revenue across all stores, and the revenue amount:

SELECT title, (

    SELECT SUM(amount)

    FROM payment

    JOIN rental ON payment.rental_id = rental.rental_id

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    WHERE film.film_id = inventory.film_id

) AS total_revenue

FROM film

WHERE film.film_id IN (

    SELECT DISTINCT inventory.film_id

    FROM inventory

)

ORDER BY total_revenue DESC

LIMIT 1;



## Get the name of the country that has the highest number of rentals, and the rental count:

SELECT country, (

    SELECT COUNT(*)

    FROM rental

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN store ON inventory.store_id = store.store_id

    JOIN address ON store.address_id = address.address_id

    JOIN city ON address.city_id = city.city_id

    JOIN country ON city.country_id = country.country_id

    WHERE country.country_id = c.country_id

) AS rental_count

FROM country c

ORDER BY rental_count DESC

LIMIT 1;


## Get the name of the city that has the highest total rental revenue, and the revenue amount:

SELECT city, (

    SELECT SUM(amount)

    FROM payment

    JOIN rental ON payment.rental_id = rental.rental_id

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN store ON inventory.store_id = store.store_id

    JOIN address ON store.address_id = address.address_id

    JOIN city ON address.city_id = city.city_id

    WHERE city.city_id = c.city_id

) AS total_revenue

FROM city c

ORDER BY total_revenue DESC

LIMIT 1;



## Get the name of the city that has the highest total rental revenue, and the revenue amount:

SELECT city, (

    SELECT SUM(amount)

    FROM payment

    JOIN rental ON payment.rental_id = rental.rental_id

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN store ON inventory.store_id = store.store_id

    JOIN address ON store.address_id = address.address_id

    JOIN city ON address.city_id = city.city_id

    WHERE city.city_id = c.city_id

) AS total_revenue

FROM city c


## Get the name of the actor who has the highest average rental rate for the films in which they have appeared, and the average rate:


SELECT CONCAT(first_name, ' ', last_name) AS actor_name, AVG(rental_rate) AS avg_rate

FROM actor a

JOIN film_actor fa ON a.actor_id = fa.actor_id

JOIN film f ON fa.film_id = f.film_id

WHERE rental_rate = (

    SELECT MAX(rental_rate)

    FROM film

    WHERE film_id IN (

        SELECT film_id

        FROM film_actor

        WHERE actor_id = a.actor_id

    )

)

GROUP BY a.actor_id

ORDER BY avg_rate DESC

LIMIT 1;


## Section 27

## Get the name of the film that has the highest total revenue from late returns, and the revenue amount:

SELECT title, SUM(amount) AS total_revenue

FROM film

JOIN inventory i ON film.film_id = i.film_id

JOIN rental r ON i.inventory_id = r.inventory_id

JOIN payment p ON r.rental_id = p.rental_id

WHERE rental_rate < (

    SELECT AVG(rental_rate)

    FROM film

    JOIN inventory ON film.film_id = inventory.film_id

    JOIN rental ON inventory.inventory_id = rental.inventory_id

)

GROUP BY film.film_id

ORDER BY total_revenue DESC

LIMIT 1;



## Get the name and email address of the customer who has the highest total amount paid in late fees, and the total amount paid:


SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, c.email, SUM(p.amount) AS total_late_fees

FROM customer c

JOIN payment p ON c.customer_id = p.customer_id

WHERE p.amount < 0

GROUP BY c.customer_id

HAVING total_late_fees = (

    SELECT MAX(total_late_fees)

    FROM (

        SELECT c2.customer_id, SUM(p2.amount) AS total_late_fees

        FROM customer c2

        JOIN payment p2 ON c2.customer_id = p2.customer_id

        WHERE p2.amount < 0

        GROUP BY c2.customer_id

    ) AS t

    WHERE t.customer_id = c.customer_id

);



## Get the names of the actors who have acted in the most number of movies in the category "Comedy", and the movie counts for each actor:

SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(*) AS movie_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN film_category ON film_actor.film_id = film_category.film_id

JOIN category ON film_category.category_id = category.category_id

WHERE category.name = 'Comedy'

GROUP BY actor.actor_id

HAVING movie_count = (

    SELECT MAX(movie_count)

    FROM (

        SELECT COUNT(*) AS movie_count

        FROM film_actor

        JOIN film_category ON film_actor.film_id = film_category.film_id

        JOIN category ON film_category.category_id = category.category_id

        WHERE category.name = 'Comedy'

        GROUP BY actor_id

    ) AS subquery

);


## Get the title of the film with the highest total rental revenue in the "Comedy" category, and the revenue amount:

ELECT title, (

    SELECT SUM(amount)

    FROM payment

    JOIN rental ON payment.rental_id = rental.rental_id

    JOIN inventory ON rental.inventory_id = inventory.inventory_id

    JOIN film_category ON inventory.film_id = film_category.film_id

    JOIN category ON film_category.category_id = category.category_id

    WHERE film.film_id = inventory.film_id AND category.name = 'Comedy'

) AS total_revenue

FROM film

WHERE film.film_id IN (

    SELECT DISTINCT inventory.film_id

    FROM inventory

    JOIN film_category ON inventory.film_id = film_category.film_id

    JOIN category ON film_category.category_id = category.category_id

    WHERE category.name = 'Comedy'

)

ORDER BY total_revenue DESC

LIMIT 1;

## Get the names of the actors who have acted in the most number of movies with the rating "R", and the movie counts for each actor:


SELECT CONCAT(actor.first_name, ' ', actor.last_name) AS actor_name, COUNT(*) AS movie_count

FROM actor

JOIN film_actor ON actor.actor_id = film_actor.actor_id

JOIN film ON film_actor.film_id = film.film_id

WHERE film.rating = 'R'

GROUP BY actor.actor_id

HAVING movie_count = (

    SELECT MAX(movie_count)

    FROM (

        SELECT COUNT(*) AS movie_count

        FROM film_actor

        JOIN film ON film_actor.film_id = film.film_id

        WHERE film.rating = 'R'

        GROUP BY actor_id

    ) AS subquery

);

## Get the names of the customers who have rented the most number of movies with the rating "PG", and the movie counts for each customer:

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, COUNT(*) AS movie_count

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

WHERE film.rating = 'PG'

GROUP BY rental.customer_id

HAVING movie_count = (

    SELECT MAX(movie_count)

    FROM (

        SELECT COUNT(*) AS movie_count

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        JOIN film ON inventory.film_id = film.film_id

        WHERE film.rating = 'PG'

        GROUP BY customer_id

    ) AS subquery

);



## Which customers have rented at least one movie in every category?

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name

FROM customer

WHERE NOT EXISTS

    (SELECT *

     FROM category

     WHERE NOT EXISTS

         (SELECT *

          FROM film_category

          WHERE film_category.category_id = category.category_id AND

                EXISTS

                    (SELECT *

                     FROM inventory

                     WHERE inventory.film_id = film_category.film_id AND

                           EXISTS

                               (SELECT *

                                FROM rental

                                WHERE rental.inventory_id = inventory.inventory_id AND

                                      rental.customer_id = customer.customer_id))))

ORDER BY customer_name;


## What is the name of the customer who has rented the most movies for a single rental, and how many movies did they rent in a single rental?


SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       rental.rental_id, COUNT(*) AS rental_count

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

GROUP BY rental.rental_id, rental.customer_id

HAVING rental_count =

    (SELECT MAX(rental_count)

     FROM

         (SELECT rental.rental_id, COUNT(*) AS rental_count

          FROM rental

          GROUP BY rental.rental_id) AS rental_counts)

ORDER BY rental_count DESC

LIMIT 1;





## Get the names of the staff members who have rented movies with the genre "Comedy" the most number of times, and the rental counts for each staff member:

SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS staff_name, COUNT(*) AS rental_count

FROM staff

JOIN rental ON staff.staff_id = rental.staff_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

JOIN film_category ON film.film_id = film_category.film_id

JOIN category ON film_category.category_id = category.category_id

WHERE category.name = 'Comedy'

GROUP BY rental.staff_id

HAVING rental_count = (

    SELECT MAX(rental_count)

    FROM (

        SELECT COUNT(*) AS rental_count

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        JOIN film ON inventory.film_id = film.film_id

        JOIN film_category ON film.film_id = film_category.film_id

        JOIN category ON film_category.category_id = category.category_id

        WHERE category.name = 'Comedy'

        GROUP BY rental.staff_id

    ) AS subquery

);



## Get the names of the staff members who rented movies with the rating "G" the most number of times, and the rental counts for each staff member:

SELECT CONCAT(staff.first_name, ' ', staff.last_name) AS staff_name, COUNT(*) AS rental_count

FROM staff

JOIN rental ON staff.staff_id = rental.staff_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film ON inventory.film_id = film.film_id

WHERE film.rating = 'G'

GROUP BY rental.staff_id

HAVING rental_count = (

    SELECT MAX(rental_count)

    FROM (

        SELECT COUNT(*) AS rental_count

        FROM rental

        JOIN inventory ON rental.inventory_id = inventory.inventory_id

        JOIN film ON inventory.film_id = film.film_id

        WHERE film.rating = 'G'

        GROUP BY rental.staff_id

    ) AS subquery

);



## Which customers have rented all the films in each category?

SELECT category.category_id, category.name, customer.customer_id,

       CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name

FROM category

JOIN film_category ON category.category_id = film_category.category_id

JOIN inventory ON film_category.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

JOIN customer ON rental.customer_id = customer.customer_id

WHERE EXISTS (SELECT *

                  FROM film_category

                  WHERE film_category.category_id = category.category_id

                    AND EXISTS (SELECT *

                                    FROM inventory

                                    WHERE inventory.film_id = film_category.film_id

                                      AND EXISTS (SELECT *

                                                  FROM rental

                                                  WHERE rental.inventory_id = inventory.inventory_id

                                                    AND rental.customer_id = customer.customer_id)))

GROUP BY category.category_id, customer.customer_id;





## What is the total number of rentals for each customer who has rented more than 10 movies and has a total rental duration of more than 30 days?

SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, COUNT(*) AS rental_count

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

WHERE customer.customer_id IN

    (SELECT rental.customer_id

     FROM rental

     JOIN inventory ON rental.inventory_id = inventory.inventory_id

     JOIN film ON inventory.film_id = film.film_id

     GROUP BY rental.customer_id

     HAVING COUNT(*) > 10 AND SUM(DATEDIFF(return_date, rental_date)) > 30)

GROUP BY customer.customer_id

ORDER BY rental_count DESC;


## What is the total number of rentals per customer who has rented at least one movie in each category?

SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

(SELECT COUNT(*)

FROM rental

WHERE customer_id = customer.customer_id) AS rental_count

FROM customer

WHERE EXISTS

(SELECT *

FROM category

WHERE NOT EXISTS

(SELECT *

FROM film_category

WHERE film_category.category_id = category.category_id AND

NOT EXISTS

(SELECT *

FROM inventory

WHERE inventory.film_id = film_category.film_id AND

EXISTS

(SELECT *

FROM rental

WHERE rental.inventory_id = inventory.inventory_id AND

rental.customer_id = customer.customer_id))))

ORDER BY rental_count DESC;



## What is the total number of rentals for each customer who has rented at least one movie in each language?

SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       (SELECT COUNT(*)

        FROM rental

        WHERE customer_id = customer.customer_id) AS rental_count

FROM customer

WHERE EXISTS

    (SELECT *

     FROM language

     WHERE NOT EXISTS

         (SELECT *

          FROM film

          WHERE film.language_id = language.language_id AND

                NOT EXISTS

                    (SELECT *

                     FROM inventory

                     WHERE inventory.film_id = film.film_id AND

                           EXISTS

                               (SELECT *

                                FROM rental

                                WHERE rental.inventory_id = inventory.inventory_id AND

                                      rental.customer_id = customer.customer_id))))

ORDER BY rental_count DESC;



## Which customers have rented the most movies in each category, and how many movies have they rented?

SELECT category.category_id, category.name AS category_name,

       CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       COUNT(*) AS rental_count

FROM category

JOIN film_category ON category.category_id = film_category.category_id

JOIN inventory ON film_category.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

JOIN customer ON rental.customer_id = customer.customer_id

GROUP BY category.category_id, customer.customer_id

HAVING rental_count =

    (SELECT MAX(rental_count)

     FROM

         (SELECT COUNT(*) AS rental_count

          FROM category

          JOIN film_category ON category.category_id = film_category.category_id

          JOIN inventory ON film_category.film_id = inventory.film_id

          JOIN rental ON inventory.inventory_id = rental.inventory_id

          WHERE rental.customer_id = customer.customer_id

          GROUP BY category.category_id, rental.customer_id) AS rental_counts)

ORDER BY category.category_id, rental_count DESC;



## Get the names of the customers who have rented at least one movie in every category, using a CTE to compute the set of categories: 

WITH category_set AS (

    SELECT category.category_id

    FROM category

)

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name

FROM customer

JOIN rental ON customer.customer_id = rental.customer_id

JOIN inventory ON rental.inventory_id = inventory.inventory_id

JOIN film_category ON inventory.film_id = film_category.film_id

JOIN category_set ON film_category.category_id = category_set.category_id

WHERE NOT EXISTS (

    SELECT *

    FROM category_set

    WHERE category_set.category_id NOT IN (

        SELECT film_category.category_id

        FROM inventory

        JOIN rental ON inventory.inventory_id = rental.inventory_id

        JOIN film_category ON inventory.film_id = film_category.film_id

        WHERE rental.customer_id = customer.customer_id

    )

)

ORDER BY customer_name;


## Get the names of the customers who have rented the most movies in each category, and the rental counts for each customer, but only for the "Sports" and "Action" categories:

SELECT category.name AS category_name,

       CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,

       COUNT(*) AS rental_count

FROM category

JOIN film_category ON category.category_id = film_category.category_id

JOIN inventory ON film_category.film_id = inventory.film_id

JOIN rental ON inventory.inventory_id = rental.inventory_id

JOIN customer ON rental.customer_id = customer.customer_id

WHERE category.name IN ('Sports', 'Action') AND rental.customer_id = (

    SELECT customer_id

    FROM rental

    WHERE inventory.film_id = (

        SELECT film_id

        FROM inventory

        WHERE rental.inventory_id = inventory.inventory_id

    )

    GROUP BY customer_id

    ORDER BY COUNT(*) DESC

    LIMIT 1

)

GROUP BY category.category_id, customer.customer_id

ORDER BY category.category_id, rental_count DESC;


## Get the name of the film that has the highest total rental revenue, and the amount of revenue generated for each actor:

SELECT title, (

SELECT SUM(amount)

FROM payment p

JOIN rental r ON p.rental_id = r.rental_id

JOIN inventory i ON r.inventory_id = i.inventory_id

WHERE i.film_id = f.film_id

) AS total_revenue, CONCAT(a.first_name, ' ', a.last_name) AS actor_name, COUNT(*) AS rental_count

FROM film f

JOIN film_actor fa ON f.film_id = fa.film_id

JOIN actor a ON fa.actor_id = a.actor_id

GROUP BY f.film_id, a.actor_id

HAVING total_revenue = (

SELECT MAX(total_revenue)

FROM (

SELECT f.film_id, a.actor_id, SUM(amount) AS total_revenue

FROM film f

JOIN film_actor fa ON f.film_id = fa.film_id

JOIN actor a ON fa.actor_id = a.actor_id

JOIN inventory i ON f.film_id = i.film_id

JOIN rental r ON i.inventory_id = r.inventory_id

JOIN payment p ON r.rental_id = p.rental_id

GROUP BY f.film_id, a.actor_id

) AS t

WHERE t.film_id = f.film_id

);



## Get the name of the customer who has the highest total rental revenue for films that have a rental rate higher than the average rental rate across all films, and the amount of revenue:

SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, (

    SELECT SUM(amount)

    FROM payment p

    JOIN rental r ON p.rental_id = r.rental_id

    JOIN inventory i ON r.inventory_id = i.inventory_id

    JOIN film f ON i.film_id = f.film_id

    WHERE f.rental_rate > (

        SELECT AVG(rental_rate)

        FROM film

    ) AND r.customer_id = c.customer_id

) AS total_revenue

FROM customer c

GROUP BY c.customer_id

HAVING total_revenue = (

    SELECT MAX(total_revenue)

    FROM (

        SELECT c.customer_id, SUM(amount) AS total_revenue

        FROM payment p

        JOIN rental r ON p.rental_id = r.rental_id

        JOIN inventory i ON r.inventory_id = i.inventory_id

        JOIN film f ON i.film_id = f.film_id

        WHERE f.rental_rate > (

            SELECT AVG(rental_rate)

            FROM film

        )

        GROUP BY r.customer_id

    ) AS t

    WHERE t.customer_id = c.customer_id

);





## For each category, what is the total revenue from rentals, and what are the top 3 films by revenue in that category?

WITH category_revenue AS (

  SELECT c.name AS category, SUM(p.amount) AS revenue, f.title,

    ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY SUM(p.amount) DESC) AS film_rank

  FROM category c

  INNER JOIN film_category fc ON c.category_id = fc.category_id

  INNER JOIN inventory i ON fc.film_id = i.film_id

  INNER JOIN rental r ON i.inventory_id = r.inventory_id

  INNER JOIN payment p ON r.rental_id = p.rental_id

  INNER JOIN film f ON fc.film_id = f.film_id

  GROUP BY c.category_id, f.film_id

)

SELECT category, revenue, title

FROM category_revenue

WHERE film_rank <= 3

ORDER BY category, film_rank;

























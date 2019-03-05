/* 	forrest jehlik, 
	Udacity Programming for Data Science SQL submission
	12/19/2018 
*/


/*
Query 1:
*/
Create a query that calculates the total amount earned by film category and the average amount 
earned per unit rental in each category to determine the highest and lowest earning categories. 
Note that the total amount earned may  not correlate to the highest earned per rental.

SELECT 	c.name AS film_category, 
		COUNT(r.rental_id) AS num_rentals, 
		ROUND(SUM(p.amount),0) AS tot_earned, 
		ROUND(SUM(p.amount) / COUNT(r.rental_id),2) AS avg_per_rental
FROM film_category fc 
JOIN film f
ON f.film_id = fc.film_id
JOIN category c 
ON fc.category_id = c.category_id
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id 
JOIN payment p 
ON r.rental_id = p.rental_id

GROUP BY c.name 
ORDER BY avg_per_rental DESC;

/*
QUERY 2:
Create a query that determines the most top 10 most profitable actors in total sales and per rental. 
*/

SELECT 	a.first_name || ' ' || a.last_name AS actor, 
		COUNT(r.rental_id) AS num_rentals, 
		ROUND(SUM(p.amount),0) AS tot_earned, 
		ROUND(SUM(p.amount) / COUNT(r.rental_id),2) AS avg_per_rental
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
JOIN film f
ON fa.film_id = f.film_id
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id 
JOIN payment p 
ON r.rental_id = p.rental_id

GROUP by actor
ORDER BY tot_earned DESC
LIMIT 10;


/*QUERY 3:
Create a query that determines the average num rentals per day per film category 
*/

SELECT  category, 
		ROUND(AVG(event_count),1) AS avg_event_count
FROM
(SELECT DATE_TRUNC('day', r.rental_date) AS day, 
		c.name AS category,
		COUNT(*) AS event_count
FROM rental r
JOIN inventory i
ON r.inventory_id = i.inventory_id
JOIN film f
ON f.film_id = i.film_id
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON c.category_id = fc.category_id
GROUP BY 1,2
ORDER BY 1) subQ1

GROUP BY 1
ORDER BY 2 DESC;

/*QUERY 4:
Create a query that determines the weekly running sales by film category 
*/
 
SELECT week, category, tot_sales
FROM
(SELECT	DATE_TRUNC('week', p.payment_date) AS week,
		c.name AS category,
		p.amount AS amount, 
		SUM(p.amount) OVER (PARTITION BY DATE_TRUNC('week', p.payment_date) ORDER BY c.name) AS tot_sales

FROM category c 
JOIN film_category fc 
ON c.category_id = fc.category_id 
JOIN film f 
ON fc.film_id = f.film_id 
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r 
ON i.inventory_id = r.inventory_id
JOIN payment p
ON r.rental_id = p.rental_id
) AS subQ1

GROUP BY 1,2,3
ORDER BY 2,1; 

 

 
 







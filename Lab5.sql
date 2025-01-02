USE sakila;

SELECT * FROM actor;
SELECT * FROM film_category;
SELECT * FROM category;
SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM store;
SELECT * FROM film;
SELECT * FROM inventory;

SELECT f.title, COUNT(i.inventory_id) AS number_of_copies
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = "Hunchback Impossible"
GROUP BY title;

SELECT 
    title AS film_title,
    length AS film_length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);
    
SELECT 
    a.first_name,
    a.last_name
FROM 
    actor a
WHERE 
    actor_id IN (
        SELECT 
            actor_id
        FROM 
            film_actor fa
            JOIN film f 
            ON fa.film_id = f.film_id
        WHERE 
            f.title = 'Alone Trip'
    );

SELECT 
    f.title AS film_title,
    c.name AS category
FROM 
    film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE 
    c.name = 'Family';

SELECT 
    first_name, 
    last_name,
    email
FROM 
    customer
WHERE 
    address_id IN (
        SELECT 
            address_id 
        FROM 
            address 
        WHERE 
            city_id IN (
                SELECT 
                    city_id 
                FROM 
                    city 
                WHERE 
                    country_id IN (
                        SELECT 
                            country_id 
                        FROM 
                            country 
                        WHERE 
                            country = 'Canada'
                    )
            )
    );
    
  SELECT 
    cu.first_name, 
    cu.last_name, 
    cu.email
FROM 
    customer cu
JOIN address a ON cu.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE 
    co.country = 'Canada';  
    
    SELECT 
    f.title AS film_title
FROM 
    film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN (
    SELECT 
        actor_id, 
        COUNT(film_id) AS film_count
    FROM 
        film_actor
    GROUP BY 
        actor_id
    ORDER BY 
        film_count DESC
    LIMIT 1
) AS prolific_actor ON fa.actor_id = prolific_actor.actor_id;
SELECT 
    f.title AS film_title
FROM 
    film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN (
    SELECT 
        customer_id, 
        SUM(amount) AS total_spent
    FROM 
        payment
    GROUP BY 
        customer_id
    ORDER BY 
        total_spent DESC
    LIMIT 1
) AS most_profitable_customer ON r.customer_id = most_profitable_customer.customer_id;
SELECT 
    customer_id AS client_id, 
    SUM(amount) AS total_amount_spent
FROM 
    payment
GROUP BY 
    customer_id
HAVING 
    total_amount_spent > (SELECT AVG(total_amount_spent) FROM 
    (SELECT 
        customer_id, 
        SUM(amount) AS total_amount_spent
    FROM 
        payment
    GROUP BY customer_id) AS subquery);
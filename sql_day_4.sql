DROP PROCEDURE lateFee;

-- Example of a store procedure
CREATE PROCEDURE lateFee(
	cust_id INTEGER, -- customer_id
	pay_id INTEGER, --payment_id
	late_fee_amount DECIMAL(5,2) --amount to the payment amount
)
LANGUAGE plpgsql --gets stored and lets other people know what language you're running your querys and procedures
AS $$  -- literal string quoting storeing the below query in a string literal to run when we call the procedure
BEGIN 
		--Add a late fee to customer payment amount
		UPDATE payment
		SET amount = amount + late_fee_amount
		WHERE customer_id = cust_id AND payment_id = pay_id;
		
		-- commit the above statement inside of ouyr procedure transaction
		COMMIT;
END;
$$;

SELECT district, postal_code, city.city
FROM address
INNER JOIN city
ON address.city_id = city.city_id
WHERE district = 'Texas';

-- Create a procedure to update an addresses postalcode based on the city spesifically for Texas

CREATE PROCEDURE new_address(
	post_code_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
		UPDATE address
		SET postal_code = post_code_id;
		COMMIT;
		
END;
$$;

CREATE OR REPLACE PROCEDURE update_postal(
	city_name VARCHAR, --city to be updated
	zipcode VARCHAR -- zipcode argument
		
)
LANGUAGE plpgsql -- gets strored and lets other users know what language you're running your queries and procedures in
AS $$ -- literal string quoting, storing the below query in a string literal to be run when we call the procedure
BEGIN
		--Add a late fee to customer payment amount
		UPDATE address
		SET postal_code = zipcode
		WHERE city_id IN(
			SELECT city_id
			FROM city
			WHERE city = city_name
		);

		
		--Commit the above statement inside of our procedure transaction
		COMMIT;
END;
$$;



CREATE OR REPLACE FUNCTION add_actor(_actor_id INTEGER, _first_name VARCHAR,_last_name VARCHAR, _last_update TIMESTAMP WITHOUT TIME ZONE)
RETURNS void
AS $MAIN$
BEGIN
	INSERT INTO actor
	VALUES(_actor_id, _first_name, _last_name, _last_update);
END;
$MAIN$
LANGUAGE plpgsql;

--DO NOT CALL A FUNCTION __ SELECT IT
SELECT add_actor(500, 'Orlando', 'Bloom', NOW()::timestamp);

SELECT *
FROM actor
WHERE actor_id = 500;


-- function isa going to return an integer
-- def cool_function(something):
-- 		return something

-- def print_function(something):
-- 		returns something2
-- print(function(cool_function(something)))

CREATE OR REPLACE FUNCTION zip_code_calc()
RETURNS INTEGER
AS $$
BEGIN
	RETURN (RANDOM() * (80000 - 73301))+ 73301;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_texas_zipcode()
LANGUAGE plpgsql
AS $$
BEGIN

	UPDATE address
	SET postal_code = zip_code_calc()
	WHERE district = 'Texas';
	
	COMMIT;
	
END;
$$;

CALL update_texas_zipcode();



SELECT district,postal_code, city.city, address
FROM address
INNER JOIN city
ON address.city_id = city.city_id
WHERE district = 'Texas';



CREATE TABLE IF NOT EXISTS actor(
	new_id INTEGER
);


-- command F gets to regex

SELECT *
FROM payment;

-- use payment and rental table 

-- procedure
-- homework below

CREATE OR REPLACE PROCEDURE _update_payment()
LANGUAGE plpgsql
AS $$

BEGIN
	UPDATE payment
	SET amount = amount + 10
	WHERE payment_date < now() - INTERVAL '7 days'
	AND customer_id IN (
		SELECT rental.customer_id
		FROM rental
		WHERE rental.return_date > rental.return_date + INTERVAL '7 days'
	);

END;
$$;

CALL _update_payment()


SELECT *
FROM customer;

SELECT *
FROM rental;

SELECT *
FROM payment;


-- question 2 (below)
ALTER TABLE customer ADD COLUMN platinum_member boolean;


CREATE OR REPLACE PROCEDURE update_platinum_member()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE customer SET platinum_member = true
    WHERE customer_id IN (
        SELECT customer_id FROM payment
        GROUP BY customer_id
        HAVING SUM(amount) > 200
    );
    UPDATE customer SET platinum_member = false
    WHERE customer_id NOT IN (
        SELECT customer_id FROM payment
        GROUP BY customer_id
        HAVING SUM(amount) > 200
    );
END;
$$;

CALL update_platinum_member();

SELECT *
FROM customer;







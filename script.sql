-- Drop the store table if it exists
DROP TABLE IF EXISTS store;

-- Create the store table
CREATE TABLE store (
    order_id        INTEGER PRIMARY KEY,
    order_date      DATE NOT NULL,
    customer_id     INTEGER NOT NULL,
    customer_phone  VARCHAR(50),
    customer_email  VARCHAR(100) UNIQUE NOT NULL,
    item_1_id       INTEGER,
    item_1_name     VARCHAR(100),
    item_1_price    NUMERIC,
    item_2_id       INTEGER,
    item_2_name     VARCHAR(100),
    item_2_price    NUMERIC,
    item_3_id       INTEGER,
    item_3_name     VARCHAR(100),
    item_3_price    NUMERIC
);

-- Count distinct orders
SELECT COUNT(DISTINCT order_id) AS orders_placed
FROM store;

-- Count distinct customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM store;

-- Fetch customer details by customer_id
SELECT customer_id, customer_email, customer_phone
FROM store
WHERE customer_id = 1;

-- Fetch item details by item_1_id
SELECT item_1_id, item_1_name, item_1_price
FROM store
WHERE item_1_id = 4;

-- Create the customers table
CREATE TABLE customers AS
SELECT DISTINCT customer_id, customer_phone, customer_email
FROM store;

-- Add a primary key to the customers table
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- Create the items table by normalizing item data from the store table
CREATE TABLE items AS
SELECT DISTINCT
    item_1_id AS item_id,
    item_1_name AS name,
    item_1_price AS price
FROM store
UNION 
SELECT DISTINCT
    item_2_id AS item_id,
    item_2_name AS name,
    item_2_price AS price
FROM store
WHERE item_2_id IS NOT NULL
UNION 
SELECT DISTINCT
    item_3_id AS item_id,
    item_3_name AS name,
    item_3_price AS price
FROM store
WHERE item_3_id IS NOT NULL;

-- Add primary key to the items table
ALTER TABLE items
ADD PRIMARY KEY (item_id);

-- Create the orders_items table to handle the many-to-many relationship between orders and items
CREATE TABLE orders_items AS
SELECT  
    order_id,
    item_1_id AS item_id
FROM store
UNION ALL
SELECT  
    order_id,
    item_2_id AS item_id
FROM store
UNION ALL
SELECT  
    order_id,
    item_3_id AS item_id
FROM store;

-- Create the orders table
CREATE TABLE orders AS
SELECT DISTINCT order_id, order_date, customer_id
FROM store;

-- Add primary key to the orders table
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- Add foreign key from orders to customers
ALTER TABLE orders
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- Add foreign keys to orders_items
ALTER TABLE orders_items
ADD FOREIGN KEY (item_id)
REFERENCES items(item_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- Fetch customer emails for orders placed after a specific date
SELECT customer_email
FROM store
WHERE order_date > '2019-07-25';

-- Improved join syntax to fetch customer emails for orders after the date
SELECT c.customer_email
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_date > '2019-07-25';

-- Count occurrences of all items (1, 2, 3) across orders
WITH all_items AS (
    SELECT 
        item_1_id AS item_id
    FROM store
    UNION ALL
    SELECT 
        item_2_id AS item_id
    FROM store
    WHERE item_2_id IS NOT NULL
    UNION ALL
    SELECT
        item_3_id AS item_id	
    FROM store
    WHERE item_3_id IS NOT NULL
)
SELECT item_id, COUNT(*)
FROM all_items
GROUP BY item_id;

-- Count occurrences of items in the orders_items table
SELECT item_id, COUNT(*)
FROM orders_items
GROUP BY item_id;

-- Fetch customers with more than one order
SELECT 
    o.customer_id, 
    COUNT(o.order_id) AS number_of_orders,
    c.customer_email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_email
HAVING COUNT(o.order_id) > 1
ORDER BY number_of_orders DESC;

-- Fetch details of specific orders that include a specific item (e.g., 'lamp')
SELECT o.order_id, o.order_date, i.name
FROM orders o
JOIN orders_items oi ON o.order_id = oi.order_id
JOIN items i ON oi.item_id = i.item_id
WHERE o.order_date > '2019-07-15'
AND i.name = 'lamp';

-- Count the number of orders for items named 'chair'
SELECT COUNT(o.order_id)
FROM orders o
JOIN orders_items oi ON o.order_id = oi.order_id
JOIN items i ON oi.item_id = i.item_id
WHERE i.name = 'chair'
GROUP BY i.name;

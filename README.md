# Store Management SQL Project

This project demonstrates a complete **relational database design** and querying system for managing an e-commerce store. It involves creating and managing tables such as `store`, `customers`, `items`, `orders`, and `orders_items`. Additionally, it focuses on the normalization of data, using foreign key relationships, optimizing queries, and performing analytical SQL queries.

## Project Overview

### Key Features:
1. **Table Creation**: 
   - The project begins by creating a `store` table, which includes customer information, order details, and up to three item details.
2. **Normalization**: 
   - The data from the `store` table is normalized into separate tables (`customers`, `items`, `orders`, and `orders_items`) to avoid redundancy and ensure scalability.
3. **Foreign Key Constraints**:
   - Proper foreign key relationships between tables are established to maintain referential integrity, ensuring consistency of data across multiple tables.
4. **Efficient Querying**:
   - Various SQL queries are written to count distinct orders, fetch customer information, analyze item sales, and more.
5. **Advanced Query Techniques**:
   - Usage of `WITH` clauses, `JOIN` statements, and `GROUP BY` clauses to extract meaningful insights from the data.

---

## Database Schema

### 1. `store` Table:
Stores temporary order information, including customer details and item purchases.

| Column            | Data Type   | Description                             |
|-------------------|-------------|-----------------------------------------|
| order_id          | INTEGER     | Unique identifier for the order (Primary Key) |
| order_date        | DATE        | Date the order was placed               |
| customer_id       | INTEGER     | Unique identifier for the customer      |
| customer_phone    | VARCHAR(50) | Customer phone number                   |
| customer_email    | VARCHAR(100)| Customer email address (Unique)         |
| item_1_id         | INTEGER     | ID of the first item in the order       |
| item_1_name       | VARCHAR(100)| Name of the first item                  |
| item_1_price      | NUMERIC     | Price of the first item                 |
| item_2_id         | INTEGER     | ID of the second item in the order      |
| item_2_name       | VARCHAR(100)| Name of the second item                 |
| item_2_price      | NUMERIC     | Price of the second item                |
| item_3_id         | INTEGER     | ID of the third item in the order       |
| item_3_name       | VARCHAR(100)| Name of the third item                  |
| item_3_price      | NUMERIC     | Price of the third item                 |

### 2. `customers` Table:
Stores unique customer information.

| Column            | Data Type   | Description                             |
|-------------------|-------------|-----------------------------------------|
| customer_id       | INTEGER     | Unique identifier for the customer (Primary Key) |
| customer_phone    | VARCHAR(50) | Customer phone number                   |
| customer_email    | VARCHAR(100)| Customer email address (Unique)         |

### 3. `items` Table:
Contains the details of all distinct items purchased.

| Column            | Data Type   | Description                             |
|-------------------|-------------|-----------------------------------------|
| item_id           | INTEGER     | Unique identifier for the item (Primary Key) |
| name              | VARCHAR(100)| Name of the item                        |
| price             | NUMERIC     | Price of the item                       |

### 4. `orders` Table:
Records each distinct order placed.

| Column            | Data Type   | Description                             |
|-------------------|-------------|-----------------------------------------|
| order_id          | INTEGER     | Unique identifier for the order (Primary Key) |
| order_date        | DATE        | Date the order was placed               |
| customer_id       | INTEGER     | Foreign Key to the `customers` table    |

### 5. `orders_items` Table:
Maintains the many-to-many relationship between orders and items.

| Column            | Data Type   | Description                             |
|-------------------|-------------|-----------------------------------------|
| order_id          | INTEGER     | Foreign Key to the `orders` table       |
| item_id           | INTEGER     | Foreign Key to the `items` table        |

---

## Key SQL Queries

1. **Count Distinct Orders**:
   ```sql
   SELECT COUNT(DISTINCT order_id) AS orders_placed
   FROM store;
   ```

2. **Fetch Customer Information**:
   ```sql
   SELECT customer_id, customer_email, customer_phone
   FROM store
   WHERE customer_id = 1;
   ```

3. **Normalize Data into `customers` Table**:
   ```sql
   CREATE TABLE customers AS
   SELECT DISTINCT customer_id, customer_phone, customer_email
   FROM store;
   ```

4. **Create `orders_items` Table**:
   ```sql
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
   ```

5. **Get Total Orders for a Specific Item**:
   ```sql
   SELECT COUNT(o.order_id)
   FROM orders o
   JOIN orders_items oi ON o.order_id = oi.order_id
   JOIN items i ON oi.item_id = i.item_id
   WHERE i.name = 'chair'
   GROUP BY i.name;
   ```

---

## Skills Used

This project showcases several important skills relevant to database management, data analysis, and full-stack development. These include:

### 1. **SQL Database Design & Normalization**:
   - Designing normalized relational databases by organizing data across multiple tables (`customers`, `orders`, `items`, and `orders_items`).
   - Ensuring data integrity through the use of **foreign key constraints** and **primary keys**.

### 2. **SQL Query Optimization**:
   - Writing efficient queries using techniques such as:
     - **JOINs** for combining data from multiple tables.
     - **UNION** to merge data from different columns into normalized tables.
     - **GROUP BY** and **COUNT** for aggregating data insights.
     - **HAVING** to filter data after grouping.

### 3. **Data Manipulation**:
   - Using `INSERT`, `SELECT`, and `ALTER` statements to manage data in the tables.
   - Implementing `WITH` clauses to organize complex subqueries.

### 4. **Analytical SQL**:
   - Running **aggregate functions** to count distinct entries, measure sales per item, and analyze customer orders.

### 5. **Full-Stack Development (Database Layer)**:
   - Understanding how to design databases that support **back-end systems** and full-stack applications.
   - Knowledge of **database normalization** to ensure the system can scale efficiently and handle complex queries.

---

## Getting Started

1. Ensure you have access to a PostgreSQL environment (or another SQL database that supports these queries).
2. Run the provided SQL script in your database client.
3. Use the sample queries to interact with the database, analyze customer behavior, order details, and item sales.

---

## Future Improvements

1. **Further Normalization**: Items could be stored in a separate table from the start to further simplify the structure.
2. **Indexes**: Additional indexes can be created on frequent query fields to enhance performance.
3. **Scalability**: Implementing partitioning strategies for larger datasets.

---

## Conclusion

This project demonstrates the power of SQL in creating structured, normalized databases for e-commerce applications, along with various querying techniques to extract meaningful insights. The skills in database design, query optimization, and full-stack development are critical in creating scalable, maintainable systems.

SELECT *
FROM SuperstoreSalesDataset
LIMIT 5;
--------
SELECT COUNT(*) - COUNT(DISTINCT product_name) AS no_of_duplicates
FROM SuperstoreSalesDataset;
---------
SELECT *
FROM SuperstoreSalesDataset
WHERE Postal_Code IS NULL OR Postal_Code = '' 
   OR Sales IS NULL; --11 rows have null values
SELECT DISTINCT product_id from SuperstoreSalesDataset

---------
UPDATE SuperstoreSalesDataset
SET Postal_Code = '05401'
WHERE City = 'Burlington' 
  AND State = 'Vermont' 
  AND (Postal_Code IS NULL OR Postal_Code = '');
--------
SELECT *
FROM SuperstoreSalesDataset
WHERE Postal_Code IS NULL;
------
CREATE TABLE Cleaned_Superstore_Sales AS
SELECT *
FROM SuperstoreSalesDataset;
-----
SELECT *
FROM Cleaned_Superstore_Sales
where postal_code = NULL
---------
-- Remove extra spaces from the beginning and end of strings
UPDATE Cleaned_Superstore_Sales
SET City = TRIM(City),
    State = TRIM(State),
    Category = TRIM(Category);

-- Standardize capitalization (e.g., making everything uppercase for consistency)
UPDATE Cleaned_Superstore_Sales
SET "Ship_Mode" = UPPER("Ship_Mode");
--
CREATE table Unique_Sales_table AS
SELECT DISTINCT *
FROM SuperstoreSalesDataset;
--
SELECT * FROM Unique_Sales_View1
SELECT *

FROM Unique_Sales_View1
WHERE Postal_Code IS NULL OR Postal_Code = '' 
   OR Sales IS NULL;
   
-- Remove extra spaces from the beginning and end of strings
UPDATE Unique_Sales_table
SET City = TRIM(City),
    State = TRIM(State),
    Category = TRIM(Category);

-- Standardize capitalization (e.g., making everything uppercase for consistency)
UPDATE Unique_Sales_table
SET "Ship_Mode" = UPPER("Ship_Mode");

--
SELECT ship_mode from Unique_Sales_table

--
UPDATE Unique_Sales_table
SET "Order_Date" = SUBSTR("Order_Date", 7, 4) || '-' || 
                   SUBSTR("Order_Date", 4, 2) || '-' || 
                   SUBSTR("Order_Date", 1, 2);
                   
SELECT order_date from Unique_Sales_table

SELECT 
    "Order_ID", 
    "Order_Date", 
    "Ship_Date",
    CAST(julianday("Ship_Date") - julianday("Order_Date") AS INTEGER) AS Shipping_Days
FROM Unique_Sales_table;

UPDATE Unique_Sales_table
SET ship_date = SUBSTR(ship_date, 7, 4) || '-' || 
                SUBSTR(ship_date, 4, 2) || '-' || 
                SUBSTR(ship_date, 1, 2);

SELECT * from Unique_Sales_table

SELECT 
    order_id, 
    order_date, 
    ship_date,
    CAST(julianday(ship_date) - julianday(order_date) AS INTEGER) AS Shipping_Days
FROM Unique_Sales_table;

ALTER TABLE Unique_Sales_table
ADD COLUMN shipping_days INTEGER;

UPDATE Unique_Sales_table
SET shipping_days = CAST(julianday(ship_date) - julianday(order_date) AS INTEGER);

SELECT * from Unique_Sales_table
--------------------------------------
CREATE VIEW v_total_unique_customers AS
SELECT COUNT(DISTINCT customer_id) AS total_unique_customers
FROM Unique_Sales_table;
ALTER TABLE Unique_Sales_table ADD COLUMN overall_unique_customers INTEGER;

UPDATE Unique_Sales_table 
SET overall_unique_customers = (
  
  
ALTER TABLE Unique_Sales_table ADD COLUMN overall_unique_customers INTEGER;

UPDATE Unique_Sales_table 
SET overall_unique_customers = (
    SELECT COUNT(DISTINCT customer_id) 
    FROM Unique_Sales_table
);
SELECT overall_unique_customers from Unique_Sales_table
-------
ALTER TABLE Unique_Sales_table ADD COLUMN items_in_this_order INTEGER;

UPDATE Unique_Sales_table 
SET items_in_this_order = (
    SELECT COUNT(product_id) 
    FROM Unique_Sales_table t2 
    WHERE t2.order_id = Unique_Sales_table.order_id
);
SELECT items_in_this_order from Unique_Sales_table
ALTER TABLE Unique_Sales_table ADD COLUMN customer_total_orders INTEGER;

UPDATE Unique_Sales_table 
SET customer_total_orders = (
    SELECT COUNT(DISTINCT order_id) 
    FROM Unique_Sales_table t2 
    WHERE t2.customer_id = Unique_Sales_table.customer_id
);
--
ALTER TABLE Unique_Sales_table ADD COLUMN overall_total_sales REAL;

UPDATE Unique_Sales_table 
SET overall_total_sales = (
    SELECT SUM(sales) 
    FROM Unique_Sales_table
);
------
ALTER TABLE Unique_Sales_table ADD COLUMN category_total_orders INTEGER;

UPDATE Unique_Sales_table 
SET category_total_orders = (
    SELECT COUNT(product_id) 
    FROM Unique_Sales_table t2 
    WHERE t2.category = Unique_Sales_table.category
);
---------
ALTER TABLE Unique_Sales_table ADD COLUMN customer_lifetime_revenue REAL;

UPDATE Unique_Sales_table 
SET customer_lifetime_revenue = (
    SELECT SUM(sales) 
    FROM Unique_Sales_table t2 
    WHERE t2.customer_id = Unique_Sales_table.customer_id
);
SELECT * FROM Unique_Sales_table

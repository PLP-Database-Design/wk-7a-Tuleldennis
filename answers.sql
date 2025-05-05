QUESTION 1  


-- Step 1NF: Assuming a table like this exists
-- CREATE TABLE ProductDetail (
--   OrderID INT,
--   CustomerName VARCHAR(100),
--   Products VARCHAR(255)
-- );

-- 1NF Transformation (e.g., in MySQL 8+)
WITH split_products AS (
  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS Product
  FROM ProductDetail
  JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  ) numbers ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
)
SELECT * FROM split_products;




QUESTION 2



-- Step 1: Create a separate Customers table
CREATE TABLE Customers (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(100)
);

-- Step 2: Create the new OrderItems table with full dependency
CREATE TABLE OrderItems (
  OrderID INT,
  Product VARCHAR(100),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

-- Step 3: Populate Customers table
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 4: Populate OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

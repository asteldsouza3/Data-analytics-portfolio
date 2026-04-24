CREATE DATABASE retail_sales ;
USE retail_sales ;

CREATE TABLE sales (
    order_ID VARCHAR(20),
    order_Date VARCHAR(50),
    customer_Name VARCHAR(100),
    age INT,
    quantity INT,
    price DECIMAL(10,2) ,
    discount INT(5),
    order_Status CHAR(50),
    total_Sales DECIMAL(12,2),
    region VARCHAR(50),
    cateogry VARCHAR (50),
	gender VARCHAR (50) ,
    month_name varchar(30)
);

-- What is the total revenue generated?
SELECT SUM(total_sales) AS total_sales
FROM sales
WHERE order_status = "Delivered";

-- How many orders were placed?
SELECT SUM(quantity) AS total_quantity
FROM sales
WHERE order_status = "Delivered";

-- What is the Average Order Value (AOV)?
SELECT ROUND(SUM(total_sales)/SUM(quantity),2) AS AOV
FROM sales
WHERE order_status = "Delivered"; 

-- Which product category generates the highest revenue?
SELECT cateogry,
	   SUM(total_sales) AS revenue
FROM sales
WHERE order_status = "Delivered"
GROUP BY cateogry 
ORDER BY revenue DESC;

-- Which regions perform the best?
SELECT region,
	   SUM(total_sales) AS revenue
FROM sales
WHERE order_status = "Delivered" 
GROUP BY region
ORDER BY revenue DESC;

-- What is the monthly sales trend?
SELECT MONTH(order_date) AS month_no,
	   MONTHNAME(order_date) AS month,
       SUM(total_sales) AS revenue
FROM sales
WHERE order_status = "Delivered"
GROUP BY month_no,month
ORDER BY month_no 
;

--  What is the Month-over-Month (MoM) growth?
WITH monthly_sales AS (
    SELECT 
        MONTH(order_date) AS month_no,
        MONTHNAME(order_date) AS month,
        SUM(Total_Sales) AS revenue
    FROM sales
    WHERE order_status = "Delivered"
    AND order_date IS NOT NULL
    GROUP BY month_no, month
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month_no) AS prev_month,

    ROUND(
	    (revenue-LAG(revenue) OVER (ORDER BY  month_no )) /
        LAG(revenue) OVER (ORDER BY month_no)* 100,2
    ) AS MOM
FROM monthly_sales
ORDER BY month_no;

-- Which  product category are underperforming?
SELECT cateogry,
	   SUM(total_sales) AS revenue
FROM sales 
WHERE order_status = "Delivered"
GROUP BY cateogry
ORDER BY revenue ;

-- What are the top 2 selling product category?
SELECT cateogry,
       SUM(total_sales) AS revenue
FROM sales
WHERE order_status = "Delivered"
GROUP BY cateogry
ORDER BY revenue DESC
LIMIT 2 ;


-- WHhat is the monthy trend?
SELECT 
    MONTH(order_date) AS month_no,
    MONTHNAME(order_date) AS month_name,
    SUM(total_sales) AS revenue
FROM sales
GROUP BY 
    MONTH(order_date), 
    MONTHNAME(order_date)
ORDER BY 
    MONTH(order_date);



-- KEY INSIGHTS

-- Regional sales vary, with some regions underperforming
-- Electronics is the top-performing category

-- RECOMMENDATIONS

-- Strengthen marketing efforts in underperforming regions such as South and North
-- Increase AOV by promoting premium products to drive higher-value purchases
-- OLIST E-COMMERCE BUSINESS ANALYSIS


-- 1. SALES PERFORMANCE

-- 1.1 Monthly Delivered-Order Sales
SELECT 
	DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS order_volume,
    SUM(i.price) AS revenue
FROM olist_orders AS o 
JOIN olist_order_items AS i
	ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month DESC ;

-- 1.2 Average Order Value (AOV)
SELECT 
	DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS order_volume,
    SUM(i.price) AS revenue,
    ROUND(SUM(i.price)/  COUNT(DISTINCT o.order_id),2) AS AOV 
FROM olist_orders AS o 
JOIN olist_order_items AS i
	ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month DESC ;

-- 2. CATEGORY PERFORMANCE


-- 2.1 Category Revenue and Order Volume
SELECT COALESCE(t.product_category_name_english ,'Unknown') AS category,
	COUNT(DISTINCT o.order_id) AS order_volume,
	SUM(i.price) AS revenue ,
    ROUND(SUM(i.price)/COUNT(DISTINCT o.order_id),2) AS AOV 
FROM olist_orders AS o 
JOIN olist_order_items AS i 
	ON o.order_id = i.order_id
JOIN olist_products AS p 
	ON p.product_id = i.product_id 
LEFT JOIN product_category_translation AS t 
	ON t.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC;

-- 2.2 Category Revenue Contribution
SELECT COALESCE(t.product_category_name_english,'Unknown') AS category,
	SUM(i.price) AS revenue ,
    ROUND(SUM(i.price)*100.0 / SUM(SUM(i.price))OVER() ,2) AS revenue_pct
FROM olist_orders AS o 
JOIN olist_order_items AS i 
	ON o.order_id = i.order_id 
JOIN olist_products AS p 
	ON i.product_id = p.product_id 
LEFT JOIN product_category_translation AS t 
	ON t.product_category_name = p.product_category_name 
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC ;


-- 3. CUSTOMER ANALYSIS

-- 3.1 One-Time vs Repeat Customers
SELECT 
	CASE 
    WHEN customer_order_count = 1 THEN 'One-time Customer'
    ELSE 'Repeat Customer'
	END AS customer_type , 
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0/ SUM(COUNT(*)) OVER() ,2) AS customer_percentage
FROM(
SELECT c.customer_unique_id , COUNT(DISTINCT o.order_id) AS customer_order_count
FROM olist_customers AS c 
JOIN olist_orders AS o 
	ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id ) customer_orders

GROUP BY customer_type
ORDER BY customer_count DESC 
;


-- 3.2 Sales Contribution: One-Time vs Repeat Customers
SELECT 
	CASE 
    WHEN customer_order_count = 1 THEN 'One-time Customer'
    ELSE 'Repeat Customer'
    END AS customer_type , 
COUNT(DISTINCT customer_unique_id) AS customer_count , 
ROUND(SUM(customer_revenue),2) AS revenue, 
ROUND(SUM(customer_revenue) * 100.0 / SUM(SUM(customer_revenue)) OVER () ,2)AS revenue_percentage
FROM (
SELECT c.customer_unique_id , COUNT(DISTINCT o.order_id) AS customer_order_count, SUM(i.price) AS customer_revenue
FROM olist_customers AS c 
JOIN olist_orders AS o 
	ON c.customer_id = o.customer_id
JOIN olist_order_items AS i 
	ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id) AS customer_data

GROUP BY customer_type
ORDER BY revenue DESC;


-- 3.3 Customer Revenue Concentration
WITH customer_revenue AS(
SELECT c.customer_unique_id , SUM(i.price) AS revenue
FROM olist_customers AS C 
JOIN olist_orders AS o 
	ON c.customer_id = o.customer_id
JOIN olist_order_items AS i 
	ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id
),

ranked_customers AS (
SELECT customer_unique_id ,
 revenue , 
 ROW_NUMBER() OVER(ORDER BY revenue DESC ) AS customer_rank , 
 COUNT(*)OVER() AS total_customers
FROM customer_revenue
)

(SELECT 
	CASE 
		WHEN customer_rank <= total_customers *0.01 
			THEN 'Top 1%'
		WHEN customer_rank <= total_customers *0.05
			THEN 'Top 5%'
		WHEN customer_rank <= total_customers *0.10
			THEN 'Top 10%'
		ELSE 'Remaining 90%'
    END AS customer_segment , 
COUNT(*) AS customer_count , 
ROUND(SUM(revenue),2) AS revenue,
ROUND(SUM(revenue) *100.0 / SUM(SUM(revenue)) OVER(),2) AS revenue_percentage
FROM ranked_customers 
GROUP BY customer_segment);


-- 4. DELIVERY & CUSTOMER EXPERIENCE

-- 4.1 Delivery Performance by Customer State
SELECT c.customer_state , 
COUNT(DISTINCT o.order_id) AS delivered_orders,
ROUND(AVG(DATEDIFF(o.order_delivered_customer_date , o.order_purchase_timestamp)),2) AS avg_delivery_days
FROM olist_orders AS o 
JOIN olist_customers AS c 
	ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL 
GROUP BY customer_state
ORDER BY avg_delivery_days DESC;


-- 4.2 Delivery Status vs Review Score
SELECT 
	CASE 
		WHEN DATEDIFF(o.order_delivered_customer_date , order_estimated_delivery_date) > 0 
			THEN 'Late'
		ELSE 'On-Time/Early'
	END AS delivery_status ,
COUNT(DISTINCT o.order_id) AS order_count,
ROUND(AVG(r.review_score),2) AS average_review_score
FROM olist_orders AS o
JOIN olist_order_reviews AS r 
	ON o.order_id = r.order_id
WHERE o.order_status ='delivered'
AND o.order_delivered_customer_date IS NOT NULL  
AND o.order_estimated_delivery_date IS NOT NULL 
GROUP BY delivery_status
ORDER BY delivery_status;


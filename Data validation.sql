SELECT *
FROM olist_orders;

SELECT 
	COUNT(*),
    COUNT(DISTINCT order_id ),
    COUNT(DISTINCT customer_id )
FROM olist_orders;

SELECT COUNT(*)
FROM olist_orders AS o 
LEFT JOIN olist_customers AS c 
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(DISTINCT o.order_id)
FROM olist_orders AS o 
LEFT JOIN olist_order_items AS i 
ON o.order_id = i.order_id
WHERE i.order_id IS NULL;

SELECT o.order_status , COUNT(*)
FROM olist_orders AS o 
LEFT JOIN olist_order_items AS i 
ON o.order_id = i.order_id
WHERE i.order_id IS NULL 
GROUP BY o.order_status
ORDER BY COUNT(*) DESC ;

SELECT COUNT(*)
FROM olist_order_items AS i 
LEFT JOIN olist_products AS p 
ON i.product_id = p.product_id
WHERE p.product_id IS NULL ;

SELECT COUNT(*)
FROM olist_order_items AS i 
LEFT JOIN olist_sellers AS s 
ON i.seller_id=s.seller_id
WHERE s.seller_id IS NULL ;

SELECT COUNT(DISTINCT o.order_id)
FROM olist_orders AS o 
LEFT JOIN olist_order_payments AS p 
ON o.order_id = p.order_id
WHERE p.order_id IS NULL ;

SELECT o.order_id ,order_status, o.order_purchase_timestamp
FROM olist_orders AS o 
LEFT JOIN olist_order_payments AS p 
ON o.order_id = p.order_id
WHERE p.order_id IS NULL ;

SELECT *
FROM olist_order_items 
WHERE order_id = 'bfbd0f9bdef84302105ad712db648a6c';

SELECT *
FROM olist_order_reviews
WHERE order_id = 'bfbd0f9bdef84302105ad712db648a6c';

SELECT COUNT(*)
FROM olist_order_reviews AS r
LEFT JOIN olist_orders AS o
ON r.order_id = o.order_id 
WHERE o.order_id IS NULL ;

SELECT MIN(order_purchase_timestamp) , MAX(order_purchase_timestamp)
FROM olist_orders;
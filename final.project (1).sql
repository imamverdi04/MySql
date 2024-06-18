SELECT
    p.payment_type,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)) AS average_delivery_days
FROM
    final_project.olist_orders_dataset AS o
JOIN
    final_project.olist_order_payments_dataset AS p
ON
    o.order_id = p.order_id
WHERE
    o.order_delivered_customer_date IS NOT NULL
    AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    p.payment_type
ORDER BY
    average_delivery_days ASC
LIMIT 1;
 SELECT
    s.customer_state AS state,
    FORMAT(MAX(p.payment_value), 1) AS max_payment_revenue
FROM
    final_project.olist_orders_dataset AS o
JOIN
    final_project.olist_order_payments_dataset AS p
ON
 o.order_id = p.order_id
JOIN
    final_project.olist_customers_dataset AS s
ON
    o.customer_id = s.customer_id
WHERE
    o.order_status NOT IN ('unavailable', 'canceled')
GROUP BY
    s.customer_state;
 WITH order_counts AS (
    SELECT
        order_id,
        COUNT(*) OVER (PARTITION BY order_id) AS order_count
    FROM
        final_project.olist_order_payments_dataset
)
SELECT
    COUNT(DISTINCT order_id) AS distinct_order_ids_more_than_once
FROM
    order_counts
WHERE
    order_count > 1;
SELECT *
FROM (
    SELECT
        *,
        LAG(payment_value) OVER (
            PARTITION BY order_id 
            ORDER BY payment_sequential
        ) AS previous_payment_value,
        LEAD(payment_value) OVER (
            PARTITION BY order_id 
            ORDER BY payment_sequential
        ) AS leading_payment_value
    FROM
        final_project.olist_order_payments_dataset
) AS subquery
WHERE
    previous_payment_value IS NOT NULL AND
    leading_payment_value IS NOT NULL;

 SELECT 
c.*,
o.order_id,
 DATE(o.order_purchase_timestamp) AS order_purchase_date,
 p.payment_value,
  CAST(p.payment_value AS UNSIGNED) AS payment_value_int
 FROM final_project.olist_customers_dataset c
 left join  olist_orders_dataset o on c.customer_id=o.customer_id
 left join olist_order_payments_dataset p on  p.order_id=o.order_id;

 SELECT 
order_id,
payment_sequential,
CASE
        WHEN payment_type = 'not_defined' THEN 0
        WHEN payment_type = 'credit_card' THEN 1
        WHEN payment_type = 'voucher' THEN 2
        WHEN payment_type = 'debit_card' THEN 3
        WHEN payment_type = 'boleto' THEN 4
        ELSE NULL  -- Handle other cases if needed
    END AS payment_method,
    payment_installments,
    payment_value
FROM final_project.olist_order_payments_dataset;



WITH RECURSIVE numbers AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num + 1
    FROM numbers
    WHERE num < 100 -- Assumption: no movie name has more than 100 words
),
split_words AS (
    SELECT
        SUBSTRING_INDEX(SUBSTRING_INDEX(movie_name, ' ', num), ' ', -1) AS word
    FROM
       final_project.netflix movie - netflix_dataset_movie,
        numbers
    WHERE
        num <= CHAR_LENGTH(movie_name) - CHAR_LENGTH(REPLACE(movie_name, ' ', '')) + 1
)
SELECT
    word AS words_used_in_movie_names,
    COUNT(*) AS number_of_occurrence
FROM split_words
GROUP BY word
ORDER BY number_of_occurrence DESC, word;
 sELECT
    CASE
        WHEN movie_name LIKE '%Vol. 1%' THEN REPLACE(movie_name, 'Vol. 1', 'Part 1')
        WHEN movie_name LIKE '%Vol. 2%' THEN REPLACE(movie_name, 'Vol. 2', 'Part 2')
        ELSE movie_name
    END AS movie_name
FROM
    final_project.'netflix movie - netflix_dataset_movie'
 WITH movie_years AS (
    SELECT
        movie_id,
        movie_name,
        year,
        LAG(year) OVER (PARTITION BY movie_name ORDER BY year) AS previous_year
    FROM
     final_project.netflix movie - netflix_dataset_movie
  
  
)
SELECT
    movie_id,
    movie_name,
    year,
    previous_year
FROM
    movie_years
WHERE
    previous_year IS NOT NULL;
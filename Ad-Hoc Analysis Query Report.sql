-- BUSINESS QUESTIONS

-- Query One
-- Products with base price greater than 500 and 
-- that are featured in the promo type BOGOF(Buy One Get One Free)
SELECT DISTINCT(f.product_code), product_name, base_price, promo_type
FROM fact_events f
JOIN dim_products d ON d.product_code = f.product_code
WHERE base_price > 500 and promo_type = 'BOGOF';


-- Query Two
-- Number of stores in each city
SELECT city AS City, COUNT(store_id) AS Store_Count 
FROM dim_stores
GROUP BY City
ORDER BY Store_Count DESC;


-- Query Three
-- Total Revenue by Campaign before and after promotion
SELECT campaign_Name AS Campaign, 
	CONCAT(ROUND(SUM(base_price * quantity_sold_before_promo)/1000000, 2), ' M') as Revenue_before_promotion,
	REPLACE(CONCAT(ROUND(SUM(
		CASE
			WHEN promo_type = 'BOGOF' THEN ((base_price * 0.5) * quantity_sold_after_promo) * 2
			WHEN promo_type = '50% OFF' THEN (base_price * 0.5) * quantity_sold_after_promo
			WHEN promo_type = '25% OFF' THEN (base_price * 0.75) * quantity_sold_after_promo
			WHEN promo_type = '33% OFF' THEN (base_price * 0.67) * quantity_sold_after_promo
			WHEN promo_type = '500 Cashback' THEN (base_price - 500) * quantity_sold_after_promo
		END)/1000000, 2), ' M'), 0, '') AS Revenue_after_promotion
FROM fact_events f
JOIN dim_campaigns d ON d.campaign_id = f.campaign_id
GROUP BY campaign_Name


--Query Four
--Incremental Sold Quantity (ISU) for each category sold during the Diwali campaign
-- Rank by ISU%
WITH category_sale AS(
SELECT category,
	ROUND(SUM(
		CASE
		WHEN promo_type = 'BOGOF' THEN quantity_sold_after_promo * 2
		ELSE quantity_sold_after_promo
		END - quantity_sold_before_promo) * 100 
		/ SUM(quantity_sold_before_promo), 2) AS ISU_percent
FROM fact_events f
JOIN dim_campaigns c ON c.campaign_id = f.campaign_id
JOIN dim_products p ON p.product_code = f.product_code
WHERE campaign_Name = 'Diwali'
GROUP BY category
)
SELECT category, ISU_percent,
	RANK() OVER(ORDER BY ISU_percent DESC) AS category_rank
FROM category_sale	


-- Query Five
-- Top 5 Products ranked by Inremental Revenue Percentage (IR%) across all campaigns
-- Product name, category and IR%
SELECT TOP 5 product_name, category,
	ROUND(SUM(
		CASE
			WHEN promo_type = 'BOGOF' THEN (base_price * 0.5) * quantity_sold_after_promo * 2
			WHEN promo_type = '50% OFF' THEN (base_price * 0.5) * quantity_sold_after_promo
			WHEN promo_type = '25% OFF' THEN (base_price * 0.75) * quantity_sold_after_promo
			WHEN promo_type = '33% OFF' THEN (base_price * 0.67) * quantity_sold_after_promo
			WHEN promo_type = '500 Cashback' THEN (base_price - 500) * quantity_sold_after_promo
			ELSE 0
			END 
			- base_price * quantity_sold_before_promo)
			/ SUM(base_price * quantity_sold_before_promo) * 100, 2) AS IR_PCT
FROM fact_events f
JOIN dim_products p ON p.product_code = f.product_code
GROUP BY product_name, category
ORDER BY IR_PCT DESC
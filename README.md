# 📊 Atliq Mart - Ad-Hoc Analysis

## Table of Contents
1. [Overview](#overview)
2. [Data Source](#data-source)
3. [Tools](#tools)
4. [Business Requests](#business-requests)
   - [More Business Requests](#more-business-requests)
6. [Key Insights](#key-insights)
   - [Product and Category Analysis](#1-product-and-category-analysis)
   - [Store Performance Analysis](#2-store-performance-analysis)
   - [Promotion Type Analysis](#3-promotion-type-analysis)
7. [Recommendations](#recommendations)
8. [Visualization](#visualization)
9. [Conclusion](#conclusion)
10. [Contributing](#conclusion)

---

## Overview

This project provides a detailed analysis of a fictitious company, `Atliq Mart`. 
It analyses its **Product Categories**, **Promotional Effectiveness**, and **Store Performance** based on sales data. 
The analysis aims to uncover key insights into how different categories and stores have performed, which promotional types are most effective, 
and how various cities and stores contribute to overall sales and revenue growth.

The analysis is divided into three main sections:
1. **Product and Category Analysis**
2. **Store Performance Analysis**
3. **Promotion Type Analysis**

## Data Source
The data for this analysis is sourced from Atliq Mart's database.

---

## Tools
- `SQL` - Data Analysis
- `Power BI` - Visualization

---

## Business Requests

The analysis provides answers to the following critical business questions using SQL:

1. Provide a list of products with a base price greater than 500 and that are featured in the promo type BOGOF(Buy One Get One Free):
   ```sql
   SELECT DISTINCT(f.product_code), product_name, base_price, promo_type
   FROM fact_events f
   JOIN dim_products d ON d.product_code = f.product_code
   WHERE base_price > 500 and promo_type = 'BOGOF';
   ```
![Products featured in BOGOF promo](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/query%201.png)
   
2. Generate a report that provides an overview of the number of stores in each city:
   ```sql
   SELECT city AS City, COUNT(store_id) AS Store_Count 
   FROM dim_stores
   GROUP BY City
   ORDER BY Store_Count DESC;
   ```
![Overview of Stores per City](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/query%202.png)
   
3. Generate a report that displays each campaign along with the total revenue generated before and after the campaign:
   ```sql
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
   GROUP BY campaign_Name;
   ```
![Revenue per Campaign](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/query%203.png)
   
4. Produce a report that calculates the Incremental Sold Quantity (ISU) for each category sold during the Diwali campaign.
Additionally, provide rankings for the categories based on their ISU%:
  ```sql
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
  FROM category_sale;
```
![ISU per Category during Diwali Campaign](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/query%204.png)

5. Create a report featuring the top 5 products ranked by Incremental Revenue Percentage (IR%) across all campaigns:
  ```sql
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
  ORDER BY IR_PCT DESC;
  ```
![Top 5 Products by IR%](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/query%205.png)

---

### More Business Requests

1. Which product categories benefitted most from promotions?   
2. Which stores performed best during the promotional period in terms of revenue and sold units?
3. Which promotion types are most effective?   
4. Which cities contribute the most to sales and revenue growth?
5. How did the promotions impact overall revenue and sales volume?
7. What was the effectiveness of specific promotions on different product categories?
8. Are there any stores lagging in sold units despite strong revenue growth?
9. Which promotions should be reconsidered based on their performance in terms of incremental sold units?

---
   
## Key Insights

### 1. Product and Category Analysis

#### 📈 **Revenue and Sales Growth**
- **Revenue Before Promotion:** 12M  
- **Revenue After Promotion:** 25.86M  
- **Incremental Revenue (IR):** 13.63M (111.35% increase)
- **Incremental Sold Units (ISU):** 223.68%

#### 🛒 **Category Performance**
- **Top Performers:**
  - **Home Appliances**: 261.85% IR growth
  - **Home Care**: 180.84% IR growth
- **Moderate Growth:**
  - **Combo1**: 133.52% IR growth
  - **Grocery & Staples**: 52.54% IR growth
- **Underperformers:**
  - **Personal Care**: 31.16% IR growth

#### 🎯 **Promotion Effectiveness**
- Promotions like **BOGOF** (Buy One Get One Free) and **500 Cashback** were highly effective, especially for categories like **Grocery & Staples** and **Home Appliances**.
- Percentage-based promotions (**25% OFF**, **50% OFF**) were less impactful in driving incremental sold units.

---

### 2. Store Performance Analysis

#### 🏬 **Sales Impact Across Stores**
- **Units Sold Before Promotion:** 209K  
- **Units Sold After Promotion:** 651K  
- **Revenue Before Promotion:** 141M  
- **Revenue After Promotion:** 295.61M  
- **Incremental Revenue (IR):** 154.91M

#### 🌍 **Store Performance by City**
- **Top-Contributing Cities:**
  - **Bengaluru**: 38.21M IR with 10 stores
  - **Chennai**: 30.71M IR with 6 stores
  - **Hyderabad**: 24.77M IR with 5 stores

#### 🏅 **Top Performing Stores by IR%:**
- **STMS-1**, **STCHE-6**, and **STBLR-0** were the top-performing stores in terms of incremental revenue.
  
#### 📉 **Underperforming Stores by ISU%:**
- Stores like **STMS-1** and **STBLR-1** showed high revenue but lagged in sold units, indicating potential issues with pricing or product selection.

---

### 3. Promotion Type Analysis

#### 🏷️ **Promotion Performance**
- **Top Performing Promotions:**
  - **BOGOF**: 267.35% IR increase and 639.96% ISU increase
  - **500 Cashback**: 136.11% IR increase
- **Underperforming Promotions:**
  - **50% OFF**: 32.63% ISU growth
  - **25% OFF**: -12.99% ISU decline

#### 📊 **Promotion Balance Performance**
- Discount-based promotions, especially **25% OFF**, performed poorly compared to cashback and BOGOF promotions.

---

## 📌 Recommendations

1. **Promote High-Growth Categories:** Focus on high-performing categories such as **Home Appliances** and **Home Care** with targeted promotions.
2. **Optimize Promotion Strategy:** Continue leveraging **BOGOF** and **Cashback** offers, while limiting the use of percentage-based discounts, which have shown lower effectiveness.
3. **City-Specific Promotions:** Tailor campaigns for cities like **Bengaluru**, **Chennai**, and **Hyderabad** to drive higher incremental revenue.
4. **Store Performance Improvement:** Investigate underperforming stores, especially those with low ISU%, and implement corrective actions to boost performance.
5. **Replicate Success Strategies:** Use top-performing stores as benchmarks for underperforming ones.
6. **Test New Promotion Types:** Explore other value-based promotions like bundling or loyalty rewards.

---

## Visualization
Explore the live interactive dashboard here:
  - [View Power BI Dashboard](https://app.powerbi.com/view?r=eyJrIjoiNGQ2ZjMwNTUtMTZkZi00NjdhLThlZjktMmZkNGQ3MDkwN2VhIiwidCI6ImFhMjRiYzRmLWJjMTQtNDcyNS04ZDM4LTVmNjQ0NmE5OGUyYyJ9&pageName=ReportSection26d1290a14ab2613e9f1)

---

## Conclusion

This analysis highlights the impact of different promotional strategies, the performance of product categories, and the contributions of specific stores and cities. 
By focusing on high-performing stores, optimizing promotion types, and targeting key cities, Atliq Mart can enhance future promotional campaigns and improve overall business performance.

---

## Contributing

Contributions to this project are welcome! Please open an issue to discuss any major changes or suggestions.

---

## Screenshots

**Product and Category Analysis Dashboard**  
![Product and Category Analysis](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/Product_analysis.png)

**Store Performance Analysis Dashboard**  
![Store Performance Analysis](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/Store_performance_analysis.png)

**Promotion Type Analysis Dashboard**  
![Promotion Type Analysis](https://github.com/ajlkau68/Ad-Hoc-Insights/blob/main/images/Promo_type_analysis.png)

---

**Schema (MySQL v9)**

    CREATE TABLE sales (
        region VARCHAR(50),
        subregion VARCHAR(50),
        market VARCHAR(50),
        customer VARCHAR(120),
        business_segment VARCHAR(40),
        category VARCHAR(60),
        model VARCHAR(60),
        color VARCHAR(30),
        salesdate DATE,
        order_year INT,
        order_month INT,
        listprice DECIMAL(10, 2),
        unitprice DECIMAL(10, 2),
        orderqty INT,
        revenue DECIMAL(12, 2),
        list_revenue DECIMAL(12, 2),
        discount_value DECIMAL(12, 2),
        discount_pct DECIMAL(6, 2)
    );
    
    INSERT INTO sales (
        region, subregion, market, customer, business_segment,
        category, model, color, salesdate, order_year, order_month,
        listprice, unitprice, orderqty, revenue, list_revenue,
        discount_value, discount_pct
    )
    VALUES
        ('North America', 'United States', 'Southeast', 'Trusted Catalog Store', 'Bikes', 'Mountain Bikes', 'Mountain-100', 'Silver', '2018-11-10', 2018, 11, 3399.99, 2039.99, 3, 6119.97, 10199.97, 4080.00, 40.00),
        ('North America', 'United States', 'Southeast', 'Trusted Catalog Store', 'Bikes', 'Mountain Bikes', 'Mountain-100', 'Black', '2019-02-25', 2019, 2, 3374.99, 2024.99, 2, 4049.98, 6749.98, 2700.00, 40.00),
        ('North America', 'United States', 'Southeast', 'Trusted Catalog Store', 'Clothing', 'Socks', 'Mountain Bike Socks', 'White', '2020-05-21', 2020, 5, 9.50, 5.70, 8, 45.60, 76.00, 30.40, 40.00);

---

**Query #1**

    -- 01. Business Segment Summary (Orders, Units, Revenue & Discount %)
    SELECT
        business_segment,
        COUNT(*) AS total_orders,
        SUM(orderqty) AS total_units,
        ROUND(SUM(revenue), 2) AS total_revenue,
        ROUND(AVG(discount_pct), 2) AS avg_discount_pct,
        ROUND(100.0 * SUM(revenue) / SUM(SUM(revenue)) OVER (), 2) AS revenue_share_pct
    FROM sales
    GROUP BY business_segment
    ORDER BY total_revenue DESC;

| business_segment | total_orders | total_units | total_revenue | avg_discount_pct | revenue_share_pct |
| ---------------- | ------------ | ----------- | ------------- | ---------------- | ----------------- |
| Bikes            | 2            | 5           | 10169.95      | 40.0             | 99.55             |
| Clothing         | 1            | 8           | 45.6          | 40.0             | 0.45              |

---
**Query #2**

    -- 02. Geographic & Market Performance (with Weighted Discount %)
    SELECT
        region,
        subregion,
        market,
        COUNT(*) AS total_orders,
        SUM(orderqty) AS total_units,
        ROUND(SUM(revenue), 2) AS total_revenue,
        ROUND(SUM(discount_value), 2) AS total_discount_val,
        ROUND(SUM(list_revenue), 2) AS total_list_rev,
        ROUND(100.0 * SUM(discount_value) / NULLIF(SUM(list_revenue), 0), 2) AS weighted_disc_pct
    FROM sales
    GROUP BY region, subregion, market
    ORDER BY total_revenue DESC;

| region        | subregion     | market    | total_orders | total_units | total_revenue | total_discount_val | total_list_rev | weighted_disc_pct |
| ------------- | ------------- | --------- | ------------ | ----------- | ------------- | ------------------ | -------------- | ----------------- |
| North America | United States | Southeast | 3            | 13          | 10215.55      | 6810.4             | 17025.95       | 40.0              |

---
**Query #3**

    -- 03. Annual Revenue & Year-over-Year Growth
    WITH yearly_sales AS (
        SELECT
            order_year,
            COUNT(*) AS total_orders,
            SUM(orderqty) AS total_units,
            ROUND(SUM(revenue), 2) AS total_revenue
        FROM sales
        GROUP BY order_year
    )
    SELECT
        order_year,
        total_orders,
        total_units,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY order_year) AS prev_year_revenue,
        ROUND(
            100.0 * (total_revenue - LAG(total_revenue) OVER (ORDER BY order_year))
            / NULLIF(LAG(total_revenue) OVER (ORDER BY order_year), 0),
            2
        ) AS yoy_growth_pct
    FROM yearly_sales
    ORDER BY order_year;

| order_year | total_orders | total_units | total_revenue | prev_year_revenue | yoy_growth_pct |
| ---------- | ------------ | ----------- | ------------- | ----------------- | -------------- |
| 2018       | 1            | 3           | 6119.97       |                   |                |
| 2019       | 1            | 2           | 4049.98       | 6119.97           | -33.82         |
| 2020       | 1            | 8           | 45.6          | 4049.98           | -98.87         |

---
**Query #4**

    -- 04. Monthly Sales Seasonality Across All Years
    SELECT
        order_month,
        COUNT(*) AS total_orders,
        SUM(orderqty) AS total_units,
        ROUND(SUM(revenue), 2) AS total_revenue,
        ROUND(AVG(revenue), 2) AS avg_order_revenue,
        ROUND(AVG(discount_pct), 2) AS avg_discount_pct
    FROM sales
    GROUP BY order_month
    ORDER BY order_month;

| order_month | total_orders | total_units | total_revenue | avg_order_revenue | avg_discount_pct |
| ----------- | ------------ | ----------- | ------------- | ----------------- | ---------------- |
| 2           | 1            | 2           | 4049.98       | 4049.98           | 40.0             |
| 5           | 1            | 8           | 45.6          | 45.6              | 40.0             |
| 11          | 1            | 3           | 6119.97       | 6119.97           | 40.0             |

---
**Query #5**

    -- 05. Top 3 Product Categories Inside Each Business Segment
    WITH category_totals AS (
        SELECT
            business_segment,
            category,
            COUNT(*) AS total_orders,
            SUM(orderqty) AS total_units,
            ROUND(SUM(revenue), 2) AS total_revenue
        FROM sales
        GROUP BY business_segment, category
    ),
    ranked_categories AS (
        SELECT
            *,
            DENSE_RANK() OVER (
                PARTITION BY business_segment
                ORDER BY total_revenue DESC
            ) AS rank_in_segment
        FROM category_totals
    )
    SELECT
        business_segment,
        rank_in_segment,
        category,
        total_orders,
        total_units,
        total_revenue
    FROM ranked_categories
    WHERE rank_in_segment <= 3
    ORDER BY business_segment, rank_in_segment;

| business_segment | rank_in_segment | category       | total_orders | total_units | total_revenue |
| ---------------- | --------------- | -------------- | ------------ | ----------- | ------------- |
| Bikes            | 1               | Mountain Bikes | 2            | 5           | 10169.95      |
| Clothing         | 1               | Socks          | 1            | 8           | 45.6          |

---
**Query #6**

    -- 06. Top 15 Customers & Cumulative Revenue Share (Pareto)
    WITH customer_rev AS (
        SELECT
            customer,
            COUNT(*) AS orders,
            SUM(orderqty) AS units,
            SUM(revenue) AS total_revenue
        FROM sales
        GROUP BY customer
    )
    SELECT
        customer,
        orders,
        units,
        ROUND(total_revenue, 2) AS total_revenue,
        ROUND(
            100.0 * SUM(total_revenue) OVER (ORDER BY total_revenue DESC)
            / SUM(total_revenue) OVER (),
            2
        ) AS cumulative_revenue_pct
    FROM customer_rev
    ORDER BY total_revenue DESC
    LIMIT 15;

| customer              | orders | units | total_revenue | cumulative_revenue_pct |
| --------------------- | ------ | ----- | ------------- | ---------------------- |
| Trusted Catalog Store | 3      | 13    | 10215.55      | 100.0                  |

---
**Query #7**

    -- 07. Revenue & Order Volume by Discount Bracket
    SELECT
        CASE
            WHEN discount_pct <= 40 THEN 'Up to 40%'
            WHEN discount_pct <= 50 THEN '40% to 50%'
            ELSE 'Over 50%'
        END AS discount_bracket,
        COUNT(*) AS total_orders,
        SUM(orderqty) AS total_units,
        ROUND(AVG(orderqty), 2) AS avg_units_per_order,
        ROUND(SUM(revenue), 2) AS total_revenue,
        ROUND(SUM(discount_value), 2) AS total_discount_given
    FROM sales
    GROUP BY discount_bracket
    ORDER BY total_revenue DESC;

| discount_bracket | total_orders | total_units | avg_units_per_order | total_revenue | total_discount_given |
| ---------------- | ------------ | ----------- | ------------------- | ------------- | -------------------- |
| Up to 40%        | 3            | 13          | 4.33                | 10215.55      | 6810.4               |

---
**Query #8**

    -- 08. Top 15 Customers by Revenue with First & Last Order Dates
    SELECT
        customer,
        MIN(salesdate) AS first_order_date,
        MAX(salesdate) AS last_order_date,
        COUNT(*) AS total_orders,
        SUM(orderqty) AS total_units,
        ROUND(SUM(revenue), 2) AS total_revenue,
        ROUND(AVG(revenue), 2) AS avg_order_value
    FROM sales
    GROUP BY customer
    ORDER BY total_revenue DESC
    LIMIT 15;

| customer              | first_order_date | last_order_date | total_orders | total_units | total_revenue | avg_order_value |
| --------------------- | ---------------- | --------------- | ------------ | ----------- | ------------- | --------------- |
| Trusted Catalog Store | 2018-11-10       | 2020-05-21      | 3            | 13          | 10215.55      | 3405.18         |

---

[View on DB Fiddle](https://www.db-fiddle.com/f/8Rd63JMTSwgVLX6rBrVfLg/0)

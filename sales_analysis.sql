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

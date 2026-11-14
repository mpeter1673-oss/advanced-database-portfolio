-- ==========================================================
-- MIT 8103: Advanced Database Systems - Portfolio 2
-- Query Processing, Execution Plans, and Indexing Optimisation
-- Student: Peter Mercy (301901673)
-- ==========================================================

-- 1. Analytical Business Query: Top 5 Revenue-Generating Categories
SELECT
    cat.category_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price_at_purchase) AS gross_revenue
FROM categories cat
JOIN products p ON cat.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status IN ('PAID', 'SHIPPED', 'DELIVERED')
GROUP BY cat.category_name
ORDER BY gross_revenue DESC;

-- 2. Baseline Execution Plan (BEFORE Indexing)
EXPLAIN ANALYZE
SELECT o.order_id, c.full_name, o.order_date, o.order_status, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.customer_id = 450
  AND o.order_status = 'PENDING'
  AND o.order_date >= '2026-06-01';

-- 3. Create Composite B-Tree Index & Foreign Key Index
CREATE INDEX idx_orders_cust_status_date
ON orders (customer_id, order_status, order_date);

CREATE INDEX idx_order_items_product_id
ON order_items (product_id);

ANALYZE orders;

-- 4. Optimised Execution Plan (AFTER Indexing)
EXPLAIN ANALYZE
SELECT o.order_id, c.full_name, o.order_date, o.order_status, o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.customer_id = 450
  AND o.order_status = 'PENDING'
  AND o.order_date >= '2026-06-01';

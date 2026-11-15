-- ==========================================================
-- MIT 8103: Advanced Database Systems - Portfolio 5
-- Cloud Deployment & Horizontal Range/Region Sharding Demo
-- Case Study: SwiftMart E-Commerce Platform
-- ==========================================================

-- 1. Create a Partitioned (Sharded) Orders Table by Delivery Region
CREATE TABLE distributed_orders (
    order_id SERIAL,
    customer_id INT NOT NULL,
    region_code VARCHAR(15) NOT NULL,
    order_total NUMERIC(12, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (order_id, region_code)
) PARTITION BY LIST (region_code);

-- 2. Create Regional Shards (North-Central / Abuja vs South-West / Lagos)
CREATE TABLE orders_shard_abuja PARTITION OF distributed_orders
    FOR VALUES IN ('ABUJA_NC');

CREATE TABLE orders_shard_lagos PARTITION OF distributed_orders
    FOR VALUES IN ('LAGOS_SW');

-- 3. Insert Sample Cloud Orders Across Shards
INSERT INTO distributed_orders (customer_id, region_code, order_total) VALUES
(101, 'ABUJA_NC', 45000.00),
(102, 'LAGOS_SW', 120000.00),
(103, 'ABUJA_NC', 18500.00);

-- 4. Verify Cloud Server Version & Shard Routing
SELECT
    tableoid::regclass AS target_shard,
    order_id,
    customer_id,
    region_code,
    order_total
FROM distributed_orders;

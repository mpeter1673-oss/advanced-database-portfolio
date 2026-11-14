-- ==========================================================
-- MIT 8103: Advanced Database Systems - Portfolio 3
-- Transactions, Isolation Levels, and Concurrency Control
-- Student: Peter Mercy (301901673)
-- ==========================================================

-- PART 1: ATOMICITY (COMMIT & ROLLBACK)
UPDATE products SET stock_quantity = 5 WHERE product_id = 1;

-- Successful atomic checkout (Order + Stock Deduction)
BEGIN;
    INSERT INTO orders (customer_id, order_status, total_amount)
    VALUES (1, 'PAID', 50000.00);

    UPDATE products
    SET stock_quantity = stock_quantity - 2
    WHERE product_id = 1;
COMMIT;

-- Aborted checkout (Payment failed -> Rollback prevents partial state)
BEGIN;
    INSERT INTO orders (customer_id, order_status, total_amount)
    VALUES (2, 'PENDING', 75000.00);
    ROLLBACK;

SELECT product_id, product_name, stock_quantity
FROM products
WHERE product_id = 1;

-- PART 2: CONCURRENCY CONTROL (PESSIMISTIC ROW LOCKING)
-- Session 1 (Customer A) acquires row-level lock:
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT product_id, product_name, stock_quantity
FROM products
WHERE product_id = 1
FOR UPDATE;
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE product_id = 1;
COMMIT;

-- Session 2 (Customer B) blocks until Session 1 commits, preventing lost updates:
BEGIN ISOLATION LEVEL READ COMMITTED;
SELECT product_id, product_name, stock_quantity
FROM products
WHERE product_id = 1
FOR UPDATE;
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE product_id = 1;
COMMIT;

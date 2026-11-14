-- ==========================================================
-- MIT 8103: Advanced Database Systems - Portfolio 1
-- Case Study: SwiftMart E-Commerce Platform
-- Author: Peter Mercy (301901673)
-- ==========================================================

-- 1. Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    shipping_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(60) NOT NULL UNIQUE,
    description TEXT
);

-- 3. Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
    product_name VARCHAR(120) NOT NULL,
    sku VARCHAR(40) NOT NULL UNIQUE,
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    is_active BOOLEAN DEFAULT TRUE
);

-- 4. Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id) ON DELETE RESTRICT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(25) NOT NULL DEFAULT 'PENDING'
        CHECK (order_status IN ('PENDING', 'PAID', 'SHIPPED', 'DELIVERED', 'CANCELLED')),
    total_amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (total_amount >= 0)
);

-- 5. Order Items Table (Resolves Many-to-Many between Orders and Products)
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price_at_purchase NUMERIC(10, 2) NOT NULL CHECK (unit_price_at_purchase >= 0),
    UNIQUE (order_id, product_id)
);

-- 6. Payments Table
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL UNIQUE REFERENCES orders(order_id) ON DELETE RESTRICT,
    payment_method VARCHAR(30) NOT NULL
        CHECK (payment_method IN ('CARD', 'BANK_TRANSFER', 'WALLET', 'USSD')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (payment_status IN ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED')),
    amount_paid NUMERIC(12, 2) NOT NULL CHECK (amount_paid >= 0),
    transaction_ref VARCHAR(80) NOT NULL UNIQUE,
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Deliveries Table
CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL UNIQUE REFERENCES orders(order_id) ON DELETE CASCADE,
    rider_name VARCHAR(100) NOT NULL,
    rider_phone VARCHAR(20) NOT NULL,
    tracking_code VARCHAR(50) NOT NULL UNIQUE,
    delivery_status VARCHAR(25) NOT NULL DEFAULT 'ASSIGNED'
        CHECK (delivery_status IN ('ASSIGNED', 'IN_TRANSIT', 'DELIVERED', 'FAILED')),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

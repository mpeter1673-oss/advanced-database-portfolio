# Portfolio 1: Database Design and Modelling

**Student:** Peter Mercy (301901673)  
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** SwiftMart E-Commerce Platform  

---

## 1. Case Study Overview

**SwiftMart** is an online retail e-commerce platform serving retail customers across Nigeria. The database supports day-to-day storefront, order processing, payment verification, and last-mile delivery operations.

- **Database Users:**
  1. **Customers:** Register accounts, browse product categories, place orders, and track deliveries.
  2. **Store Administrators:** Manage product listings, pricing, and inventory stock levels.
  3. **Payment & Finance System:** Record payment confirmations, references, and refunds.
  4. **Logistics / Delivery Riders:** Update shipment and delivery statuses.
- **Core Data Stored:** Customer profiles, product categories, product inventory, customer orders, line-item order details, payment transactions, and delivery tracking records.

---

## 2. Entity-Relationship (ER) Model & Relationships

The relational model consists of **7 normalized tables** (see `er_diagram.png`):

1. **`categories` (1) -> `products` (Many):** Each product belongs to one category; one category holds many products (`ON DELETE RESTRICT` prevents deleting a category that still contains products).
2. **`customers` (1) -> `orders` (Many):** A customer can place multiple orders over time, while each order belongs to exactly one customer.
3. **`orders` (Many) <-> `products` (Many) via `order_items`:** Resolved using the `order_items` associative entity. This preserves the exact `unit_price_at_purchase` even if product prices change later.
4. **`orders` (1) -> `payments` (1):** Enforced via a `UNIQUE` foreign key on `payments(order_id)` so each order has one authoritative payment record.
5. **`orders` (1) -> `deliveries` (1):** Enforced via a `UNIQUE` foreign key on `deliveries(order_id)` to track dispatch and rider assignment per order.

---

## 3. Keys and Integrity Constraints

- **Primary Keys (`PRIMARY KEY`):** Surrogate auto-incrementing keys (`SERIAL`) on every table ensure fast indexing and stable row identification.
- **Foreign Keys (`FOREIGN KEY`):** Enforce referential integrity across all relationships so orphan orders, items, or payments cannot exist.
- **Uniqueness Constraints (`UNIQUE`):** Prevent duplicate customer emails (`customers.email`), duplicate product codes (`products.sku`), duplicate product lines in the same order (`order_items(order_id, product_id)`), and duplicate payment/tracking references.
- **Domain / Check Constraints (`CHECK`):**
  - `unit_price >= 0` and `stock_quantity >= 0` prevent negative pricing or negative warehouse inventory.
  - `quantity > 0` prevents zero-item order lines.
  - Controlled status domains (`order_status`, `payment_status`, `delivery_status`) restrict values to valid workflow states.

---

## 4. Normalization Justification (1NF -> 3NF)

1. **First Normal Form (1NF):** Every table has a defined primary key, and all attributes contain atomic single values (no repeating product columns such as `product_1, product_2` inside the `orders` table).
2. **Second Normal Form (2NF):** All tables are in 1NF and have no partial dependencies on a composite key. In `order_items`, introducing surrogate `order_item_id` alongside `UNIQUE(order_id, product_id)` ensures attributes like `quantity` and `unit_price_at_purchase` depend fully on the specific order-product pair rather than on `order_id` or `product_id` alone.
3. **Third Normal Form (3NF):** No non-key attribute depends transitively on another non-key attribute:
   - Customer details (`full_name`, `shipping_address`) are stored only in `customers` rather than repeated inside `orders`.
   - Category descriptions are isolated in `categories` rather than repeated for every row in `products`.
   - Historical purchase prices are stored in `order_items` while current catalog prices remain in `products`.

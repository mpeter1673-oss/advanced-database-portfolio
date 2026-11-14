# Portfolio 2: Query Processing and Optimisation

**Student:** Peter Mercy (301901673)  
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** SwiftMart E-Commerce Platform  

---

## 1. Test Dataset & Workload Setup

To evaluate query execution realistically rather than on trivial toy tables, the `swiftmart_db` database was populated with:
- **1,000** customers
- **200** products across **4** categories
- **50,000** customer orders and **50,000** order line items

---

## 2. Query Analysis & Execution Plan Comparison

We analysed a frequent customer-service query that retrieves filtered order history (`customer_id = 450`, `order_status = 'PENDING'`, `order_date >= '2026-06-01'`) joined with customer profile details.

### Before Indexing (`before_index.png`)
- **Access Method:** `Seq Scan on orders` (Sequential Scan)
- **Behaviour:** Because PostgreSQL only automatically indexes `PRIMARY KEY` and `UNIQUE` columns, it had no index on `orders(customer_id)`. The query planner had to read all 50,000 rows in `orders` from disk/memory and discard non-matching rows.
- **Measured Execution Time:** `2.668 ms`

### Optimisation Applied
We created two B-Tree indexes tailored to the workload:
1. `CREATE INDEX idx_orders_cust_status_date ON orders (customer_id, order_status, order_date);` — A **composite B-Tree index** ordered from highest equality selectivity (`customer_id`, `order_status`) to range filtering (`order_date`).
2. `CREATE INDEX idx_order_items_product_id ON order_items (product_id);` — Speeds up product-level sales aggregation joins.

### After Indexing (`after_index.png`)
- **Access Method:** `Index Scan using idx_orders_cust_status_date on orders`
- **Behaviour:** PostgreSQL traversed the B-Tree directly to customer `450`'s `'PENDING'` entries from June 2026 onward, avoiding full-table I/O.
- **Measured Execution Time:** `0.145 ms` (an **18.4x speedup**)

---

## 3. Trade-Offs Considered

While indexes dramatically accelerate `SELECT` reads and `JOIN` lookups, every additional B-Tree index adds storage overhead and slightly slows down `INSERT`, `UPDATE`, and `DELETE` operations because the index tree must also be updated. Therefore, indexing was restricted to high-frequency filter and foreign-key columns rather than indexing every column indiscriminately.

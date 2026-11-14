# Portfolio 3: Transactions and Concurrency Control

**Student:** Peter Mercy (301901673)  
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** SwiftMart E-Commerce Platform  

---

## 1. ACID Properties in SwiftMart Checkout

In an e-commerce system, placing an order requires inserting a row into `orders`, inserting items into `order_items`, and decrementing `products.stock_quantity`. Grouping these steps inside an explicit `BEGIN ... COMMIT` transaction guarantees:
- **Atomicity:** Either both the order creation and stock deduction succeed together, or neither happens.
- **Consistency:** Database constraints (`CHECK (stock_quantity >= 0)`) are never violated.
- **Isolation:** Concurrent customer checkouts do not read uncommitted or stale stock counts.
- **Durability:** Once `COMMIT` succeeds, the order survives power loss or server crashes via PostgreSQL's Write-Ahead Log (WAL).

---

## 2. Commit and Rollback Verification (`rollback_proof.png`)

1. Product `1` (`SwiftMart Item 1`) was initialized with `stock_quantity = 5`.
2. **Transaction 1 (`COMMIT`):** Customer `1` purchased 2 units. Both the order insert and stock update committed, reducing `stock_quantity` to `3`.
3. **Transaction 2 (`ROLLBACK`):** Customer `2` initiated an order, but a simulated payment failure triggered `ROLLBACK`. Querying `products` confirmed `stock_quantity` remained `3` and no orphan order was saved.

---

## 3. Concurrency Control & Isolation (`concurrency_lock.png`)

### The Concurrency Hazard (Lost Update / Overselling)
Under PostgreSQL's default `READ COMMITTED` isolation level, if two customers read `stock_quantity = 1` simultaneously without locking, both transactions might attempt to decrement stock at the same time.

### Solution Demonstrated (`SELECT ... FOR UPDATE`)
Using two concurrent Query Tool sessions in pgAdmin 4:
- **Session 1 (Customer A)** executed `SELECT ... FROM products WHERE product_id = 1 FOR UPDATE;` inside an open transaction, acquiring an exclusive row-level lock on Product `1`.
- **Session 2 (Customer B)** attempted to update the same product row simultaneously. As captured in `concurrency_lock.png`, PostgreSQL automatically blocked Session 2 (`Waiting for the query to complete...`) until Session 1 executed `COMMIT`, guaranteeing accurate inventory serialization without deadlocks.

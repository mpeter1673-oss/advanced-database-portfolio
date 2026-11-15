# MIT 8103: Advanced Database Systems – Practical Portfolio

**Student Name:** Peter Mercy  
**Student ID:** 301901673  
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** SwiftMart E-Commerce Platform  
**Database Stack:** PostgreSQL 18 (Local), pgAdmin 4, Neon Serverless Cloud PostgreSQL  

---

## Repository Structure

This repository contains five progressive database engineering portfolio tasks modeled around **SwiftMart**, a multi-vendor Nigerian e-commerce platform:

| Folder | Portfolio Component | Key Deliverables |
| :--- | :--- | :--- |
| [`portfolio-1-database-design/`](./portfolio-1-database-design/) | **1. Database Design & Modeling** | 3NF 7-table relational schema (`schema.sql`), ER Diagram (`er_diagram.png`), design justification (`README.md`) |
| [`portfolio-2-query-optimisation/`](./portfolio-2-query-optimisation/) | **2. Query Optimisation & Performance** | 50,000-row dataset benchmark, `EXPLAIN ANALYZE` execution plans before/after B-Tree indexing (`2.668 ms` → `0.145 ms`) |
| [`portfolio-3-transactions-concurrency/`](./portfolio-3-transactions-concurrency/) | **3. Transactions & Concurrency Control** | ACID `COMMIT`/`ROLLBACK` atomicity test, pessimistic row-level locking (`SELECT ... FOR UPDATE`), isolation level analysis |
| [`portfolio-4-nosql/`](./portfolio-4-nosql/) | **4. NoSQL & Advanced Data Models** | Schema-flexible JSONB product catalog with GIN indexing, embedded customer reviews, polyglot persistence strategy |
| [`portfolio-5-distributed-cloud/`](./portfolio-5-distributed-cloud/) | **5. Distributed & Cloud Database** | Live Neon Cloud PostgreSQL deployment, regional list sharding (`ABUJA_NC` / `LAGOS_SW`), Primary–Replica & CAP analysis |

---

## Key Highlights & Performance Results

- **Normalized Relational Core:** Eliminated transitive dependencies across `users`, `vendors`, `categories`, `products`, `orders`, `order_items`, and `payments` with strict `CHECK` and foreign-key constraints.
- **94.6% Query Latency Reduction:** Composite and targeted B-Tree indexes (`idx_orders_customer_status`, `idx_order_items_order_id`) eliminated sequential scans across 50,000 orders and 100,000 line items.
- **Zero Overselling Under Concurrency:** Verified row-level `FOR UPDATE` locks prevent race conditions on limited inventory during concurrent checkouts.
- **Cloud Sharding & CAP Split Policy:** Deployed partitioned order shards on Neon Cloud PostgreSQL, enforcing strict `CP` consistency for payments/stock and high `AP` availability for catalog browsing.




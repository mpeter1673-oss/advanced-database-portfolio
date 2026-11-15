# Portfolio 5: Distributed and Cloud Database Exercise

**Student:** Peter Mercy (301901673)  
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** SwiftMart E-Commerce Platform  

---

## 1. Cloud Database Deployment (`cloud_deployment.png`)

To transition SwiftMart from a single local workstation (`PostgreSQL 18`) to a cloud-native architecture, the database was deployed to **Neon Cloud Serverless PostgreSQL** over TLS/SSL (`sslmode=require`) and administered remotely via **pgAdmin 4** (`SwiftMart Cloud (Neon)`).

Cloud deployment decouples compute from storage, enabling automated daily backups, encrypted network transport, and elastic scaling during peak retail traffic events (such as Black Friday flash sales).

---

## 2. Sharding & Horizontal Partitioning Strategy

As SwiftMart scales nationwide across Nigeria, storing millions of orders on a single node creates I/O bottlenecks. We demonstrated **horizontal list partitioning** (`cloud_sharding.sql`) using `region_code`:
- **`orders_shard_abuja` (`ABUJA_NC`):** Stores orders originating from Abuja and North-Central states.
- **`orders_shard_lagos` (`LAGOS_SW`):** Stores orders originating from Lagos and South-West states.

**Benefits:** Queries filtering by customer region perform **partition pruning**—scanning only the relevant regional shard rather than the entire national order table—while keeping data geographically closer to regional fulfillment hubs.

---

## 3. Replication Architecture (Primary–Replica)

In SwiftMart's workload, catalog browsing (`SELECT` reads) outnumbers checkout writes (`INSERT`/`UPDATE`) by roughly **20:1**:
- **Primary Node (Read/Write):** Handles all transactional order checkouts, payment confirmations, and inventory deductions.
- **Read Replicas (Asynchronous Streaming Replication):** Serve product catalog searches, order tracking lookups, and analytics dashboards, offloading read pressure from the primary node and providing automated failover if the primary node experiences hardware failure.

---

## 4. CAP Theorem & Consistency vs. Availability Trade-Offs

According to the **CAP Theorem**, during a network partition (`P`) between cloud availability zones, a distributed system must choose between strict **Consistency (`C`)** and high **Availability (`A`)**. SwiftMart applies a **split CAP policy** by subsystem:
1. **Checkout, Payments & Inventory (`CP` – Consistency over Availability):** Financial transactions and stock deductions require strong consistency so two customers cannot purchase the last item or have payments misrecorded during a network split.
2. **Product Browsing & Shopping Cart (`AP` – Availability over Consistency):** Customers can continue browsing products and adding items to carts using slightly stale cached replica data even if a regional link temporarily degrades, reconciling stock at final checkout.

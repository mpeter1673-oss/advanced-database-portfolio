# Portfolio 4: NoSQL and Advanced Data Models

**Student:** Peter Mercy (301901673)  
**Course:** MIT 8103 – Advanced Database Systems  
**Case Study:** SwiftMart E-Commerce Platform  

---

## 1. Chosen NoSQL Model: Document-Oriented Store

For SwiftMart's **Product Catalog and Customer Reviews** subsystem, a **Document-Oriented NoSQL model** (implemented via JSON/JSONB documents with a GIN inverted index) was chosen over a purely rigid relational table design.

---

## 2. Why Document NoSQL Fits This Subsystem

1. **Schema Flexibility (Polymorphic Products):**  
   In an e-commerce catalog, product attributes vary drastically across categories. A smartphone (`PROD-ELEC-001`) has `ram`, `storage`, and `battery_mah`, whereas clothing (`PROD-FASH-002`) has `material`, `available_sizes`, and `fit`. Storing all categories in a single SQL table would produce sparse rows filled with `NULL` values, while creating separate tables per category complicates application code. Document storage lets each product carry its own nested `specifications` object cleanly.
2. **Read Performance via Data Locality (Zero Joins):**  
   When a shopper opens a product page, the application needs the product details, specifications, tags, and customer reviews together. Embedding `reviews` directly inside the product document allows the entire product page to be fetched in a single document read without multi-table `JOIN`s.
3. **GIN Indexing for Nested Queries:**  
   By creating a Generalized Inverted Index (`USING GIN (document)`), nested JSON keys such as `specifications.ram` can be queried rapidly without scanning every document.

---

## 3. Hybrid Polyglot Persistence Strategy (SQL + NoSQL)

Rather than replacing the relational database entirely, SwiftMart adopts **polyglot persistence**:
- **Relational SQL (`orders`, `payments`, `stock_quantity`):** Retained for financial transactions where strict ACID guarantees and foreign-key integrity are mandatory.
- **Document NoSQL (`product_catalog_docs`):** Used for high-read, schema-evolving product listings, search tags, and customer reviews.




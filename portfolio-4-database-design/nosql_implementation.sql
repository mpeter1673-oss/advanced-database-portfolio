-- ==========================================================
-- MIT 8103: Advanced Database Systems - Portfolio 4
-- NoSQL Document Data Model (JSONB Document Store)
-- Case Study: SwiftMart Flexible Product Catalog & Reviews
-- Student: Peter Mercy (301901673)
-- ==========================================================

-- 1. Create a Schema-Flexible Document Collection Table
CREATE TABLE product_catalog_docs (
    doc_id VARCHAR(30) PRIMARY KEY,
    document JSONB NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a GIN (Generalized Inverted Index) for fast NoSQL key/value searches
CREATE INDEX idx_product_docs_gin ON product_catalog_docs USING GIN (document);

-- 2. Insert Heterogeneous Documents (Notice completely different attributes!)
INSERT INTO product_catalog_docs (doc_id, document) VALUES
(
    'PROD-ELEC-001',
    '{
        "sku": "SKU-00001",
        "name": "Samsung Galaxy A55 5G",
        "category": "Electronics",
        "price_ngn": 645000,
        "specifications": {
            "ram": "8GB",
            "storage": "256GB",
            "battery_mah": 5000,
            "network": "5G Dual SIM"
        },
        "tags": ["smartphone", "android", "5g"],
        "reviews": [
            {"customer": "Chinedu O.", "rating": 5, "comment": "Battery lasts two full days!"},
            {"customer": "Amina B.", "rating": 4, "comment": "Fast delivery to Abuja."}
        ]
    }'::jsonb
),
(
    'PROD-FASH-002',
    '{
        "sku": "SKU-00002",
        "name": "Classic Ankara Corporate Shirt",
        "category": "Fashion",
        "price_ngn": 28500,
        "specifications": {
            "material": "100% Cotton Wax Print",
            "available_sizes": ["M", "L", "XL", "XXL"],
            "fit": "Slim Fit",
            "wash_care": "Cold hand wash"
        },
        "tags": ["menswear", "ankara", "office"],
        "reviews": [
            {"customer": "Tunde K.", "rating": 5, "comment": "Tailoring and fabric quality are top notch."}
        ]
    }'::jsonb
);

-- 3. NoSQL Document Query: Find Electronics with 8GB RAM & extract embedded reviews
SELECT
    doc_id,
    document->>'name' AS product_name,
    document->'specifications'->>'ram' AS ram_capacity,
    jsonb_array_length(document->'reviews') AS total_reviews,
    document->'reviews'->0->>'comment' AS top_review
FROM product_catalog_docs
WHERE document @> '{"category": "Electronics", "specifications": {"ram": "8GB"}}';

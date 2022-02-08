-- # Tasks
-- Get all customers and their addresses.
SELECT * from "customers"
JOIN "addresses" on "customers"."id" = "addresses"."customer_id";

-- Get all orders and their line items (orders, quantity and product).
SELECT "orders"."id" as "order id", "line_items"."quantity", "products"."description" from "orders"
JOIN "line_items" on "orders"."id" = "line_items"."order_id"
JOIN "products" on "line_items"."product_id" = "products"."id";

-- Which warehouses have cheetos?
SELECT * FROM "warehouse"
JOIN "warehouse_product" on "warehouse"."id" = "warehouse_product"."warehouse_id"
JOIN products on "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'cheetos';

-- Which warehouses have diet pepsi?
SELECT * FROM "warehouse"
JOIN "warehouse_product" on "warehouse"."id" = "warehouse_product"."warehouse_id"
JOIN "products" on "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'diet pepsi';

-- Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT "customers"."id", "customers"."first_name", "customers"."last_name", COUNT(*) FROM "orders"
JOIN "addresses" on "orders"."address_id" = "addresses"."id"
JOIN "customers" on "addresses"."customer_id" = "customers"."id"
GROUP BY "customers"."id";

-- How many customers do we have?
SELECT COUNT(*) from "customers";

-- How many products do we carry?
SELECT COUNT(*) from "products";

-- What is the total available on-hand quantity of diet pepsi?
SELECT SUM(on_hand) from "warehouse_product"
JOIN "products" on "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'diet pepsi';


-- # Stretch
-- How much was the total cost for each order?
SELECT "orders"."id", SUM(unit_price) from "orders"
JOIN "line_items" on "orders"."id" = "line_items"."order_id"
JOIN "products" on "line_items"."product_id" = "products"."id"
GROUP BY "orders"."id";

-- How much has each customer spent in total?
SELECT "customers"."id", "customers"."first_name", "customers"."last_name", SUM(products.unit_price) from "customers"
JOIN "addresses" on "customers"."id" = "addresses"."customer_id"
JOIN "orders" on "addresses"."id" = "orders"."address_id"
JOIN "line_items" on "orders"."id" = "line_items"."order_id"
JOIN "products" on "line_items"."product_id" = "products"."id"
GROUP BY "customers"."id";

-- How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT "customers"."id", "customers"."first_name", "customers"."last_name", COALESCE(SUM(products.unit_price), 0) as "Total Spend" from "customers"
LEFT JOIN "addresses" on "customers"."id" = "addresses"."customer_id"
LEFT JOIN "orders" on "addresses"."id" = "orders"."address_id"
LEFT JOIN "line_items" on "orders"."id" = "line_items"."order_id"
LEFT JOIN "products" on "line_items"."product_id" = "products"."id"
GROUP BY "customers"."id";

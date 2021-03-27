-- 
DROP TABLE "customers";
DROP TABLE "orders";
DROP TABLE "products_to_order";
DROP TABLE "shipment_to_orders_products";
-- 
CREATE TABLE customers (
  id serial PRIMARY KEY,
  first_name varchar(256) NOT NULL,
  last_name varchar(256) NOT NULL,
  phone_number int NOT NULL CHECK (phone_number > 9),
  adress varchar(256) NOT NULL
);
-- 
INSERT INTO customers(first_name, last_name, phone_number, adress)
VALUES(
    'Test',
    'Testovich',
    0501111111,
    'street:Tsstovich/25'
  ),
  (
    'Test_1',
    'Testovich_1',
    0502222222,
    'street:Tsstovich1/40'
  ),
  (
    'Test_1',
    'Testovich_2',
    0503333333,
    'street:Tsstovich2/51'
  );
-- 
CREATE TABLE orders (
  id serial PRIMARY KEY,
  customer_id int REFERENCES customers(id)
);
--
INSERT INTO orders(customer_id)
VALUES(2),
  (3),
  (1);
--  
-- DROP TABLE "products";
CREATE TABLE products (
  id serial PRIMARY KEY,
  product_name varchar(64) NOT NULL,
  code varchar(256) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK ("price" > 0),
  UNIQUE(product_name, code)
);
-- 
INSERT INTO products(product_name, code, price)
VALUES('Apple', '123qwer', 20.5),
  ('Orange', '12345qwert', 35.2),
  ('Lime', '123456qwerty', 85.33);
-- 
CREATE TABLE products_to_order(
  product_id int REFERENCES products(id),
  order_id int REFERENCES orders(id),
  PRIMARY KEY (product_id, order_id)
);
-- 
-- DROP TABLE "contract";
CREATE TABLE contract (
  id serial PRIMARY KEY,
  contract_id varchar(256) NOT NULL UNIQUE,
  contract_date date NOT NULL
);
--
-- DROP TABLE "shipments";
CREATE TABLE shipments (
  id serial PRIMARY KEY,
  shipment_time date NOT NULL
);
-- 
CREATE TABLE shipment_to_orders_products(
  shipment_id int REFERENCES shipments(id),
  product_id int REFERENCES products(id),
  order_id int REFERENCES orders(id),
  quantity int NOT NULL CHECK(quantity > 0),
  PRIMARY KEY(shipment_id, product_id, order_id)
);
-- 
SELECT *
FROM products_to_order
  JOIN products ON orders.id = products.id;
--
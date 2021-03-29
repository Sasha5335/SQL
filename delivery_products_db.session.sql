-- 
-- DROP TABLE shipment_to_orders_products;
-- DROP TABLE products_to_order;
-- DROP TABLE orders;
-- DROP TABLE customers;
-- 
-- DROP TABLE products;
-- DROP TABLE contract;
-- DROP TABLE shipments;
-- 
CREATE TABLE customers (
  id serial PRIMARY KEY,
  first_name varchar(256) NOT NULL,
  last_name varchar(256) NOT NULL,
  phone_number int NOT NULL CHECK (phone_number > 9) UNIQUE,
  adress jsonb NOT NULL
);
-- 
CREATE TABLE orders (
  id serial PRIMARY KEY,
  customer_id int REFERENCES customers(id)
);
--
CREATE TABLE products (
  id serial PRIMARY KEY,
  product_name varchar(64) NOT NULL,
  code varchar(256) NOT NULL,
  price decimal(10, 2) NOT NULL CHECK (price > 0),
  UNIQUE(product_name, code)
);
-- 
CREATE TABLE products_to_order(
  product_id int REFERENCES products(id),
  order_id int REFERENCES orders(id),
  PRIMARY KEY (product_id, order_id)
);
-- 
CREATE TABLE contract (
  id serial PRIMARY KEY,
  contract_id varchar(256) NOT NULL UNIQUE,
  contract_date date NOT NULL
);
--
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
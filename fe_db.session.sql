SELECT sum(quantity)
FROM phones_to_orders;
-- 
-- 
SELECT sum(quantity)
FROM phones;
-- 
-- 
SELECT avg(price)
FROM phones;
-- 
-- 
SELECT avg(price),
  brand
FROM phones
GROUP BY brand;
-- 
-- 
SELECT count(*),
  "userId"
FROM orders
GROUP BY "userId";
-- 
-- 
SELECT avg(price)
FROM phones
WHERE brand = 'IPhone';
-- 
-- 
SELECT count(*) AS "Количество",
  "Age"
FROM (
    SELECT extract(
        'year'
        from age(birthday)
      ) AS "Age",
      *
    FROM users
  ) AS "u_w_age"
GROUP BY "Age"
HAVING count(*) > 8
ORDER BY "Age";
-- 
-- 
SELECT sum(quantity) AS "count",
  brand
FROM phones
GROUP BY brand
HAVING sum(quantity) > 10000;
-- 
-- 
SELECT *
FROM users
WHERE "firstName" ILIKE 'J%'
  AND "lastName" ILIKE 'D%';
-- 
-- 
SELECT *
FROM users
WHERE "firstName" ~ 'i{2}';
-- 
--
SELECT char_length(concat("firstName", ' ', "lastName")) AS "name length",
  *
FROM users
ORDER BY "name length" DESC
LIMIT 1;
-- 
-- 
SELECT char_length(concat("firstName", ' ', "lastName")) AS "name length",
  count(users.id)
FROM users
GROUP BY "name length"
HAVING char_length(concat("firstName", ' ', "lastName")) >= 18
ORDER BY "name length" DESC;
-- 
-- 
SELECT char_length(email) AS "length"
FROM users
WHERE "email" ILIKE 'm%'
GROUP BY "length"
HAVING count(users.id) >= 5;
-- 
-- 
SELECT char_length(concat("firstName", "lastName")) AS "length",
  *
FROM users
ORDER BY "length" DESC;
-- 
-- 
SELECT o.id,
  count(pto.quantity)
FROM phones_to_orders AS pto
  JOIN orders AS o ON o.id = pto."phoneId"
GROUP BY o.id;
-- 
-- 
SELECT u.email,
  count(pto.quantity)
FROM orders AS o
  JOIN users AS u ON o.id = u.id
  JOIN phones_to_orders AS pto ON pto."phoneId" = u.id
GROUP BY u.id;
-- 
-- 
SELECT o.id,
  p.brand,
  count(p.model)
FROM orders AS o
  JOIN phones_to_orders AS pto ON o.id = pto."orderId"
  JOIN phones AS p ON p.id = pto."phoneId"
WHERE p.brand ILIKE 'samsung'
GROUP BY o.id,
  p.brand
ORDER BY count DESC;
-- 
-- 
SELECT pto."orderId"
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."orderId"
GROUP BY pto."orderId";
-- 
-- 
SELECT u.email,
  pto.quantity
FROM users AS u
  JOIN orders AS o ON u.id = o.id
  JOIN phones_to_orders AS pto ON o.id = pto."orderId"
GROUP BY u.email,
  pto.quantity;
-- 
-- 
SELECT p.brand,
  count(pto.quantity)
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."orderId"
GROUP BY p.brand,
  pto.quantity
ORDER BY count DESC
LIMIT 1;
-- 
-- 
SELECT p.model,
  sum(pto.quantity)
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
GROUP BY p.model
ORDER BY sum DESC;
--
--
--
SELECT "umail",
  count("pmodel")
FROM (
    SELECT u.email AS "umail",
      p.model AS "pmodel"
    FROM users AS u
      JOIN orders AS o ON u.id = o."userId"
      JOIN phones_to_orders AS pto ON o.id = pto."orderId"
      JOIN phones AS p ON p.id = pto."phoneId"
    GROUP BY u.email,
      p.model
  ) AS "user_with_phone"
GROUP BY "umail"
ORDER BY count DESC;
--
--
--
SELECT owc.*
FROM (
    SELECT pto."orderId",
      sum(pto.quantity * p.price) AS "cost"
    FROM phones_to_orders AS pto
      JOIN phones AS p ON p.id = pto."phoneId"
    GROUP BY pto."orderId"
  ) AS "owc"
WHERE owc.cost > (
    SELECT avg(owc.cost)
    FROM (
        SELECT pto."orderId",
          sum(pto.quantity * p.price) AS "cost"
        FROM phones_to_orders AS pto
          JOIN phones AS p ON p.id = pto."phoneId"
        GROUP BY pto."orderId"
      ) AS "owc"
  );
--
--
--
WITH "orders_with_cost" AS (
  SELECT pto."orderId",
    sum(pto.quantity * p.price) AS "cost"
  FROM phones_to_orders AS pto
    JOIN phones AS p ON p.id = pto."phoneId"
  GROUP BY pto."orderId"
)
SELECT owc.*
FROM "orders_with_cost" AS "owc"
WHERE owc.cost > (
    SELECT avg(owc.cost)
    FROM "orders_with_cost" AS "owc"
  );
--
--
--
WITH "orders_above_middle" AS (
  SELECT count(o."userId") AS "cost",
    u.email
  FROM users AS u
    JOIN orders AS o ON u.id = o."userId"
  GROUP BY u.email,
    o."userId"
  ORDER BY u.email
)
SELECT oam.*
FROM "orders_above_middle" AS "oam"
WHERE oam.cost >= (
    SELECT avg(oam.cost)
    FROM "orders_above_middle" AS "oam"
  );
--
--
--
SELECT brend_and_model.brand,
  count(brend_and_model.model)
FROM (
    SELECT p.brand AS "brand",
      p.model AS "model"
    FROM phones AS p
      JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
    GROUP BY p.brand,
      p.model
  ) AS "brend_and_model"
GROUP BY brend_and_model.brand;
--
--
SELECT *,
  (
    CASE
      WHEN extract(
        year
        from age("birthday")
      ) < 30 THEN 'not adult'
      WHEN extract(
        year
        from age("birthday")
      ) >= 30 THEN 'adult'
    END
  ) AS "status"
FROM users;
-- 
-- 
SELECT *,
  (
    CASE
      WHEN "brand" ILIKE 'iPhone' THEN 'APPLE'
      ELSE 'OTHERS'
    END
  ) AS "manufacturer"
FROM phones;
-- 
-- 
SELECT *,
  (
    CASE
      WHEN "brand" ILIKE 'samsung' THEN 'SAMSUNG'
      ELSE 'OTHERS'
    END
  ) AS "manufacturer"
FROM phones;
-- 
-- 
SELECT *,
  (
    CASE
      WHEN "price" < 10000 THEN 'min'
      WHEN "price" > 20000 THEN 'max'
      ELSE 'middle'
    END
  ) AS "price_phones"
FROM phones;
-- 
-- 
SELECT *,
  (
    CASE
      WHEN "price" > (
        SELECT avg(price)
        FROM phones
      ) THEN 'max_price'
      ELSE 'low_price'
    END
  ) AS "price_phones"
FROM phones;
-- 
-- 
SELECT "userId",
  "email",
  (
    CASE
      WHEN count(orders.id) > 4 THEN 'constant'
      WHEN count(orders.id) > 2 THEN 'active'
      ELSE 'buyer'
    END
  ) AS "status"
FROM orders
  JOIN users ON users.id = orders."userId"
GROUP BY "userId",
  "email";
-- 
-- 
SELECT *
FROM users
WHERE users.id NOT IN (
    SELECT "userId"
    FROM orders
  );
-- 
--
SELECT *
FROM phones
WHERE price > (
    SELECT max(price)
    FROM phones
    WHERE brand ILIKE 'iPhone'
  );
-- 
--
CREATE VIEW "users_with_orders_amount" AS (
  SELECT users.*,
    count(orders.id) AS "order_amount"
  FROM users
    JOIN orders SchemasON users.id = orders."userId"
  GROUP BY users.id,
    email
);
--
SELECT *
FROM "users_with_orders_amount"
WHERE "order_amount" > 3;
--
--
CREATE VIEW "order_with_price" AS (
  SELECT o."userId",
    o.id,
    sum(p.price * pto.quantity)
  FROM orders o
    JOIN phones_to_orders pto ON o.id = pto."orderId"
    JOIN phones p ON p.id = pto."phoneId"
  GROUP BY o.id
);
--
--
CREATE VIEW "spam_list" AS (
  SELECT owc.*,
    u.email,
    u.birthday
  FROM "order_with_price" owc
    JOIN users u ON u.id = owc."userId"
);
--
--
CREATE VIEW "users_list" AS (
  SELECT concat("firstName", ' ', "lastName"),
    extract(
      year
      from age("birthday")
    ) AS "age",
    (
      CASE
        WHEN "isMale" = true THEN 'male'
        WHEN "isMale" = false THEN 'female'
        ELSE 'other'
      END
    ) AS "gender"
  FROM users
);
--
--
CREATE TABLE users_db.users (
  id serial PRIMARY KEY,
  user_login varchar(64) NOT NULL UNIQUE,
  email varchar(256) NOT NULL CHECK (email != ''),
  user_password int NOT NULL CHECK (user_password > 9),
  UNIQUE(user_login, email)
);
--
-- DROP TABLE users_db.emplayees
CREATE TABLE users_db.emplayees (
  salary numeric(10, 2) NOT NULL,
  department varchar(256) NOT NULL,
  position varchar(256) NOT NULL,
  hire_data date NOT NULL CHECK(hire_data <= current_date),
  "name" varchar(256) NOT NULL
);
--
ALTER TABLE users_db.users
ADD UNIQUE (email);
-- 
ALTER TABLE users_db.users DROP user_password;
--
ALTER TABLE users_db.users
ADD COLUMN "password_hash" text;
--
ALTER TABLE users_db.emplayees
ADD COLUMN user_id int PRIMARY KEY REFERENCES users_db.users -- 
ALTER TABLE users_db.emplayees DROP COLUMN "name" -- 
  -- 
SELECT u.*,
  COALESCE(e.salary, 0) AS "salary"
FROM users_db.users u
  LEFT JOIN users_db.emplayees e ON e.user_id = u.id;
-- 
--
SELECT *
FROM users_db.users u
WHERE u.id NOT IN (
    SELECT user_id
    FROM users_db.emplayees
  );
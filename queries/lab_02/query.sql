\c dbcourse

-- 1
SELECT DISTINCT rev.shop_id, empl.id, rev.employee_rating
FROM employees AS empl JOIN reviews AS rev ON empl.id = rev.employee_id
WHERE rev.employee_rating < 4.0
ORDER BY rev.shop_id, empl.id, rev.employee_rating;

-- 2
SELECT DISTINCT reviewer_id, date
FROM reviews
WHERE date BETWEEN DATE('2004-01-01') AND DATE('2004-03-31');

-- 3
SELECT DISTINCT company, first_name, last_name
FROM shops JOIN employees ON employees.shop_id = shops.id
WHERE first_name LIKE '%oh%';

-- 4
SELECT id as shop, reviewer_id, employee_id, employee_rating, date
FROM reviews
WHERE shop_id IN (SELECT shop_id
                    FROM shops
                    WHERE company = 'Young LLC' )
AND employee_id = '05afafb2-d019-4432-b87e-9cd312be4433';

-- 5
SELECT id, first_name, last_name, email
FROM employees
WHERE NOT EXISTS (SELECT 1 FROM reviews WHERE reviews.employee_id = employees.id);

-- 6
SELECT id, shop_id as shop, good_id as good, good_rating as rating
FROM reviews
WHERE good_rating > ALL ( SELECT good_rating
                        	FROM reviews
                        	WHERE shop_id = '004ea615-39d8-4a13-88c7-d4c91c3812a6' );

-- 7
SELECT AVG(rating) AS actual_avg,
       SUM(rating) / COUNT(review_id) AS calc_avg,
       COUNT(review_id) AS reviews_count
FROM ( SELECT id AS review_id, good_rating AS rating
       FROM reviews
       GROUP BY id
) AS TotReviews;

-- 8
SELECT id, name,
      ( SELECT AVG(good_rating)
      FROM reviews
      WHERE reviews.good_id = goods.id) AS avg_rating,
      ( SELECT MIN(good_rating)
      FROM reviews
      WHERE reviews.good_id = goods.id ) AS min_rating,
      manufacturer
FROM goods
WHERE year < 2000;

-- 9
SELECT goods.name, goods.id,
        CASE goods.year
              WHEN date_part('year', now()) 	THEN 'This Year'
              WHEN date_part('year', now()) - 1 THEN 'Last year'
              WHEN 2021 THEN 'This Year'
              ELSE CAST(DATE_PART('year', now()) - year AS varchar(5)) || ' years ago'
        END AS manufactured
FROM goods JOIN reviews ON goods.id = reviews.good_id;

-- 10
SELECT id, first_name, last_name, salary,
      CASE
          WHEN salary < 100 	THEN 'very cheap'
          WHEN salary < 10000 	THEN 'fair'
          WHEN salary < 100000 THEN 'wow, we are losing money!!!'
          ELSE 'we are done...'
      END AS comment
FROM employees;

-- 11
DROP TABLE IF EXISTS best_manufacturers;

CREATE TEMP TABLE best_manufacturers AS
SELECT manufacturer, AVG(good_rating)
FROM reviews LEFT JOIN goods ON goods.id = reviews.good_id
WHERE good_rating > 7
GROUP BY manufacturer;
DROP TABLE IF EXISTS best_manufacturers;

-- 12
SELECT 'By review count' AS criteria, employee_id as employee
FROM employees empl JOIN ( SELECT employee_id, COUNT(id) AS SQ
                      FROM reviews
                      GROUP BY employee_id
                      ORDER BY SQ DESC LIMIT 1 ) AS OD ON OD.employee_id = empl.id
UNION
SELECT 'By avg rating' AS criteria, employee_id as employee
FROM employees empl JOIN ( SELECT employee_id, AVG(employee_rating) AS SQ
                      FROM reviews
                      GROUP BY employee_id
                      ORDER BY SQ DESC LIMIT 1 ) AS OD ON OD.employee_id = empl.id;

-- 13
SELECT 'By avg rating' AS critreria, id AS best_selling
FROM shops
WHERE id IN ( SELECT shop_id
             FROM reviews
             GROUP BY shop_id
             HAVING AVG(shop_rating) = ( SELECT MAX(SR)
                                         FROM ( SELECT AVG(shop_rating) as SR
                                               FROM reviews
                                               GROUP BY shop_id
                                               ) AS OD
                                       )
           );

-- 14
SELECT G.id, G.name, G.manufacturer,
      AVG(R.good_rating) AS AvgRating,
      MIN(R.good_rating) AS MinRating
FROM goods G LEFT OUTER JOIN reviews R ON R.good_id = G.id
WHERE year < 2000
GROUP BY G.id, G.name, R.good_rating;

-- 15
SELECT good_id, AVG(good_rating) AS avg_rating
FROM reviews R
GROUP BY good_id
HAVING AVG(good_rating) > ( SELECT AVG(good_rating) AS MRating FROM reviews)

-- 16
INSERT INTO shops (company, name, latitude, longitude, registered)
VALUES ('Donut', 'Firefox', 32.15, -110.985833, DEFAULT)

-- 17
INSERT INTO employees (shop_id, job, first_name, last_name, email, phone, salary)
SELECT ( SELECT id
        FROM shops
        WHERE company = 'Smith Inc' AND name = 'Margaret'),
        'public reviewer', first_name, last_name, email, phone, 1000
FROM users
WHERE email = 'ajames@gmail.com';

-- 18
UPDATE employees
SET salary = salary * 1.5
WHERE email = 'ajames@gmail.com';

-- 19
UPDATE employees
SET salary = ( SELECT AVG(salary)
                  FROM employees
                  WHERE shop_id = '000e5c1e-3604-41a3-8367-4d5c1526717d' )
WHERE email = 'ajames@gmail.com';

-- 20
DELETE FROM employees
WHERE email = 'ajames@gmail.com';

-- 21
DELETE FROM goods
WHERE id IN ( SELECT G.id
                    FROM goods G LEFT OUTER JOIN reviews R
                        ON G.id = R.good_id
                    WHERE R.good_rating < 7 AND R.date::date <= '2013-05-03')

-- 22
WITH manufacturer_stats (manufacturer, NumberOfGoods) AS (
    SELECT manufacturer, COUNT(*) AS Total
    FROM goods
    GROUP BY manufacturer
)
SELECT AVG(NumberOfGoods) AS avg_goods_count
FROM manufacturer_stats;

-- 23
WITH RECURSIVE SegmentedComments (id, parent_id, user_id, date, Level) AS
(
      SELECT c.id, c.parent_id, c.user_id, c.date, 0 AS Level
      FROM comments AS c
      WHERE parent_id IS NULL
      UNION ALL
      SELECT e.id, e.parent_id, e.user_id, e.date, Level + 1
      FROM comments AS e INNER JOIN SegmentedComments AS d
      ON e.parent_id = d.id
)

SELECT * FROM SegmentedComments;

-- 24
SELECT DISTINCT shop_id, id, salary, avg(salary) OVER (PARTITION BY shop_id) FROM employees;

-- 25
DROP TABLE IF EXISTS dupl_test;
CREATE TABLE dupl_test (
    id             SERIAL
    , name         VARCHAR NOT NULL
    , manufacturer VARCHAR NOT NULL
);

INSERT INTO dupl_test (id, name, manufacturer)
        VALUES (0, 'LP', 'Gibson')
        , (1, 'Stratocaster', 'Fender')
        , (2, 'Stratocaster', 'Fender')
        , (3, 'LP', 'Gibson')
        , (4, 'Telecaster', 'Fender');

DELETE FROM dupl_test *
WHERE id IN
    (SELECT id
    FROM
        (SELECT
            id
            , ROW_NUMBER() OVER w rown
            FROM dupl_test
            WINDOW w AS (PARTITION BY name, manufacturer
            ORDER BY name, manufacturer)) t
        WHERE t.rown > 1 );

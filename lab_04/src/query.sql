\c dbcourse;

CREATE EXTENSION IF NOT EXISTS plpython3u;
-- 1
CREATE OR REPLACE FUNCTION get_avg_review_rating_py(shop DECIMAL, employee DECIMAL, good DECIMAL)
RETURNS DECIMAL
AS $$
    (shop + employee + good) / 3;
$$ LANGUAGE PLPYTHON3U;
SELECT id
    , shop_rating
    , employee_rating
    , good_rating
    , get_avg_review_rating_py(shop_rating, employee_rating, good_rating)
FROM reviews;

-- 2
CREATE OR REPLACE FUNCTION get_total_avg_review_rating_py()
RETURNS DECIMAL
AS $$
    query = "select get_avg_review_rating_py(shop_rating, employee_rating, good_rating) from reviews;"
    result = plpy.execute(query)
    qsum = 0
    qlen = len(result)
    for x in result:
        qsum += x["get_avg_review_rating_py"]
    return qsum / qlen
$$ LANGUAGE PLPYTHON3U;
SELECT get_total_avg_review_rating_py();

-- 3
CREATE OR REPLACE FUNCTION find_manufacturer_goods_py(mnfctr VARCHAR)
RETURNS TABLE (
    manufacturer VARCHAR
    , good_id UUID
    , name VARCHAR
    , year SMALLINT
) AS $$
    query = f"SELECT g.manufacturer gmn, g.id gid, g.name gname, g.year gyear FROM goods g WHERE g.manufacturer = '{mnfctr}';"
    result = plpy.execute(query)
    for x in result:
        yield(x["gmn"], x["gid"], x["gname"], x["gyear"])
$$ LANGUAGE PLPYTHON3U;
SELECT * FROM find_manufacturer_goods_py('Wilson and Sons');

4
CREATE OR REPLACE PROCEDURE change_employee_salary_py(employee UUID, change DECIMAL)
AS $$
    plan = plpy.prepare(
        "UPDATE employees SET salary = salary + $1 WHERE id = $2;",
        ["INT", "UUID"]
    )
    plpy.execute(plan, [change, employee])
$$ LANGUAGE PLPYTHON3U;
CALL change_employee_salary_py('008de1fa-206b-41df-a304-e45397b55d1b', 1000);

-- 5
CREATE OR REPLACE FUNCTION get_good_mark_py()
RETURNS TRIGGER
AS $$
    if TD["new"]["good_rating"] < 7:
        plpy.notice(f"{TD['new']['good_id']} likely to lose positions")
    else:
        plpy.notice(f"{TD['new']['good_id']} likely to go to top")
$$ LANGUAGE PLPYTHON3U;
CREATE TRIGGER review_suggestion_py AFTER INSERT ON reviews
FOR ROW EXECUTE PROCEDURE get_good_mark_py();

INSERT INTO reviews (shop_id, good_id, employee_id, reviewer_id, good_rating, shop_rating, employee_rating)
VALUES (
    '002f5d91-e25f-43b8-aa9e-d944b975b049'
    , '28dc65f8-96f9-4b20-9285-704182b0dd40'
    , '7163a27c-6e23-46bd-b9a5-01575f4af91d'
    , 'ee986799-b078-42a1-a22d-ca424ba3f641'
    , 4
    , 10
    , 10
);
DELETE FROM reviews WHERE
    shop_id = '002f5d91-e25f-43b8-aa9e-d944b975b049'
    AND good_id = '28dc65f8-96f9-4b20-9285-704182b0dd40'
    AND employee_id = '7163a27c-6e23-46bd-b9a5-01575f4af91d'
    AND reviewer_id = 'ee986799-b078-42a1-a22d-ca424ba3f641';

-- 6
CREATE TYPE good_rating_tuple AS (
    name    VARCHAR,
    rating  DECIMAL
);
CREATE OR REPLACE FUNCTION set_name_price_py(nm VARCHAR, rt DECIMAL)
RETURNS SETOF good_rating_tuple
AS $$
    return ([nm, rt],)
$$ LANGUAGE PLPYTHON3U;
SELECT * FROM set_name_price_py('Book', 20);

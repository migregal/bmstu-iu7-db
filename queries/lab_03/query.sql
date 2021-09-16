\c dbcourse

-- 1
CREATE OR REPLACE FUNCTION get_avg_review_rating(shop DECIMAL, employee DECIMAL, good DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    RETURN (shop + employee + good) / 3;
END;
$$ LANGUAGE PLPGSQL;

SELECT id
	, shop_rating
    , employee_rating
    , good_rating
    , get_avg_review_rating(shop_rating, employee_rating, good_rating)
FROM reviews;

-- 2
DROP TABLE IF EXISTS typedtbl;
CREATE TABLE typedtbl (
    name VARCHAR
     , manufacturer  VARCHAR
     , year          SMALLINT
     , rating        DECIMAL(4,2)
);
CREATE OR REPLACE FUNCTION get_goods_by_manufacturer_with_rating_below(_tbl_type ANYELEMENT, defined_rating DECIMAL, defined_manufacturer VARCHAR)
RETURNS SETOF ANYELEMENT
AS $$
BEGIN
    RETURN QUERY
    EXECUTE
    'SELECT g.name, g.manufacturer, g.year, r.good_rating FROM goods g JOIN reviews r
    ON g.id = r.good_id
    WHERE r.good_rating < $1 AND g.manufacturer = $2'
    USING defined_rating, defined_manufacturer;
END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM get_goods_by_manufacturer_with_rating_below(NULL::typedtbl, 5, 'Brown LLC');

-- 3
CREATE OR REPLACE FUNCTION find_manufacturer_goods(mnfctr VARCHAR)
RETURNS TABLE (
    manufacturer VARCHAR,
    good_id UUID,
  	name VARCHAR,
    year SMALLINT
) AS $$
BEGIN
    CREATE TEMP TABLE tbl (
        manufacturer VARCHAR,
        good_id UUID,
        name VARCHAR,
        year SMALLINT
    );
    INSERT INTO tbl (manufacturer, good_id, name, year)
    SELECT mnfctr, g.id, g.name, g.year FROM goods g WHERE g.manufacturer = mnfctr;
    RETURN QUERY
    SELECT * FROM tbl;
END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM find_manufacturer_goods('Wilson and Sons');

-- 4
CREATE OR REPLACE FUNCTION get_usr_comments(parent_comment UUID, usr_id UUID)
RETURNS TABLE (
    id UUID
     , parent_id UUID
     , user_id UUID
     , date TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE SegmentedComments (id, parent_id, user_id, date, Level) AS (
          SELECT c.id, c.parent_id, c.user_id, c.date, 0 AS Level
          FROM comments AS c
          WHERE c.parent_id = parent_comment
          UNION ALL
          SELECT e.id, e.parent_id, e.user_id, e.date, Level + 1
          FROM comments AS e INNER JOIN SegmentedComments AS d
          ON e.parent_id = d.id
    )
    SELECT sc.id, sc.parent_id, sc.user_id, sc.date FROM SegmentedComments sc WHERE sc.user_id = usr_id;
END;
$$ LANGUAGE PLPGSQL;
SELECT * FROM get_usr_comments('7fbf793f-2e57-425b-826d-3dbdaff844cb', 'c449510c-859a-43c6-97bd-3d4ec0922636');

-- 5
CREATE OR REPLACE PROCEDURE change_employee_salary(employee UUID, change DECIMAL)
AS $$
BEGIN
    UPDATE employees
    SET salary = salary + change
    WHERE id = employee;
    COMMIT;
END;
$$ LANGUAGE PLPGSQL;
CALL change_employee_salary('008de1fa-206b-41df-a304-e45397b55d1b', 1000);

-- 6
CREATE OR REPLACE PROCEDURE find_root_comment(comm_id UUID)
AS $$
DECLARE
    parent_id UUID;
    cur_par_id UUID;
BEGIN
    SELECT c.parent_id FROM comments c WHERE c.id = comm_id
    INTO parent_id;
    IF parent_id is NULL THEN
        RAISE NOTICE 'You are at the root comment!';
    ELSE
        SELECT c.parent_id FROM comments c WHERE c.id = comm_id
        INTO cur_par_id;
        RAISE NOTICE 'You are now at %s. Keep going!', cur_par_id;
        CALL find_root_comment(cur_par_id);
    END IF;
END;
$$ LANGUAGE PLPGSQL;
CALL find_root_comment('00021ca9-22fe-4f72-a668-5c69f9ac5b48');

-- 7
CREATE OR REPLACE PROCEDURE fetch_manufacturer_by_rating(mnfctr VARCHAR, min_rating DECIMAL)
AS $$
DECLARE
    reclist RECORD;
    listcur CURSOR FOR
        SELECT r.id as rev, g.id, g.name, r.good_rating as rating FROM goods g INNER JOIN reviews r ON g.id = r.good_id
        WHERE g.manufacturer = mnfctr AND r.good_rating > min_rating;
BEGIN
    OPEN listcur;
    LOOP
        FETCH listcur INTO reclist;
        RAISE NOTICE '% has % with rating % from review %!', mnfctr, reclist.id, reclist.rating, reclist.rev;
        EXIT WHEN NOT FOUND;
    END LOOP;
    CLOSE listcur;
END;
$$ LANGUAGE PLPGSQL;
CALL fetch_manufacturer_by_rating('Williams Inc', 0);

-- 8
CREATE OR REPLACE PROCEDURE get_db_metadata(dbname VARCHAR)
AS $$
DECLARE
    dbid INT;
    dbconnlimit INT;
BEGIN
    SELECT pg.oid, pg.datconnlimit FROM pg_database pg WHERE pg.datname = dbname
    INTO dbid, dbconnlimit;
    RAISE NOTICE 'DB: %, ID: %, CONNECTION LIMIT: %', dbname, dbid, dbconnlimit;
END;
$$ LANGUAGE PLPGSQL;
CALL get_db_metadata('dbcourse');

-- 9
CREATE OR REPLACE FUNCTION get_good_mark()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.good_rating < 7 THEN
        RAISE NOTICE '% likely to lose positions', NEW.good_id;
    ELSE
        RAISE NOTICE '% likely to go to top', NEW.good_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;
CREATE TRIGGER review_suggestion AFTER INSERT ON reviews
FOR ROW EXECUTE PROCEDURE get_good_mark();

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

-- 10
CREATE OR REPLACE FUNCTION insert_listing()
RETURNS TRIGGER
AS $$
DECLARE
    goodscount INT;
    mnfctr VARCHAR;
BEGIN
    SELECT g.manufacturer, COUNT(*) FROM goods g
    WHERE g.manufacturer = NEW.manufacturer
    GROUP BY g.manufacturer
    INTO mnfctr, goodscount;
    IF goodscount >= 3 THEN
        RAISE EXCEPTION '% already have more than 3 listings on booking. Aborting.', mnfctr;
        RETURN NULL;
    ELSE
        RAISE NOTICE '% listings left for %', 2 - goodscount, mnfctr;
        INSERT INTO goods (
            id
            , name
            , description
            , year
            , manufacturer
            , manufacturer_website
        )
        VALUES (
            NEW.id
          , NEW.name
          , NEW.description
          , NEW.year
          , NEW.manufacturer
          , NEW.manufacturer_website
        );
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE VIEW goodsview AS
SELECT * FROM goods LIMIT 3;

DROP TRIGGER goods_insertion ON goodsview;
CREATE TRIGGER goods_insertion INSTEAD OF INSERT ON goodsview
FOR EACH ROW EXECUTE PROCEDURE insert_listing();
INSERT INTO goodsview (
  id
  , name
  , description
  , year
  , manufacturer
  , manufacturer_website
)
VALUES (
    '00a80a37-2f31-455d-baaa-7a79810583ef'
  	, 'some wrong thing'
    , 'my test row for table'
    , 2019
    , 'Wilson and Sons'
    , 'gibson.com'
);
DELETE FROM goods WHERE id = '00a80a37-2f31-455d-baaa-7a79810583ef';

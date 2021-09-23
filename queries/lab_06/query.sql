CREATE OR REPLACE FUNCTION get_avg_review_rating(shop DECIMAL, employee DECIMAL, good DECIMAL)
RETURNS DECIMAL AS $$
BEGIN
    RETURN (shop + employee + good) / 3;
END;
$$ LANGUAGE PLPGSQL;

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

-- DROP VIEW review_stats;
-- CREATE OR REPLACE VIEW review_stats AS
--     SELECT EXTRACT('week' FROM date_trunc('week', r.date)) "date"
--      , AVG(get_avg_review_rating(r.shop_rating, r.good_rating, r.employee_rating)) average
--      , count(*) FILTER (WHERE get_avg_review_rating(r.shop_rating, r.good_rating, r.employee_rating) < 4) negative
--      , count(*) FILTER (WHERE get_avg_review_rating(r.shop_rating, r.good_rating, r.employee_rating) between 4 and 7) neutral
--      , count(*) FILTER (WHERE get_avg_review_rating(r.shop_rating, r.good_rating, r.employee_rating) > 7) positive
--      , count(*) total
-- FROM reviews r
-- WHERE date_part('year', r.date) = date_part('year', CURRENT_DATE)
-- GROUP BY date_trunc('week', r.date)
-- ORDER BY date_trunc('week', r.date) ASC;

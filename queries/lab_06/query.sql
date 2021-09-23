\c dbcourse;

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

CREATE OR REPLACE PROCEDURE change_employee_salary(employee UUID, change DECIMAL)
AS $$
BEGIN
    UPDATE employees
    SET salary = salary + change
    WHERE id = employee;
    COMMIT;
END;
$$ LANGUAGE PLPGSQL;

\c postgres;

DROP DATABASE IF EXISTS additional;
CREATE DATABASE additional;
\c additional;

DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (
    id SERIAL PRIMARY KEY
);

INSERT INTO numbers(id) VALUES
(DEFAULT),
(DEFAULT),
(DEFAULT),
(DEFAULT),
(DEFAULT),
(DEFAULT);

-- way 1

SELECT CASE
    WHEN (SELECT SUM(CASE WHEN id = 0 THEN 1 ELSE 0 END) FROM numbers) > 0 THEN 0
    ELSE (SELECT
            (1 - (SELECT SUM(CASE WHEN id < 0 THEN 1 ELSE 0 END) FROM numbers) % 2 * 2) *
            EXP(SUM(LN(ABS(id))))::INTEGER AS product
        FROM numbers WHERE id != 0)
    END as total_product;

-- way 2
CREATE OR REPLACE FUNCTION total_product()
RETURNS INTEGER
AS $$
DECLARE
    result INTEGER;
    reclist RECORD;
    listcur CURSOR FOR SELECT id FROM numbers;
BEGIN
    result := 1;

    OPEN listcur;
    LOOP
        FETCH listcur INTO reclist;
        EXIT WHEN NOT FOUND;

        result := result * reclist.id;
    END LOOP;
    CLOSE listcur;

    RETURN result;
END;
$$ LANGUAGE PLPGSQL;

SELECT total_product();

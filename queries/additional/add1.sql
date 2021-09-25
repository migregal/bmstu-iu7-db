CREATE TABLE IF NOT EXISTS Table1(
  id                INTEGER,
  var1              VARCHAR,
  valid_from_dttm   DATE,
  valid_to_dttm     DATE
);
INSERT INTO Table1 (id, var1, valid_from_dttm, valid_to_dttm) VALUES
(1, 'A', '2018-09-01', '2018-09-15'),
(1, 'B', '2018-09-16', '5999-12-31');

CREATE TABLE IF NOT EXISTS Table2(
  id                INTEGER,
  var2              VARCHAR,
  valid_from_dttm   DATE,
  valid_to_dttm     DATE
);
INSERT INTO Table2 (id, var2, valid_from_dttm, valid_to_dttm) VALUES
(1, 'A', '2018-09-01', '2018-09-16'),
(1, 'B', '2018-09-17', '2018-09-18'),
(1, 'C', '2018-09-19', '5999-12-31');

SELECT t1.id
    , var1
    , var2
    , GREATEST(t1.valid_from_dttm, t2.valid_from_dttm) as valid_from_dttm
    , LEAST(t1.valid_to_dttm, t2.valid_to_dttm) as valid_to_dttm
FROM Table1 t1, Table2 t2
WHERE t1.id = t2.id
    AND t1.valid_from_dttm <= t2.valid_to_dttm
    AND t2.valid_from_dttm <= t1.valid_to_dttm;

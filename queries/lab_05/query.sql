\c dbcourse

\t \a

\o /dataset/goods.json
SELECT ROW_TO_JSON(g) FROM goods g;

\o /dataset/shops.json
SELECT ROW_TO_JSON(s) FROM shops s;

\o /dataset/employees.json
SELECT ROW_TO_JSON(e) FROM employees e;

\o /dataset/users.json
SELECT ROW_TO_JSON(u) FROM users u;

\o /dataset/reviews.json
SELECT ROW_TO_JSON(r) FROM reviews r;

\o

DROP TABLE IF EXISTS shops_from_json;
CREATE TABLE shops_from_json (
    id              UUID            PRIMARY KEY DEFAULT uuid_generate_v4()
    , company       VARCHAR(50)                 NOT NULL
    , name          VARCHAR(30)                 NOT NULL
    , latitude      DECIMAL(20,14)
    , longitude     DECIMAL(20,14)
    , registered    DATE                        NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS shop_cmpn_idx_js ON shops_from_json (company, name, registered);

DROP TABLE IF EXISTS temp;
CREATE TABLE temp (
    data jsonb
);

COPY temp (data) FROM '/dataset/shops.json';
INSERT INTO shops_from_json (id, company, name, latitude, longitude, registered)
SELECT (data->>'id')::UUID, data->>'company', data->>'name', (data->>'latitude')::DECIMAL, (data->>'longitude')::DECIMAL, (data->>'registered')::date FROM temp;


DROP TABLE IF EXISTS context;
CREATE TABLE context (
    data jsonb
);
INSERT INTO context (data) VALUES
('{"name": "Gregory", "age": 20, "education": {"university": "BMSTU", "graduation_year": 2023}}'),
('{"name": "Alexander", "age": 20, "education": {"university": "BMSTU", "graduation_year": 2023}}');

SELECT data->'education' education FROM context;
SELECT data->'education'->'university' university FROM context;


CREATE OR REPLACE FUNCTION if_key_exists(json_to_check jsonb, key text)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN (json_to_check->key) IS NOT NULL;
END;
$$ LANGUAGE PLPGSQL;

SELECT if_key_exists('{"name": "Gregory", "age": 20}', 'education');
SELECT if_key_exists('{"name": "Gregory", "age": 20}', 'name');


UPDATE context SET data = data || '{"education":{"graduation_year": 2025}}'::jsonb WHERE (data->'education'->'graduation_year')::INT = 2023;


SELECT * FROM jsonb_array_elements('[
    {"name": "Gregory", "age": 20, "education": {"university": "BMSTU", "graduation_year": 2023}},
    {"name": "Alexander", "age": 20, "education": {"university": "BMSTU", "graduation_year": 2023}}
]');

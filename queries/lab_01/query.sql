\c postgres;

DROP DATABASE IF EXISTS dbcourse;
CREATE DATABASE dbcourse;
\c dbcourse;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE goods (
    id                      UUID    PRIMARY KEY DEFAULT uuid_generate_v4()
    , name                  VARCHAR(50)         NOT NULL
    , description           TEXT
    , year                  SMALLINT CONSTRAINT correct_year CHECK (year > 0 AND year < 2022)
    , manufacturer          VARCHAR(50)         NOT NULL
    , manufacturer_website  VARCHAR(50)
);
CREATE UNIQUE INDEX IF NOT EXISTS good_mnfr_idx ON goods (manufacturer, name, year);
COPY goods FROM '/dataset/goods.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE shops (
    id              UUID            PRIMARY KEY DEFAULT uuid_generate_v4()
    , company       VARCHAR(50)                 NOT NULL
    , name          VARCHAR(30)                 NOT NULL
    , latitude      DECIMAL(20,14)
    , longitude     DECIMAL(20,14)
    , registered    DATE                        NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX IF NOT EXISTS shop_cmpn_idx ON shops (company, name, registered);
COPY shops FROM '/dataset/shops.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE employees (
    id              UUID            PRIMARY KEY DEFAULT uuid_generate_v4()
    , shop_id       UUID            NOT NULL
    , job           VARCHAR(100)    NOT NULL
    , first_name    VARCHAR(30)     NOT NULL
    , last_name     VARCHAR(30)     NOT NULL
    , email         VARCHAR(250)    NOT NULL
    , phone         VARCHAR(30)     NOT NULL
    , salary        NUMERIC         NOT NULL
    , CONSTRAINT positive_salary CHECK (salary > 0)
    , FOREIGN KEY (shop_id) REFERENCES shops(id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS empl_shop_idx  ON employees (id, shop_id);
CREATE        INDEX IF NOT EXISTS empl_email_idx ON employees (email);
CREATE        INDEX IF NOT EXISTS empl_phone_idx ON employees (phone);
CREATE        INDEX IF NOT EXISTS empl_name_idx  ON employees (first_name, last_name);
COPY employees FROM '/dataset/employees.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE users (
    id              UUID    PRIMARY KEY DEFAULT uuid_generate_v4()
    , first_name    VARCHAR(30)         NOT NULL
    , last_name     VARCHAR(30)         NOT NULL
    , email         VARCHAR(250)        NOT NULL
    , phone         VARCHAR(30)
    , registered    DATE                NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS usr_email_idx ON users (email);
CREATE UNIQUE INDEX IF NOT EXISTS usr_phone_idx ON users (phone);
COPY users FROM '/dataset/users.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE reviews (
    id                  UUID PRIMARY KEY DEFAULT uuid_generate_v4()
    , shop_id           UUID             NOT NULL
    , good_id           UUID             NOT NULL
    , employee_id       UUID             NOT NULL
    , reviewer_id       UUID             NOT NULL
    , date              TIMESTAMP        NOT NULL   DEFAULT now()
    , comment           VARCHAR(2000)
    , good_rating       DECIMAL(4,2)     NOT NULL
    , shop_rating       DECIMAL(4,2)     NOT NULL
    , employee_rating   DECIMAL(4,2)     NOT NULL
    , CONSTRAINT correct_good_rating CHECK (good_rating >= 0 AND good_rating <= 10)
    , CONSTRAINT correct_shop_rating CHECK (shop_rating >= 0 AND shop_rating <= 10)
    , CONSTRAINT correct_employee_rating CHECK (employee_rating >= 0 AND employee_rating <= 10)
    , FOREIGN KEY (shop_id)     REFERENCES shops(id)        ON DELETE CASCADE
    , FOREIGN KEY (good_id)     REFERENCES goods(id)        ON DELETE CASCADE
    , FOREIGN KEY (employee_id) REFERENCES employees(id)    ON DELETE CASCADE
    , FOREIGN KEY (reviewer_id) REFERENCES users(id)        ON DELETE CASCADE
);
CREATE UNIQUE INDEX IF NOT EXISTS review_idx ON reviews (shop_id, good_id, employee_id, reviewer_id);
COPY reviews FROM '/dataset/reviews.csv' DELIMITER ',' CSV HEADER;

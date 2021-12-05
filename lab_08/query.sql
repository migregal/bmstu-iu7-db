\c dbcourse

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS shops_logs;
CREATE TABLE shops_logs(
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
    , filename TEXT NOT NULL
    , contents TEXT
);

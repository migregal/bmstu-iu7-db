# Labs for DB course

As you are here give me a star)

## Usage
* run `docker-compose up -d` to start all necessary Docker containers
* run `docker exec -it postgresdbcourse psql -U migregal` to connect directly to `PostgreSQL` container to `psql` session.
    * run `\i ./lab_<number>/query.sql` to run script for specified lab.
* or run `docker exec -it postgresdbcourse bash` to connect directly to `PostgreSQL` container to `bash` session.

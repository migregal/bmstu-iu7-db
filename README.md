# Labs for DB course

As you are here give me a star)

## Usage
* run `docker-compose up -d` to start all necessary Docker containers
* run `docker exec -it postgresdbcourse psql -U migregal` to connect directly to `PostgreSQL` container to `psql` session.
* or run `docker exec -it postgresdbcourse bash` to connect directly to `PostgreSQL` container to `bash` session.

## Lab 01
* [scheme](https://github.com/migregal/bmstu_iu7_db/tree/master/docs)
* [data generation (via `python`)](https://github.com/migregal/bmstu_iu7_db/tree/master/scripts)
* [data generation (via `golang`)](https://github.com/migregal/bmstu_iu7_db/tree/master/goscripts)
* [sql script](https://github.com/migregal/bmstu_iu7_db/blob/master/queries/lab_01/query.sql)

## Lab 02
* [sql script](https://github.com/migregal/bmstu_iu7_db/blob/master/queries/lab_02/query.sql)

## Lab 03
* [sql script](https://github.com/migregal/bmstu_iu7_db/blob/master/queries/lab_03/query.sql)

## Lab 04
* [sql script](https://github.com/migregal/bmstu_iu7_db/blob/master/queries/lab_04/query.sql)

## Lab 05
* [sql script](https://github.com/migregal/bmstu_iu7_db/blob/master/queries/lab_05/query.sql)

## Lab 06
* [backend](https://github.com/migregal/bmstu_iu7_db/tree/master/coke)
* [frontend](https://github.com/migregal/bmstu_iu7_db/tree/master/front)

## Troubleshooting
Maybe you should update `Dockerfile.db` to fix `PostgreSQL` extention for [Lab 05](#lab_05). All you neeed is to increase `postgresql-plpython3-13` to currently supported version.

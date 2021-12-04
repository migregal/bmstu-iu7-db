\c postgres

DROP DATABASE IF EXISTS rk2;
CREATE DATABASE rk2;

\c rk2;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
    , title VARCHAR NOT NULL
    , description VARCHAR NOT NULL
);

CREATE TABLE IF NOT EXISTS teachers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
    , fio VARCHAR NOT NULL
    , academic_degree VARCHAR NOT NULL
    , post VARCHAR NOT NULL
    , department UUID
    , FOREIGN KEY (department) REFERENCES departments(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS subjects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
    , title VARCHAR NOT NULL
    , hours INT NOT NULL
    , sem INT NOT NULL
    , rating DECIMAL(4,2)
);

CREATE TABLE teacher_subjects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4()
    , teacher UUID 
    , subject UUID
    , FOREIGN KEY (teacher) REFERENCES teachers(id) ON DELETE CASCADE
    , FOREIGN KEY (subject) REFERENCES subjects(id) ON DELETE CASCADE
);

INSERT INTO departments (id, title, description) VALUES
('085cf332-4f65-11ec-81d3-0242ac130003', 'iu1', '1'),
('085cf54e-4f65-11ec-81d3-0242ac130003', 'iu2', '2'),
('085cf648-4f65-11ec-81d3-0242ac130003', 'iu3', '3'),
('085cfaee-4f65-11ec-81d3-0242ac130003', 'iu4', '4'),
('085cfbc0-4f65-11ec-81d3-0242ac130003', 'iu5', '5'),
('085cfd14-4f65-11ec-81d3-0242ac130003', 'iu6', '6'),
('085cfde6-4f65-11ec-81d3-0242ac130003', 'iu7', '7'),
('085cfea4-4f65-11ec-81d3-0242ac130003', 'iu8', '8'),
('085cff4e-4f65-11ec-81d3-0242ac130003', 'iu9', '9'),
('085d007a-4f65-11ec-81d3-0242ac130003', 'iu10', 'none of it');

INSERT INTO teachers (id, fio, academic_degree, post, department) VALUES
('624876c8-4f65-11ec-81d3-0242ac130003','fio 1','some degree','post 1','085cf332-4f65-11ec-81d3-0242ac130003'),
('624879ac-4f65-11ec-81d3-0242ac130003','fio 2','some degree','post 1','085cf332-4f65-11ec-81d3-0242ac130003'),
('62487ca4-4f65-11ec-81d3-0242ac130003','fio 3','some degree','post 1','085cfde6-4f65-11ec-81d3-0242ac130003'),
('62487d76-4f65-11ec-81d3-0242ac130003','fio 4','some degree','post 2','085cfde6-4f65-11ec-81d3-0242ac130003'),
('62487e34-4f65-11ec-81d3-0242ac130003','fio 5','some degree','post 3','085cfde6-4f65-11ec-81d3-0242ac130003'),
('62487ee8-4f65-11ec-81d3-0242ac130003','fio 6','some degree','post 1','085d007a-4f65-11ec-81d3-0242ac130003'),
('62487f9c-4f65-11ec-81d3-0242ac130003','fio 7','some degree','post 1','085d007a-4f65-11ec-81d3-0242ac130003'),
('62488064-4f65-11ec-81d3-0242ac130003','fio 8','some degree','post 1','085d007a-4f65-11ec-81d3-0242ac130003'),
('62488118-4f65-11ec-81d3-0242ac130003','fio 8','some degree','post 4','085cfbc0-4f65-11ec-81d3-0242ac130003'),
('624881cc-4f65-11ec-81d3-0242ac130003','fio 9','some degree','post 1','085cfbc0-4f65-11ec-81d3-0242ac130003');

INSERT INTO subjects (id, title, hours, sem, rating) VALUES
('3f5b19a8-4f66-11ec-81d3-0242ac130003','some title',160,1,2.0),
('3f5b1ba6-4f66-11ec-81d3-0242ac130003','some title',80,2,2.0),
('3f5b1e26-4f66-11ec-81d3-0242ac130003','some title',90,3,2.0),
('3f5b1f0c-4f66-11ec-81d3-0242ac130003','some title',200,4,5.0),
('3f5b1fc0-4f66-11ec-81d3-0242ac130003','some title',100,5,7.0),
('3f5b2074-4f66-11ec-81d3-0242ac130003','some title',100,5,9.0),
('3f5b211e-4f66-11ec-81d3-0242ac130003','some title',120,3,1.0),
('3f5b21d2-4f66-11ec-81d3-0242ac130003','some title',40,2,0.0),
('3f5b2290-4f66-11ec-81d3-0242ac130003','some title',90,1,3.0),
('3f5b2344-4f66-11ec-81d3-0242ac130003','some title',320,8,10.0);

INSERT INTO teacher_subjects (teacher, subject) VALUES
('624876c8-4f65-11ec-81d3-0242ac130003','3f5b21d2-4f66-11ec-81d3-0242ac130003'),
('62487d76-4f65-11ec-81d3-0242ac130003','3f5b21d2-4f66-11ec-81d3-0242ac130003'),
('624876c8-4f65-11ec-81d3-0242ac130003','3f5b2344-4f66-11ec-81d3-0242ac130003'),
('62488064-4f65-11ec-81d3-0242ac130003','3f5b2344-4f66-11ec-81d3-0242ac130003'),
('624876c8-4f65-11ec-81d3-0242ac130003','3f5b2074-4f66-11ec-81d3-0242ac130003'),
('62487f9c-4f65-11ec-81d3-0242ac130003','3f5b2074-4f66-11ec-81d3-0242ac130003'),
('624881cc-4f65-11ec-81d3-0242ac130003','3f5b21d2-4f66-11ec-81d3-0242ac130003'),
('624879ac-4f65-11ec-81d3-0242ac130003','3f5b21d2-4f66-11ec-81d3-0242ac130003'),
('62488064-4f65-11ec-81d3-0242ac130003','3f5b19a8-4f66-11ec-81d3-0242ac130003'),
('62487d76-4f65-11ec-81d3-0242ac130003','3f5b19a8-4f66-11ec-81d3-0242ac130003');

-- Инструкция SELECT, использующая предикат сравнения с квантором
-- Выбрать всех преподователей, которые ведут хотя бы один предмет
SELECT id, fio FROM teachers 
WHERE id = ANY(SELECT teacher FROM teacher_subjects);

-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- Выбрать среднюю оценку курса у каждого преподавателя, ведущего курсы
SELECT teachers.id, fio, AVG(rating)::DECIMAL(4,2) FROM teachers
JOIN teacher_subjects ON teachers.id = teacher_subjects.teacher
JOIN subjects ON teacher_subjects.subject = subjects.id
GROUP BY teachers.id;

-- Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
-- Создаем таблицу с лучшими преподавателями (те, у кого средний рейтинг за курс выше 5)
CREATE TEMP TABLE best_teachers AS
SELECT * FROM
(SELECT teachers.id, fio, AVG(rating)::DECIMAL(4,2) AS rating FROM teachers
    JOIN teacher_subjects ON teachers.id = teacher_subjects.teacher
    JOIN subjects ON teacher_subjects.subject = subjects.id
    GROUP BY teachers.id) t
WHERE t.rating > 5.0;

-- Создать хранимую процедуру с входным параметром – «имя таблицы»,
-- которая удаляет дубликаты записей из указанной таблицы в текущей базе
-- данных. Созданную хранимую процедуру протестировать

-- Это просто рабочий вариант (за счет distinct *)

CREATE OR REPLACE PROCEDURE del_dupl(IN tab_name_in VARCHAR(32))
AS $$
BEGIN
EXECUTE '
	create table tab_temp as
		select distinct *
		from ' || tab_name_in;
EXECUTE 'DROP TABLE' || tab_name_in;
EXECUTE '
	ALTER TABLE tab_temp rename to ' || tab_name_in;
END;
$$ LANGUAGE plpgsql;

-- Этот работает с мета информацией конкретной таблицы

CREATE OR REPLACE PROCEDURE remove_dupls(tablename VARCHAR)
AS $$
BEGIN
    EXECUTE '
    DELETE FROM ' || tablename || ' *
	WHERE id IN
	    (SELECT id
	    FROM
    	    (SELECT
                id
                , ROW_NUMBER() OVER w rown
                FROM dupl_test
                WINDOW w AS (PARTITION BY 
                            (SELECT column_name
			    FROM information_schema.columns
                 	    WHERE table_schema = 'public'
   			    AND table_name   = ' || tablename || '
                            )
                            )
            ) t
	        WHERE t.rown > 1 )';
END;
$$ LANGUAGE PLPGSQL;

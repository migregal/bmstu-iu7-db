DROP TABLE empl_visits;

CREATE TABLE IF NOT EXISTS empl_visits
(
    department VARCHAR,
	fio VARCHAR,
	empl_dt DATE,
	status VARCHAR
);

INSERT INTO empl_visits(department, fio, empl_dt, status) VALUES
('ИТ','Иванов Иван Иванович','2020-01-15','Больничный'),
('ИТ','Иванов Иван Иванович','2020-01-16','На работе'),
('ИТ','Иванов Иван Иванович','2020-01-17','Оплачиваемый отпуск'),
('ИТ','Иванов Иван Иванович','2020-01-18','На работе'),
('ИТ','Иванов Иван Иванович','2020-01-19','Оплачиваемый отпуск'),
('ИТ','Иванов Иван Иванович','2020-01-20','Оплачиваемый отпуск'),
('Бухгалтерия','Петрова Ирина Ивановна','2020-01-15','Оплачиваемый отпуск'),
('Бухгалтерия','Петрова Ирина Ивановна','2020-01-16','На работе'),
('Бухгалтерия','Петрова Ирина Ивановна','2020-01-17','На работе'),
('Бухгалтерия','Петрова Ирина Ивановна','2020-01-18','На работе'),
('Бухгалтерия','Петрова Ирина Ивановна','2020-01-19','Оплачиваемый отпуск'),
('Бухгалтерия','Петрова Ирина Ивановна','2020-01-20','Оплачиваемый отпуск');

with numbered AS (
    select row_number() over(
        partition by fio, status
        order by empl_dt
    ) as i, department, fio, status, empl_dt
    from empl_visits
)
SELECT department, fio, min(empl_dt) as date_from, max(empl_dt) as date_to, status
FROM numbered n
GROUP BY department, fio, status, empl_dt - make_interval(days => i::int)
ORDER BY department, fio, date_from;

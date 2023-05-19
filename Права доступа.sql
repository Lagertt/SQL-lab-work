create table Class
(
    id   serial
        constraint Class_pk
            primary key ,
    name text    not null
        unique
);
create table Timepair
(
    id  serial
        constraint Timepair_pk
            primary key,
    start_pair time,
    end_pair   time    not null
);
create table Teachers
(
    id  serial
        constraint Teacher_pk
            primary key,
    first_name  text    not null,
    middle_name text,
    last_name   text    not null
);
create table Subject
(
    id  serial
        constraint Subject_pk
            primary key,
    name text    not null
        unique
);
create table Shedule
(
    id  serial
        constraint Shedule_pk
            primary key,
    date        date    not null,
    class       integer not null
        constraint shedule_class_id_fk
            references Class,
    number_pair integer not null
        constraint shedule_timepair_id_fk
            references Timepair,
    teacher     integer not null
        constraint shedule_teacher_id_fk
            references Teachers,
    subject     integer not null
        constraint shedule_subject_id_fk
            references Subject,
    classroom   integer not null
);
create table Students
(
    id  serial
        constraint Student_pk
            primary key,
    first_name  text    not null,
    middle_name text,
    last_name   text    not null,
    birthday    date    not null,
    address     text
);
create table Student_in_class
(
    id  serial
        constraint Student_in_class_pk
            primary key,
    class   integer not null
        constraint student_in_class_class_id_fk
            references Class,
    student integer not null
        constraint student_in_class_student_id_fk
            references Students
);
insert into Subject("name") values
    ('Русский язык'),
    ('Математика'),
    ('Информатика'),
    ('Физкультура'),
    ('География'),
    ('Физика'),
    ('Английский язык'),
    ('Литература'),
    ('Химия');
insert into Timepair("start_pair", "end_pair") values
    ('08:30:00', '09:15:00'),
    ('09:20:00', '10:05:00'),
    ('10:15:00', '11:00:00'),
    ('11:05:00', '11:50:00'),
    ('12:50:00', '13:35:00'),
    ('13:40:00', '14:25:00'),
    ('14:35:00', '15:20:00'),
    ('15:25:00', '16:10:00');
insert into Teachers("first_name", "middle_name", "last_name") values
    ('Павел', 'Петрович', 'Ромашкин'),
    ('Василий', 'Антонович', 'Колежников'),
    ('Мария', 'Степановна', 'Ваулина'),
    ('Елена', 'Тимуровна', 'Жедринская'),
    ('Марина', 'Геннадьевна', 'Сосновская'),
    ('Steve', '', 'Tompson'),
    ('Екатерина', 'Яковлевна', 'Мясоедова'),
    ('София', 'Дмитриевна', 'Крауз');
insert into Class("name") values
    ('9А'),
    ('9Б'),
    ('10А'),
    ('10Б'),
    ('11А'),
    ('11Б');
insert into Students(first_name, middle_name, last_name, birthday, address) values
                ('Артём', 'Максимович', 'Смирнов', '2002-10-01T00:00:00.000Z', 'ul. Pushkina, d. 36, kv. 5'),
                ('Анастасия', 'Алекснадровна', 'Петрова', '2002-11-14T00:00:00.000Z', 'ul. YUzhnaya, d. 12, kv. 1'),
                ('Сергей', 'Иванович', 'Горохов', '2002-06-20T00:00:00.000Z', 'ul. Pushkina, d. 40, kv. 7'),
                ('Анна', 'Дмитриевна', 'Покровская', '2002-03-12T00:00:00.000Z', 'ul. YUzhnaya, d. 8, kv. 81'),
                ('Даниил', 'Александрович', 'Орлов', '2002-01-26T00:00:00.000Z', 'ul. Pushkina, d. 58, kv. 16'),
                ('Ева', 'Семёновна', 'Горелова', '2002-04-17T00:00:00.000Z', 'ul. CHernova, d. 56, kv. 89'),
                ('Иван', 'Богданович', 'Поляков', '2002-08-04T00:00:00.000Z', 'ul. Pushkina, d. 21, kv. 51'),
                ('Диана', 'Ильинична', 'Старостина', '2002-12-17T00:00:00.000Z', 'ul. CHernova, d. 206, kv. 2'),
                ('Тимофей', 'Андреевич', 'Игнатов', '2001-10-29T00:00:00.000Z', 'ul. Pushkina, d. 45, kv. 65'),
                ('Анастасия', 'Жукова', 'Калинина', '2001-09-21T00:00:00.000Z', 'ul. YUzhnaya, d. 45, kv. 56'),
                ('Илья', 'Романович', 'Филатов', '2001-02-10T00:00:00.000Z', 'ul. Pervomajskaya, d. 56, kv. 7'),
                ('Дарья', 'Романовна', 'Булатова', '2001-11-03T00:00:00.000Z', 'ul. CHernova, d. 32, kv. 56'),
                ('Михаил', 'Богданович', 'Иванов', '2001-09-19T00:00:00.000Z', 'ul. Zapadnaya, d. 78, kv. 9'),
                ('Елизавета', 'Игоревна', 'Синицына', '2001-06-09T00:00:00.000Z', 'ul. Oplesnina, d. 4, kv. 4'),
                ('Евгений', 'Дмитриевич', 'Измайлов', '2000-05-14T00:00:00.000Z', 'ul. CHernova, d. 54, kv. 67'),
                ('Мария', 'Григорьевна', 'Жукова', '2000-03-30T00:00:00.000Z', 'ul. Kirova, d. 23, kv. 13'),
                ('Иван', 'Игоревич', 'Воробьев', '2000-02-15T00:00:00.000Z', 'ul. Kuratova, d. 96, kv. 45'),
                ('Кристина', 'Алексеевна', 'Гусева', '2000-12-13T00:00:00.000Z', 'ul. Karla Marksa, d. 89, kv. 7'),
                ('Семён', 'Михайловчи', 'Михеев', '2000-11-02T00:00:00.000Z', 'ul. Pushkina, d. 78, kv. 9'),
                ('Мия', 'Витальевна', 'Карпова', '2000-10-07T00:00:00.000Z', 'ul. Internacionalnaya, d. 7, kv. 9');
insert into Student_in_class (class, student) values
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 5),
    (2, 6),
    (2, 7),
    (2, 8),
    (3, 9),
    (3, 10),
    (3, 11),
    (4, 12),
    (4, 13),
    (4, 14),
    (5, 15),
    (5, 16),
    (5, 17),
    (6, 18),
    (6, 19),
    (6, 20);
insert into Shedule (date, class, number_pair, teacher, subject, classroom) values
    ('2019-09-01T00:00:00.000Z', 1, 1, 4, 1, 40),
    ('2019-09-01T00:00:00.000Z', 1, 2, 2, 9, 40),
    ('2019-09-01T00:00:00.000Z', 1, 3, 3, 3, 40),
    ('2019-09-01T00:00:00.000Z', 1, 4, 1, 4, 9),
    ('2019-09-01T00:00:00.000Z', 2, 1, 2, 9, 12),
    ('2019-09-01T00:00:00.000Z', 2, 2, 3, 3, 12),
    ('2019-09-01T00:00:00.000Z', 2, 3, 4, 1, 12),
    ('2019-09-01T00:00:00.000Z', 2, 5, 1, 4, 9),
    ('2019-09-01T00:00:00.000Z', 3, 1, 3, 3, 28),
    ('2019-09-01T00:00:00.000Z', 3, 3, 1, 4, 9),
    ('2019-09-01T00:00:00.000Z', 3, 4, 6, 6, 28),
    ('2019-09-01T00:00:00.000Z', 4, 1, 4, 1, 30),
    ('2019-09-01T00:00:00.000Z', 4, 2, 1, 4, 9),
    ('2019-09-01T00:00:00.000Z', 4, 4, 5, 5, 30),
    ('2019-09-01T00:00:00.000Z', 5, 1, 7, 2, 4),
    ('2019-09-01T00:00:00.000Z', 5, 2, 7, 2, 4),
    ('2019-09-01T00:00:00.000Z', 5, 3, 8, 9, 4),
    ('2019-09-01T00:00:00.000Z', 6, 1, 8, 2, 22),
    ('2019-09-01T00:00:00.000Z', 6, 2, 8, 2, 22),
    ('2019-09-01T00:00:00.000Z', 6, 3, 7, 6, 22),
    ('2019-09-02T00:00:00.000Z', 1, 3, 2, 9, 40),
    ('2019-09-02T00:00:00.000Z', 1, 4, 3, 3, 40),
    ('2019-09-02T00:00:00.000Z', 2, 1, 4, 1, 12),
    ('2019-09-02T00:00:00.000Z', 2, 2, 5, 5, 12),
    ('2019-09-02T00:00:00.000Z', 3, 1, 6, 6, 28),
    ('2019-09-02T00:00:00.000Z', 3, 2, 7, 2, 28),
    ('2019-09-02T00:00:00.000Z', 4, 1, 8, 2, 30),
    ('2019-09-02T00:00:00.000Z', 4, 3, 3, 3, 30),
    ('2019-09-02T00:00:00.000Z', 5, 2, 3, 3, 4),
    ('2019-09-02T00:00:00.000Z', 5, 3, 7, 2, 4),
    ('2019-09-02T00:00:00.000Z', 5, 4, 6, 6, 4),
    ('2019-09-02T00:00:00.000Z', 6, 1, 2, 9, 22),
    ('2019-09-02T00:00:00.000Z', 6, 3, 8, 2, 22),
    ('2019-09-02T00:00:00.000Z', 6, 4, 5, 5, 22);



CREATE TABLE users_students
(
  username          text,
  student_id int REFERENCES students (id)
);

INSERT INTO users_students(username, student_id)
VALUES ('third', 1);

CREATE FUNCTION students_constraint() RETURNS trigger AS
$$
BEGIN
  IF NOT EXISTS(SELECT * FROM users_students WHERE username = user AND student_id = new.id) THEN
    RAISE EXCEPTION insufficient_privilege
      USING MESSAGE = 'Попытка обновления запрещённой строки с id = ' || new.id || ' пользователем ' || user;
  ELSE
    RETURN NULL;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER constraint_trigger
  AFTER UPDATE
  ON students
  FOR EACH ROW
EXECUTE PROCEDURE students_constraint();




-- директор, может изменять таблицы учеников и учителей, смотреть всё
create role director nosuperuser inherit nocreatedb nocreaterole noreplication;
grant usage on schema lb8 to director;
grant select on shedule, student_in_class, students, teachers, timepair, subject, class to director;
grant update, insert, delete on students, teachers to director;

-- методист может смотреть всё, менять расписание, время звонков, коллектив классов, предметы
create role methodist nosuperuser inherit nocreatedb nocreaterole noreplication;
grant usage on schema lb8 to methodist;
grant select on shedule, student_in_class, students, teachers, timepair, subject, class to methodist;
grant update, insert, delete on student_in_class, shedule, timepair, subject, class to methodist;

-- ученик может смотреть расписание, время звонков, своих одноклассников, не может ничего менять
create role student nosuperuser inherit nocreatedb nocreaterole noreplication;
grant usage on schema lb8 to student;
grant select on shedule, timepair, users_students, students to student;
grant update on students to student;









--директор
create user first with password 'qwerty1';
grant director to first;
set role first;
select distinct first_name, last_name, name from lb8.teachers
    inner join Shedule S on Teachers.id = S.teacher
    inner join Subject S2 on S2.id = S.subject;
update teachers set first_name = 'Николай' where id = 5;
delete from Timepair where id = 6; --ошибка
reset role;


--методист
create user second with password 'qwerty2';
grant methodist to second;
set role second;
select last_name, first_name, birthday from Students
    inner join Student_in_class Sic on Students.id = Sic.student
    inner join Class C on C.id = Sic.class
    where c.name = '11А';
insert into subject(id, name) values (10, 'Классный час');
delete from teachers where last_name = 'Ваулина'; --ошибка
reset role;


--ученик
create user third with password 'qwerty3';
grant student to third;
set role third;
select * from shedule;
insert into shedule (id, date, class, number_pair, teacher, subject, classroom)
    values (20, '2019-09-01', 1, 1, 1, 1, 1); --ошибка
select * from teachers; --ошибка
update students
    set last_name = 'Смернов'
    where id  = 1;
update students
    set last_name = 'Смернов'
    where id  = 2; --ошибка
reset role;



drop user first, second, third;
drop owned by director, student, methodist;
drop role director, student, methodist;
drop table class, Timepair, Teachers, Shedule, Students, Student_in_class, Subject, users_students;
drop function students_constraint();



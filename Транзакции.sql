create table books(
    id serial not null
        constraint books_pk
            primary key,
    title text not null,
    amount int not null
);
create unique index books_title_uindex
    on books (title);
alter table books add constraint check_amount check ( amount >= 0  );
insert into books (title, amount) values
    ('Война и Мир', 43),
    ('Прислуга', 15),
    ('Цветы для Элджернона', 5);


-- Atomicity
begin;
    select * from books;
    insert into books (title, amount) values ('Побег из Шоушенка', 2);
    select * from books;
    update books set amount = 0 where title = 'Цветы для Элджернона';
    select * from books;
rollback;
select * from books;


-- Consistency
begin;
    select * from books;
    insert into books (title, amount) values ('Ребекка', 5);
    insert into books (title, amount) values ('Книжный вор', -1); -- ошибка
commit;
select * from books;


-- Isolation
begin; -- первая транзакция
    insert into books (title, amount) values ('Книжный вор', 2);
    select pg_sleep(10);
    update books set amount = 0 where title = 'Книжный вор';
    select pg_sleep(5);
commit;
select * from books;

begin; -- вторая транзакция
    select * from books;
    insert into books (title, amount) values ('Мастер и Маргарита', 4);
    select pg_sleep(5);
    select * from books;
    update books set amount = 3 where title = 'Мастер и Маргарита';
    select pg_sleep(2);
    select * from books;
commit;


-- Durability
begin;
    select * from books;
    update books set amount = 100 where title = 'Прислуга';
    select * from books;
commit;
--отключить и включить в админке
select * from books;

---------------------------------------------------------------------------------------------------------------------

--dirty reads (PG фиксит Dirty reads на всех уровнях изоляции самостоятельно)
begin; -- первая транзакция
    set transaction isolation level read uncommitted;
    insert into books (title, amount) values ('Ребекка', 8);
    update books set amount = 2 where title = 'Ребекка';
    select pg_sleep(10);
rollback;

begin; --вторая транзакция
    select * from books;
commit;



--Non-repeatable reads
begin; -- первая транзакция
    /*set transaction isolation level read uncommitted;*/
    set transaction isolation level repeatable read;
    select pg_sleep(10);
    select * from books; --выйдет изменение из другой транзакции
rollback;

begin; -- вторая транзакция
    insert into books (title, amount)  values ('Гарри Поттер и узник Азкабана', 13);
commit;



-- phantom reads
begin; -- первая транзакция
    /*set transaction isolation level read uncommitted;*/
    set transaction isolation level repeatable read;
    select Max(amount) from books; -- 43
    select pg_sleep(10);
    select Max(amount) from books; -- 200, а должен остаться 43
rollback;

begin; -- вторая транзакция
    insert into books (title, amount) values ('Кэрри', 200);
commit;



--lost update
update books set amount = 10 where title = 'Война и Мир';
begin; -- первая транзакция
    /*set transaction isolation level read uncommitted;*/
    set transaction isolation level serializable;
    update books set amount = amount + amount where title = 'Война и Мир';
    select pg_sleep(10);
commit;
select amount from books where title = 'Война и Мир'; -- выведет 40, а должно 20

begin; -- вторая транзакция
    set transaction isolation level read uncommitted;
    /*set transaction isolation level serializable;*/
    update books set amount = amount + amount where title = 'Война и Мир';
commit;



drop table books;
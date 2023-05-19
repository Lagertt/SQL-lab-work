create table authors(
    id_author   serial
        constraint authors_pk
            primary key,
    namesurname text,
    yearofbirth integer
);
create table books(
    id_book   serial
        constraint books_pk
            primary key,
    yearofrelease    integer,
    title text not null
);
create table bookslist(
    authorname integer not null
        constraint bookslist_authorname___fk
            references authors,
    book       integer not null
        constraint bookslist_book___fk
            references books,
    dateofchange date default CURRENT_DATE not null,
    id_listing serial
        constraint bookslist_pk
            primary key
);

--создание представления
CREATE OR REPLACE VIEW bookslist_view AS
    SELECT namesurname, yearofbirth, title, yearofrelease
    FROM books INNER JOIN bookslist ON books.id_book = bookslist.book
        INNER JOIN authors ON authors.id_author = bookslist.authorname;

--создание очередей для авто-id у вставленных данных
CREATE SEQUENCE booksseq;
CREATE SEQUENCE authorsseq;
CREATE SEQUENCE listsseq;

--триггер на вставку
CREATE OR REPLACE FUNCTION booklist_view_on_insert()
    RETURNS trigger AS $$
    DECLARE
        authorid INTEGER;
        bookid INTEGER;
BEGIN
    if (not exists(select namesurname from authors where namesurname = new.namesurname)) then
        INSERT INTO authors("namesurname","yearofbirth") values (new.namesurname, new.yearofbirth);
    END IF; --add new author
    if (not exists(select title from books where title = new.title)) then
        INSERT INTO books("title", "yearofrelease") values (new.title, new.yearofrelease);
    END IF; --add new book

    SELECT id_author into authorid from authors where namesurname = new.namesurname;
    SELECT id_book into bookid from books where title = new.title;

    --take new book, author
    if (not exists(select book from bookslist where authorname = authorid AND book = bookid)) then
        INSERT INTO bookslist("book","authorname") VALUES (bookid, authorid); --add new booklist
    END IF;
    return new;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS booklist_view_on_insert_trigger ON bookslist_view;
CREATE TRIGGER booklist_view_on_insert_trigger
    INSTEAD OF INSERT
    ON bookslist_view
    FOR EACH ROW
EXECUTE PROCEDURE booklist_view_on_insert();


--триггер на изменение
CREATE OR REPLACE FUNCTION booklist_view_on_update()
RETURNS trigger AS $$
    DECLARE
        bookid INTEGER;
        authorid INTEGER;
        changeid INTEGER;
BEGIN
    if (not exists(select namesurname from authors where namesurname = new.namesurname)) then
        INSERT INTO authors("namesurname","yearofbirth") values (new.namesurname, new.yearofbirth);
    END IF; --add new author
    if (not exists(select title from books where title = new.title)) then
        INSERT INTO books("title", "yearofrelease") values (new.title, new.yearofrelease);
    END IF; --add new book

    SELECT id_listing into changeid from bookslist
        INNER JOIN authors ON authors.id_author = bookslist.authorname
        INNER JOIN books ON books.id_book = bookslist.book
    where books.title = old.title AND authors.namesurname = old.namesurname;

    --получение новых id
    SELECT id_author into authorid from authors where authors.namesurname = new.namesurname;
    SELECT id_book into bookid from books where books.title = new.title; --take new book and author id's

    --обновление id в связке
    UPDATE bookslist SET authorname = authorid, book = bookid WHERE id_listing = changeid; --update data in
    return new;
END;
$$ LANGUAGE plpgsql;
DROP TRIGGER IF EXISTS booklist_view_on_update_trigger ON bookslist_view;
CREATE TRIGGER booklist_view_on_update_trigger
    INSTEAD OF UPDATE
    ON bookslist_view
    FOR EACH ROW
EXECUTE PROCEDURE booklist_view_on_update();



--тело триггера на удаление
CREATE OR REPLACE FUNCTION booklist_view_on_delete()
    RETURNS trigger AS $$
    DECLARE changeid INTEGER;
BEGIN
    --search recent data
    SELECT id_listing into changeid from bookslist
        INNER JOIN authors ON authors.id_author = bookslist.authorname
        INNER JOIN books ON books.id_book = bookslist.book
    where books.title = old.title AND authors.namesurname = old.namesurname;

    DELETE FROM bookslist WHERE id_listing = changeid; --delete recent data from booklist
    return new;
END;
$$ Language plpgsql;
DROP TRIGGER IF EXISTS booklist_view_on_delete_trigger ON bookslist_view;
CREATE TRIGGER booklist_view_on_delete_trigger
    INSTEAD OF DELETE
    ON bookslist_view
    FOR EACH ROW
EXECUTE PROCEDURE booklist_view_on_delete();


--простая вставка
INSERT INTO bookslist_view("namesurname", "yearofbirth", "title", "yearofrelease")
    VALUES ('Лев Толстой', 1828, 'Война и мир', 1867);
INSERT INTO bookslist_view("namesurname", "yearofbirth", "title", "yearofrelease")
    VALUES ('Николай Гоголь', 1809, 'Вий', 1833);

--вставка существующей записи
INSERT INTO bookslist_view("namesurname", "yearofbirth", "title", "yearofrelease")
    VALUES ('Николай Гоголь', 1809, 'Вий', 1833);
--вставка, инициирующая работу Insert-триггера
INSERT INTO bookslist_view("namesurname", "yearofbirth", "title", "yearofrelease")
    VALUES ('Лев Толстой', 1828, 'Анна Каренина', 1878);
--обновление, инициирующее работу Update-триггера
UPDATE bookslist_view SET
    title = 'Тарас Бульба', yearofrelease = 1842
WHERE namesurname = 'Николай Гоголь';
--удаление, инициирующее работу Delete-триггера
DELETE FROM bookslist_view WHERE namesurname = 'Николай Гоголь';




--очистка БД и обновление счётчиков
DELETE FROM bookslist;
DELETE FROM authors;
DELETE FROM books;
ALTER SEQUENCE booksseq RESTART WITH 1;
ALTER SEQUENCE authorsseq RESTART WITH 1;
ALTER SEQUENCE listsseq RESTART WITH 1;

drop view bookslist_view;
drop routine booklist_view_on_delete();
drop routine booklist_view_on_insert();
drop routine booklist_view_on_update();
drop sequence booksseq, authorsseq, listsseq;
drop table books, authors, bookslist;







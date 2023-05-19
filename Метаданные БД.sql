create table special_table
(
    id integer,
    table_name char(15),
    column_name char(15),
    current_max_value integer
);
insert into special_table values (1, 'special_table', 'id', 1);

CREATE EXTENSION pgcrypto;

--хранимая процедура
CREATE OR REPLACE FUNCTION proc_lab(NameTable char(15), NameColumn char(15))
    RETURNS integer AS $$
    DECLARE NextValue integer;
    DECLARE NameAndGUID text;
    DECLARE guid text;
    -- переменная для количества триггеров
    DECLARE trig_count integer;
    --
BEGIN
    -- обращение к метаданным и вывод ошибок
    IF (NOT exists (SELECT table_name FROM information_schema.tables
                WHERE table_schema = 'public' AND
                      table_name = NameTable))
        THEN RAISE 'uncorrect table name';
    ELSEIF (NOT exists (SELECT column_name FROM information_schema.columns
                WHERE table_schema = 'public' AND
                      table_name = NameTable AND
                      column_name = NameColumn))
        THEN RAISE 'uncorrect column name';
    ELSEIF ((SELECT data_type FROM information_schema.columns
             WHERE table_schema = 'public' AND
                   table_name = NameTable AND
                   column_name = NameColumn) <> 'integer')
        THEN RAISE 'uncorrect field type';
    END IF;
    --
    SELECT current_max_value+1 into NextValue FROM special_table
    WHERE table_name = NameTable AND column_name = NameColumn;
    IF (NextValue is NULL) THEN
    BEGIN
        -- составление названия для триггера (если
        trig_count = (SELECT count(tgname) FROM pg_trigger);
        IF (trig_count is NULL) THEN
            NameAndGUID = NameTable || '_' || NameColumn || '_' || '1';
        ELSE
            NameAndGUID = NameTable || '_' || NameColumn || '_' || trig_count + 1;
        END IF;
        -- если такой тригер уже существует среди элементов БД, то генерация GUID
        IF (exists (SELECT * FROM (SELECT current_catalog as NaG UNION --имя БД
                                   SELECT current_schema as NaG UNION --имя схемы
                                   SELECT distinct table_name as NaG FROM information_schema.columns
                                       WHERE table_schema = 'public' UNION --имена таблиц
                                   SELECT distinct column_name as NaG FROM information_schema.columns
                                       WHERE table_schema = 'public' UNION --имена столбцов
                                   SELECT tgname as NaG FROM pg_trigger) as A
                    WHERE NaG = NameAndGUID))
        THEN
            SELECT gen_random_uuid() INTO guid;
            NameAndGUID = NameTable || '_' || NameColumn || '_' || guid;
        END IF;
        --

        EXECUTE 'create trigger "' || NameAndGUID || '" after insert or update or delete on ' || NameTable ||
        ' for each row execute procedure trig(' || NameColumn || ', ' || NameTable || ')';
        EXECUTE format('select max(%s) from %s', quote_ident(NameColumn), quote_ident(NameTable)) INTO NextValue;
        IF (NextValue is NULL ) THEN
            NextValue = 1;
        ELSE
            NextValue = NextValue + 1;
        END IF;
        INSERT INTO special_table VALUES (proc_lab('special_table', 'id'), NameTable, NameColumn, NextValue);
    END;
    ELSE
        UPDATE special_table SET current_max_value = NextValue
        WHERE table_name = NameTable AND column_name = NameColumn;
    END IF;
    RETURN  NextValue;
END;
$$ LANGUAGE 'plpgsql';

--тело триггера
CREATE OR REPLACE FUNCTION trig()
    RETURNS trigger AS $$
    DECLARE NextValueSec INTEGER;
BEGIN
    raise NOTICE '%', tg_argv[0]; --NameColumn
    raise NOTICE '%', TG_TABLE_NAME; --NameTable
    EXECUTE format('select max(%s) from %s', quote_ident(tg_argv[0]), quote_ident(TG_TABLE_NAME))
        INTO NextValueSec;
    if (NextValueSec is NULL) THEN
        NextValueSec = 1;
    end if;
    UPDATE special_table SET current_max_value = NextValueSec
    WHERE table_name = TG_TABLE_NAME AND column_name = tg_argv[0];
    RETURN new;
END;
$$ LANGUAGE 'plpgsql';

create table test
(
    num1 integer not null,
    num2 integer not null,
    num3 integer not null,
    test_num3_3 integer not null,
    num4 text not null
);


--создаются триггеры test_num1_1 и test_num1_2
select * from proc_lab('test', 'num1');

select * from proc_lab('test', 'num2');

--создание повторного триггера (в таблице заранее создано поле test_num3_3)
select * from proc_lab('test', 'num3');

--вызов несуществующей таблицы
select * from proc_lab('hophey', 'num1');
--вызов несуществующего столбца
select * from proc_lab('test', 'hophey');
--вызов не числовой ячейки
select * from proc_lab('test', 'testnum3');

drop table special_table, test;
drop function public.proc_lab(nametable char, namecolumn char);
drop function public.trig();
drop extension pgcrypto;





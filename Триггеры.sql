create table special_table
(
    id integer,
    table_name char(10),
    column_name char(10),
    current_max_value integer
);
insert into special_table values (1, 'spec', 'id', 1);

CREATE EXTENSION pgcrypto;

CREATE OR REPLACE FUNCTION proc_lab(NameTable char(10), NameColumn char(10))
    RETURNS integer AS $$
    DECLARE NextValue integer;
    --
    DECLARE NameAndGUID text;
    DECLARE guid text;
    --
BEGIN
    SELECT current_max_value+1 into NextValue FROM special_table
    WHERE table_name = NameTable AND column_name = NameColumn;
    IF (NextValue is NULL) THEN
    BEGIN
        --генерация UUID и создание триггера
        SELECT gen_random_uuid() INTO guid;
        NameAndGUID = NameTable || '_' || NameColumn || '_' || guid;
        EXECUTE 'create trigger "' || NameAndGUID || '" after insert or update or delete on ' || NameTable ||
        ' for each row execute procedure trig(' || NameColumn || ', ' || NameTable || ')';
        --
        EXECUTE format('select max(%s) from %s', quote_ident(NameColumn), quote_ident(NameTable)) INTO NextValue;
        IF (NextValue is NULL ) THEN
            NextValue = 1;
        ELSE
            NextValue = NextValue + 1;
        END IF;
        INSERT INTO special_table VALUES (proc_lab('spec', 'id'), NameTable, NameColumn, NextValue);
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
    num3 integer not null
);

select * from proc_lab('test', 'num1');
select * from proc_lab('test', 'num2');
select * from proc_lab('test', 'num3');

insert into test values (2, 3, 4);
update test set num1 = 17 where num1 = 2;
delete from test where num1 = (select MAX(num1) from test);

drop table special_table, test;
drop function public.proc_lab(nametable char, namecolumn char);
drop function public.trig();
drop extension pgcrypto;





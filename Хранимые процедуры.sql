--1
create table special_table
(
    id integer,
    table_name char(10),
    column_name char(10),
    current_max_value integer
);

--2
insert into special_table values (1, 'spec', 'id', 1);

--3
CREATE OR REPLACE FUNCTION proc_lab(NameTable char(10), NameColumn char(10))
    RETURNS integer AS $$
    DECLARE NextValue integer;
BEGIN
    SELECT current_max_value+1 into NextValue FROM special_table
    WHERE table_name = NameTable AND column_name = NameColumn;
    IF (NextValue is NULL) THEN
    BEGIN
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
        Where table_name = NameTable AND column_name = NameColumn;
    END IF;
    RETURN  NextValue;
END;
$$ LANGUAGE 'plpgsql';

--4
select proc_lab('spec', 'id');

--5
select * from special_table;

--6
select proc_lab('spec', 'id');

--7
select * from special_table;

--8
create table test
(
    id integer
);

--9
insert into test values (10);

--10
select proc_lab('test', 'id');

--11
select * from special_table;

--12
select proc_lab('test', 'id');

--13
select * from special_table;

--14
create table test2
(
    numbValue1 integer,
    numbValue2 integer
);

--15
select proc_lab('test2', 'numbvalue1');

--16
select * from special_table;

--17
select proc_lab('test2', 'numbvalue1');

--18
select * from special_table;

--19
insert into test2 values (20, 13);

--20
select proc_lab('test2', 'numbvalue2');

--21
select * from special_table;

--22
drop table special_table, test, test2;

--23
drop function public.proc_lab(char, char);
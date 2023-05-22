# SQL-lab-work

Данный репозиторий - это сборник лабораторных работ по предмету "БД и СУБД", все скрипты написаны на Postgres SQL. 

## 1. Хранимые процедуры
Здесь реализована хранимая процедура, которая возвращает следующее число в столбце. Для этого используется отдельная специальная таблица, содержащая столбцы `id`, `имя таблицы`, `имя столбца`, `текущее максимально значение`. Пользователь передаёт в функцию параметром имя таблицы и имя столбца. ХП ищет, есть ли такая запись в специальной таблице. Если запись есть, то значение инкрементируется, после чего возвращается пользователю. Если такой записи нет, ХП сперва ищет максимальное число в столбце в запрашиваемой таблице, записывает новую строку, содержащую следующее за найденным число, в специальную таблицу и возвращает это значение пользователю. При отсутствии значений в запрашиваемой таблице пользователю возвращается 1, и этот же результат записывается в специальную таблицу. Следующий идентификатор для новой строки в специальной таблице формируется рекурсивным вызовом разработанной ХП.
 
## 2. Триггеры
Это продолжение первой работы (хранимые процедуры). Здесь реализован тригер для решения проблемы рассогласованности спец. таблицы и отслеживаемой таблицы в случае, если в последнюю были внесены изменения в обход разработанной ранее хранимой процедуры (ХП). Для этого автоматически создаётся триггер для таблицы, имя которой передаётся в ХП в качестве параметра для каждой новой уникальной пары 'имя таблицы' + 'имя столбца’
 
## 3. Метаданные БД
Это продолжение второй работы (триггеры). Здесь реализовано решение проблемы неконтролируемых ошибок разработанной ранее хранимой процедуры (ХП) в случае, если в качестве параметров передана несуществующая таблица, несуществующий столбец существующей таблицы или столбец, который не имеет целочисленный тип, посредством проверки корректности параметров на основе метаданных базы данных. В случае некорректности параметров самостоятельно порождается ошибку.
 
## 4. Модификация представлений 
Здесь создана и наполнена база данных, содержащая связь типа М:М. Связь, помимо внешних ключей, имеет дополнительный атрибут. Создано представление, объединяющее таблицы, соединенных связью М:М, но не включающее идентификаторы. Написаны триггеры для представления, которые:
- при вставке нового отношения вставляют новые записи в исходные таблицы, если они там ранее отсутствовали;
- при обновлении обновляют соответствующие записи в таблице-связке;
- при удалении удаляют соответствующие записи в таблице-связке.
 
## 5. Транзакции
Здесь продемонстрирована выполняемость всех основных свойств транзакций (ACID).
-	Для A проведены операции добавления и изменения, затем их откатили и убедились, что они полностью откатились.
-	Для C создана таблица с ограничением на столбец, проведена транзакция, приводящая к несогласованности, и мы убедились, что она откатилась.
-	Для I параллельно запущены несколько транзакций, мы посмотрели, как они все отработают.
-	Для D во время работы транзакции аварийно завершается работа сервера, перезапускается, и можно убедиться, что применились изменения.

Также здесь приведены примеры для всех 4 проблем параллельного доступа:
- Dirty reads
- Non-repeatable reads
- Phantom reads
- Lost update


## 6. Права доступа
Для спроектированной ранее базы данных предметной области (у меня была школа и её расписание) реализованы категории пользователей и их права (директор, ученик, методист), они настроены на уровне СУБД. Продемонстрировано различие в возможностях созданных пользователей и владельца базы данных.






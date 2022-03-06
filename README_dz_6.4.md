# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---
## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Ответ
Находим на доекр-хабе postgres 13 Версии https://hub.docker.com/_/postgres?tab=tags.
Качаем образ:
```bash
user1@devopserubuntu:~$ sudo docker pull postgres:13
13: Pulling from library/postgres
f7a1c6dad281: Pull complete
77c22623b5a6: Pull complete
0f6a6a85d014: Pull complete
6012728e8256: Pull complete
1eca9143e721: Pull complete
598625d1c828: Pull complete
ec548f0dc89b: Pull complete
10c57d7e0b40: Pull complete
95454d1656a1: Pull complete
c34c7315d399: Pull complete
2ef684062cb7: Pull complete
643d029e7e08: Pull complete
8936e052b070: Pull complete
Digest: sha256:5bc010bbb524bef645ab7930e0a198625d1acfc8bdb69c460b030840b0911e3f
Status: Downloaded newer image for postgres:13
docker.io/library/postgres:13

user1@devopserubuntu:~$ sudo docker images postgres
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
postgres     13        42878d8cabb3   2 days ago    371MB
postgres     latest    6a3c44872108   2 weeks ago   374MB
postgres     13.5      e01c76bb1351   5 weeks ago   371MB
```
Изготавливаем файл для docker-compose:
```bash
user1@devopserubuntu:~$ cat docker-compose.yaml
version: '2.1'

# определяем сеть для контейнера
networks:
  mynetwork:
    driver: bridge

# анонсируем, какие хранилища (volume) будут доступны контейнеру
volumes:
    postgres_data: {}
    postgres_backup: {}

services:
# описываем наш контейнер с postgres
  postgres:
    image: postgres:13
    container_name: mypostgres_v13
# указываем какие локальные папки станут хранилищами для контейнера
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
      - ./postgres_backup:/postgres_backup
    restart: always
# задаём переменные окружения для того, чтобы контейнер при запуске использовал из для инициализаци СУБД
    environment:
      - POSTGRES_USER=admin
      - POSTGRES_PASSWORD=123456
      - POSTGRES_DB=mydb
# указываем сеть для подключения
    networks:
      - mynetwork
# указываем, какой порт будет проброшен в контейнер
    ports:
      - "0.0.0.0:5432:5432"
```
Запускаем контейнер, смотрим, что он запустился и ошибок в логе нет:
```bash
user1@devopserubuntu:~$ sudo docker-compose up -d
Starting mypostgres_v13 ... done


user1@devopserubuntu:~$ sudo docker-compose ps -a
     Name                   Command              State           Ports
-------------------------------------------------------------------------------
mypostgres_v13   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp


user1@devopserubuntu:~$ sudo sudo docker logs --tail 10 mypostgres_v13
server stopped

PostgreSQL init process complete; ready for start up.

2022-03-05 10:43:16.872 UTC [1] LOG:  starting PostgreSQL 13.6 (Debian 13.6-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
2022-03-05 10:43:16.872 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2022-03-05 10:43:16.872 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2022-03-05 10:43:16.875 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2022-03-05 10:43:16.878 UTC [64] LOG:  database system was shut down at 2022-03-05 10:43:16 UTC
2022-03-05 10:43:16.882 UTC [1] LOG:  database system is ready to accept connections
```
Подключаемся к этому экземпляру postgres с хостовой машины:
```bash
user1@devopserubuntu:~$ psql -h 10.20.8.77 -p 5432 -d mydb -U admin -W
Password:
psql (13.5 (Ubuntu 13.5-0ubuntu0.21.10.1), server 13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

mydb=#
```
Посмотрим, какие есть команды:
```bash
mydb=# \?
  \dn[S+] [PATTERN]      list schemas
  \do[S+] [PATTERN]      list operators
  \dO[S+] [PATTERN]      list collations
  \dp     [PATTERN]      list table, view, and sequence access privileges
  \dP[itn+] [PATTERN]    list [only index/table] partitioned relations [n=nested]
  \drds [PATRN1 [PATRN2]] list per-database role settings
  \dRp[+] [PATTERN]      list replication publications
  \dRs[+] [PATTERN]      list replication subscriptions
  \ds[S+] [PATTERN]      list sequences
  \dt[S+] [PATTERN]      list tables
  \dT[S+] [PATTERN]      list data types
  \du[S+] [PATTERN]      list roles
  \dv[S+] [PATTERN]      list views
  \dx[+]  [PATTERN]      list extensions
  \dy[+]  [PATTERN]      list event triggers
  \l[+]   [PATTERN]      list databases
  \sf[+]  FUNCNAME       show a function's definition
  \sv[+]  VIEWNAME       show a view's definition
  \z      [PATTERN]      same as \dp

Formatting
  \a                     toggle between unaligned and aligned output mode
  \C [STRING]            set table title, or unset if none
  \f [STRING]            show or set field separator for unaligned query output
  \H                     toggle HTML output mode (currently off)
  \pset [NAME [VALUE]]   set table output option
                         (border|columns|csv_fieldsep|expanded|fieldsep|
                         fieldsep_zero|footer|format|linestyle|null|
                         numericlocale|pager|pager_min_lines|recordsep|
                         recordsep_zero|tableattr|title|tuples_only|
                         unicode_border_linestyle|unicode_column_linestyle|
                         unicode_header_linestyle)
  \t [on|off]            show only rows (currently off)
  \T [STRING]            set HTML <table> tag attributes, or unset if none
  \x [on|off|auto]       toggle expanded output (currently off)

Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "mydb")
  \conninfo              display information about current connection
  \encoding [ENCODING]   show or set client encoding
  \password [USERNAME]   securely change the password for a user

Operating System
  \cd [DIR]              change the current working directory
  \setenv NAME [VALUE]   set or unset environment variable
  \timing [on|off]       toggle timing of commands (currently off)
  \! [COMMAND]           execute command in shell or start interactive shell

Variables
  \prompt [TEXT] NAME    prompt user to set internal variable
  \set [NAME [VALUE]]    set internal variable, or list all if no parameters
  \unset NAME            unset (delete) internal variable

Large Objects
  \lo_export LOBOID FILE
  \lo_import FILE [COMMENT]
  \lo_list
  \lo_unlink LOBOID      large object operations
```
- вывод списка БД
```bash
mydb=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
-----------+-------+----------+------------+------------+-------------------
 mydb      | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
(4 rows)
```
- подключение к БД
```bash
mydb=# \c postgres
Password:
psql (13.5 (Ubuntu 13.5-0ubuntu0.21.10.1), server 13.6 (Debian 13.6-1.pgdg110+1))
You are now connected to database "postgres" as user "admin".
postgres=#
```
- вывод списка таблиц (пример из позапрошлого ДЗ)
```bash
test_db=# \dt+;
                           List of relations
 Schema |  Name   | Type  | Owner | Persistence |  Size   | Description
--------+---------+-------+-------+-------------+---------+-------------
 public | clients | table | admin | permanent   | 0 bytes |
 public | orders  | table | admin | permanent   | 0 bytes |
(2 rows) 
```
- вывода описания содержимого таблиц. Описание таблицы из позапрошлого ДЗ
```bash
test_db=# \d+ clients;
                                                     Table "public.clients"
   Column   |     Type      | Collation | Nullable |               Default               | Storage  | Stats target | Description
------------+---------------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id         | integer       |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 secondname | character(20) |           |          |                                     | extended |              |
 country    | character(20) |           |          |                                     | extended |              |
 order_id   | integer       |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap 
```
- выхода из psql
```bash
mydb=# \q
user1@devopserubuntu:~$  
```

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### Ответ
Создаём базу данных:
```bash
mydb=# create database test_database;
CREATE DATABASE
```
На хостовой машине скачиваем бекап базы в папку, которая также смонтирована в контейнер:
```bash
root@devopserubuntu:/home/user1/postgres_backup# wget https://raw.githubusercontent.com/netology-code/virt-homeworks/virt-11/06-db-04-postgresql/test_data/test_dump.sql
--2022-03-05 11:41:23--  https://raw.githubusercontent.com/netology-code/virt-homeworks/virt-11/06-db-04-postgresql/test_data/test_dump.sql
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.109.133, 185.199.108.133, 185.199.110.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.109.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2082 (2.0K) [text/plain]
Saving to: ‘test_dump.sql’

test_dump.sql                                   100%[=====================================================================================================>]   2.03K  --.-KB/s    in 0s

2022-03-05 11:41:24 (27.4 MB/s) - ‘test_dump.sql’ saved [2082/2082]
```
Заглянем внутрь файла sql-бекапа. Видим там упоминание о роли postgres. Проверяем, есть ли такой пользователь у нас в СУБД:
```bash
user1@devopserubuntu:~$ psql -h 10.20.8.77 -p 5432 -d mydb -U admin -W
Password:
psql (13.5 (Ubuntu 13.5-0ubuntu0.21.10.1), server 13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

mydb=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 admin     | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
```
Видим, что нет. Значит его надо создать иначе будут проблемы:
```bash
mydb=# create user postgres password '123456';
CREATE ROLE

mydb=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 admin     | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 postgres  |                                                            | {}
```
Теперь можно попробовать влить этот бекап в нашу новуб БД (делаем с хостовой машины):
```bash
user1@devopserubuntu:~$ psql -h 10.20.8.77 -p 5432 -d test_database -U admin -W < postgres_backup/test_dump.sql
Password:
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
Теперь подключимся к нашей новой БД под новый юзером, запустив psql внутри контейнера:
```bash
user1@devopserubuntu:~$ sudo docker exec -it mypostgres_v13 psql -h 10.20.8.77 -p 5432 -d test_database -U postgres -W
Password:
psql (13.6 (Debian 13.6-1.pgdg110+1))
Type "help" for help.

test_database=> \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=> select * from orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)
```
Ок. таблицу видим и данные в ней тоже.

Запускаем процедуру анализа таблицы, а затем, изучив информацию о представлении [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), делаем запрос столбца, содержащего средний размер данных, содержащихся в столбцах таблицы. 
```bash
test_database=> ANALYZE orders;
ANALYZE

test_database=> select attname,avg_width from pg_stats where tablename='orders';
 attname | avg_width
---------+-----------
 id      |         4
 title   |        16
 price   |         4
(3 rows)
```
Видно, что в таблице в столбце title содержатся данные с самой большим средним объёмом. Но попробуем получить это запросом:
```bash
test_database=> select max(avg_width) from pg_stats where tablename='orders';
 max
-----
  16
(1 row)
```
Да, так мы нашли максимальное значение, но что за столбец его содержит не понятно. Поэтому сделаем сложный запрос с вложением. Чтобы получить аналог предпоследнего результата, но чтобы вывелся столбей и размер только тот, который максимальный.
```bash
test_database=> select  attname, avg_width from pg_stats where tablename='orders' AND avg_width=(select max(avg_width) from pg_stats where tablename='orders');
 attname | avg_width
---------+-----------
 title   |        16
(1 row)
```
Получилось.

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

### Ответ
Задача сделать вертикальный шардинг таблицы. то есть как бы разбить таблицу на 2 основываясь на цене.
При этом у нас должна получиться схема, когда у нас есть старая базовая таблица, но при попытке вносить в неё данные, они должны оправляться в одну или другую партиционную таблицу.

Для выполнения этой задачи воспользовался материалом из этой [статьи](https://habr.com/ru/company/oleg-bunin/blog/309330/).

Посмотрим на устройство базовой таблицы:
```bash
test_database=> \d+ orders
                                                       Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character varying(80) |           | not null |                                    | extended |              |
 price  | integer               |           |          | 0                                  | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Access method: heap
```
Мы должны создать партиционные таблицы:
```bash
test_database=> CREATE TABLE orders_1 ( CHECK ( price > 499 ) ) INHERITS ( orders);
CREATE TABLE
test_database=> CREATE TABLE orders_2 ( CHECK ( price <= 499 ) ) INHERITS ( orders);
CREATE TABLE
```
Посмотрим, что у нас получилось:
```bash
test_database=> \dt+
                               List of relations
 Schema |   Name   | Type  |  Owner   | Persistence |    Size    | Description
--------+----------+-------+----------+-------------+------------+-------------
 public | orders   | table | postgres | permanent   | 8192 bytes |
 public | orders_1 | table | postgres | permanent   | 0 bytes    |
 public | orders_2 | table | postgres | permanent   | 0 bytes    |
(3 rows)
```
Посмотрим на устройство таблиц:
```bash
test_database=> \d+ orders
                                                       Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character varying(80) |           | not null |                                    | extended |              |
 price  | integer               |           |          | 0                                  | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Child tables: orders_1,
              orders_2
Access method: heap


test_database=> \d+ orders_1
                                                      Table "public.orders_1"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character varying(80) |           | not null |                                    | extended |              |
 price  | integer               |           |          | 0                                  | plain    |              |
Check constraints:
    "orders_1_price_check" CHECK (price > 499)
Inherits: orders
Access method: heap


test_database=> \d+ orders_2
                                                      Table "public.orders_2"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character varying(80) |           | not null |                                    | extended |              |
 price  | integer               |           |          | 0                                  | plain    |              |
Check constraints:
    "orders_2_price_check" CHECK (price <= 499)
Inherits: orders
Access method: heap
```
Видим, что партиции устроены также, но в них отсутствует Индекс- основной ключ, который есть у базовой таблицы. Индексы, ограничения и триггеры не наследуются, поэтому надо создать индексы. Индекс с тем же именем нам создать не дали, поэтому делаем другие имена:
```bash
test_database=> ALTER TABLE ONLY orders_1 ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
ERROR:  relation "orders_pkey" already exists

test_database=> ALTER TABLE ONLY orders_1 ADD CONSTRAINT orders_1_pkey PRIMARY KEY (id);
ALTER TABLE
test_database=> ALTER TABLE ONLY orders_2 ADD CONSTRAINT orders_2_pkey PRIMARY KEY (id);
ALTER TABLE
```
Теперь необходимо сделать так, чтобы при внесении данных в нашу базовую таблицу, записи раскидывались по партициям автоматически в соответствии со значением.

Нужно создать правила:
```bash
test_database=> CREATE RULE order_insert_to_1 AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_1 VALUES ( NEW.* );
CREATE RULE
test_database=> CREATE RULE order_insert_to_2 AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_2 VALUES ( NEW.* );
CREATE RULE
```
Хочется отметить, что базовая таблица не потеряла возможность также хранить данные. Если (правда в нашем примере это не возможно) вдруг попытаться внести элемент с значением price, не удовлетворяющим ни одному условию, то он останется хранитьмя в базовой таблице.

Хотя нам никто не запрещает читать и писать в таблицу orders, то есть данные будут автоматически считываться и вноситься в нужную партицию.

Вернёмся к нашей задаче. у нас же данные все лежат в базовой таблице, они никуда от туда не переедут сами. А партиционные таблицы пустые:
```bash
test_database=> SELECT * FROM orders;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  2 | My little database   |   500
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  6 | WAL never lies       |   900
  7 | Me and my bash-pet   |   499
  8 | Dbiezdmin            |   501
(8 rows)

test_database=> SELECT * FROM orders_1;
 id | title | price
----+-------+-------
(0 rows)

test_database=> SELECT * FROM orders_2;
 id | title | price
----+-------+-------
(0 rows)
```
Получается, чтобы разнести данные по партиционным таблицам, надо все данные заново внести. Делать это будем в одной транзакции.
Предлагаю создать временную табличку `temp_orders` со структурой как у `orders`, перелить в неё все данные, таблицу `orders` очистить. Затем удаляем временную таблицу. 

```bash
begin
CREATE TABLE public.temp_orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
INSERT INTO temp_orders (id, title, price) SELECT * FROM orders;
DELETE FROM orders;
INSERT INTO orders (id, title, price) SELECT * FROM temp_orders;
DROP TABLE temp_orders;
COMMIT;
```
Выполняем:
```bash
test_database=> BEGIN;
CREATE TABLE public.temp_orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
INSERT INTO temp_orders (id, title, price) SELECT * FROM orders;
DELETE FROM orders;
INSERT INTO orders (id, title, price) SELECT * FROM temp_orders;
DROP TABLE temp_orders;
COMMIT;

BEGIN
CREATE TABLE
INSERT 0 8
DELETE 8
INSERT 0 0
DROP TABLE
COMMIT
```
Всё прошло без ошибок. Смотрим что творится в таблицах:
```bash
test_database=> SELECT * FROM orders ;
 id |        title         | price
----+----------------------+-------
  2 | My little database   |   500
  6 | WAL never lies       |   900
  8 | Dbiezdmin            |   501
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(8 rows)

test_database=> SELECT * FROM orders_1 ;
 id |       title        | price
----+--------------------+-------
  2 | My little database |   500
  6 | WAL never lies     |   900
  8 | Dbiezdmin          |   501
(3 rows)

test_database=> SELECT * FROM orders_2 ;
 id |        title         | price
----+----------------------+-------
  1 | War and peace        |   100
  3 | Adventure psql time  |   300
  4 | Server gravity falls |   300
  5 | Log gossips          |   123
  7 | Me and my bash-pet   |   499
(5 rows)
```
Круто! Получилось. Базовая таблица как ни в чём не бывало показывает что все данные в ней, но на самом деле они распределились по партициям.
Если честно, в задании не совсем понятно, надо ли было включать в транзакцию и само разбиение таблицы. На мой взгляд это лишено смысла.
Более логично было сделать так, как я и сделал. Разборки с шардированием отдельно, а перезаливка данных в одной транзакции.

Конечно можно было на этапе проектирования и изначального создания БД учесть необходимость шардирования таблицы.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

###Ответ
Делаем бекап базы внутри контейнера в паку, смонтированную из хостовой машины:
```bash
user1@devopserubuntu:~$ sudo docker exec -it mypostgres_v13 bash -c "pg_dump -h 10.20.8.77 -p 5432 -d test_database -U postgres -W > /postgres_backup/test_database_backup.sql"
Password:
```
На всякий случай уточню, что конструкция `bash -c " команда > файл  "` используется из-за того, что в `exec` не удаётся иначе передать команды с указанием перенаправления `>` `<`.

Смотрим наличие бекапа на хостовой машине
```bash
user1@devopserubuntu:~$ ls -la /home/user1/postgres_backup/test_database*
-rw-r--r-- 1 root root 4414 Mar  6 12:06 /home/user1/postgres_backup/test_database_backup.sql
```

Чтобы сделать уникальным значение столбца `title` надо отредактировать создание таблицы, то есть вместо этого:
```bash
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
```
Сделать это:
```bash
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE NOT NULL,
    price integer DEFAULT 0
);
```
а также (так как индексы не наследуются) и у партиционных таблиц добавить уникальность, там же где добавляются индексы. Добавить:
```bash
ALTER TABLE public.orders_1 ADD UNIQUE (title);
ALTER TABLE public.orders_2 ADD UNIQUE (title);
```
После восстановления должно получиться так:
```bash
test_database=> \d+ orders;
                                                       Table "public.orders"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character varying(80) |           | not null |                                    | extended |              |
 price  | integer               |           |          | 0                                  | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
    "orders_title_key" **UNIQUE** CONSTRAINT, btree (title)
Rules:
    order_insert_to_1 AS
    ON INSERT TO orders
   WHERE new.price > 499 DO INSTEAD  INSERT INTO orders_1 (id, title, price)
  VALUES (new.id, new.title, new.price)
    order_insert_to_2 AS
    ON INSERT TO orders
   WHERE new.price <= 499 DO INSTEAD  INSERT INTO orders_2 (id, title, price)
  VALUES (new.id, new.title, new.price)
Child tables: orders_1,
              orders_2
Access method: heap

test_database=> \d+ orders_1;
                                                      Table "public.orders_1"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character varying(80) |           | not null |                                    | extended |              |
 price  | integer               |           |          | 0                                  | plain    |              |
Indexes:
    "orders_1_pkey" PRIMARY KEY, btree (id)
    "orders_1_title_key" **UNIQUE** CONSTRAINT, btree (title)
Check constraints:
    "orders_1_price_check" CHECK (price > 499)
Inherits: orders
Access method: heap

test_database=> \d+ orders_2;
                                                      Table "public.orders_2"
 Column |         Type          | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+-----------------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer               |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 title  | character varying(80) |           | not null |                                    | extended |              |
 price  | integer               |           |          | 0                                  | plain    |              |
Indexes:
    "orders_2_pkey" PRIMARY KEY, btree (id)
    "orders_2_title_key" **UNIQUE** CONSTRAINT, btree (title)
Check constraints:
    "orders_2_price_check" CHECK (price <= 499)
Inherits: orders
Access method: heap
```
Как мы видим признаки уникальности проставились.

---
# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.


## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

---

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

### Ответ

Идём на https://hub.docker.com/ и находим нужный нам образ для контейнера https://hub.docker.com/_/postgres.
Скачиваем себе на dockerhost этот образ.

```bash
user1@devopserubuntu:~$ sudo docker pull postgres
Using default tag: latest
latest: Pulling from library/postgres
5eb5b503b376: Pull complete
.....
60f2aefbd6d9: Pull complete
98ace1022c39: Pull complete
Digest: sha256:156c50d4b6fe6ea4e4645ccdeabf54fedc59a561bfece047cdf4c26a42deab72
Status: Downloaded newer image for postgres:latest
docker.io/library/postgres:latest
user1@devopserubuntu:~$ sudo docker images
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
postgres          latest    6a3c44872108   2 days ago     374MB
akazand/ansible   2.9.24    885b0988c5e0   2 weeks ago    227MB
debian            latest    04fbdaf87a6a   3 weeks ago    124MB
akazand/mynginx   0.7       fcf6f4373363   3 weeks ago    141MB
mynginx           0.7       fcf6f4373363   3 weeks ago    141MB
mynginx           0.5       2cc6139e76e9   3 weeks ago    141MB
nextcloud         latest    6dfcd73f8597   3 weeks ago    969MB
nginx             latest    605c77e624dd   7 weeks ago    141MB
alpine            3.14      0a97eee8041e   3 months ago   5.61MB
centos            latest    5d0da3dc9764   5 months ago   231MB
```
Видим, что образ `postgres` появился в локальном репозитории.

Если попытаться в лоб создать контейнер, то он не запускается. Точнее запускается и падает.
```bash
user1@devopserubuntu:~$ sudo docker run -d --name mypostgres postgres
96cdbda3a68e16ccdd4fdc31e7e37020d3abfa47a1c088cb37c51a0d6736aedd
user1@devopserubuntu:~$ sudo docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                     PORTS     NAMES
96cdbda3a68e   postgres      "docker-entrypoint.s…"   5 seconds ago   Exited (1) 5 seconds ago             mypostgres
```
 В логе видно почему. Не создан пароль админа :
```bash
user1@devopserubuntu:~$ sudo sudo docker logs --tail 10 mypostgres
       https://www.postgresql.org/docs/current/auth-trust.html
Error: Database is uninitialized and superuser password is not specified.
       You must specify POSTGRES_PASSWORD to a non-empty value for the
       superuser. For example, "-e POSTGRES_PASSWORD=password" on "docker run".

       You may also use "POSTGRES_HOST_AUTH_METHOD=trust" to allow all
       connections without a password. This is *not* recommended.

       See PostgreSQL documentation about "trust":
       https://www.postgresql.org/docs/current/auth-trust.html
```
Удалим контейнер и сделаем первый создание с первым запуском правильно, как рекомендуется:
```bash
user1@devopserubuntu:~$ sudo docker rm mypostgres
mypostgres

user1@devopserubuntu:~$ sudo docker run --name mypostgres -e POSTGRES_PASSWORD=123456 -d postgres
2376c66070bafcdd92d063ca67033ddeadec25456b6a7f3e0f40c80e2dcaceb2
user1@devopserubuntu:~$ sudo docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                     PORTS      NAMES
2376c66070ba   postgres      "docker-entrypoint.s…"   6 seconds ago   Up 5 seconds               5432/tcp   mypostgres
```
Если мы вот так просто создали и запустили контейнер то интересно, где планирует хранить данные этот postgres. Если внутри контейнера, то данные потеряются при остановке.

Проверим:
```bash
user1@devopserubuntu:~$ sudo docker inspect mypostgres
[
    {
        "Id": "2376c66070bafcdd92d063ca67033ddeadec25456b6a7f3e0f40c80e2dcaceb2",
        "Created": "2022-02-17T19:07:19.606968158Z",
        "Path": "docker-entrypoint.sh",
        "Args": [
            "postgres"
        ],
... много текста....
        "Mounts": [
            {
                "Type": "volume",
                "Name": "0d12c24c963d881b25073a1ddc0f1356535613c6e2275e4b1524d6f6cbc7b80f",
                "Source": "/var/lib/docker/volumes/0d12c24c963d881b25073a1ddc0f1356535613c6e2275e4b1524d6f6cbc7b80f/_data",
                "Destination": "/var/lib/postgresql/data",
                "Driver": "local",
                "Mode": "",
                "RW": true,
                "Propagation": ""
            }
        ],
......
```
Как мы видим образ для postgres заранее создан так, что в него монтируется папка с докер-хоста в качестве папки `/var/lib/postgresql/data` для хранения БД.

Теперь мы вспоминаем, что нас просили смонтировать в контейнер две паки с хостовой машины для хранения БД и для бекапов. То есть нам надо настроить монтирование локальной папки `postgres_db` в качестве `/var/lib/postgresql/data`, а также смонтировать ещё одну папку для бекапов.

Принято решение воспользоваться `docker-compose`. Устанавливаем его на хостовую машину:
```bash
root@devopserubuntu:/home/user1# curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose && chmod +x /usr/bin/docker-compose
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   664  100   664    0     0   2813      0 --:--:-- --:--:-- --:--:--  2813
100 12.1M  100 12.1M    0     0  3569k      0  0:00:03  0:00:03 --:--:-- 4484k

root@devopserubuntu:/home/user1# docker-compose -v
docker-compose version 1.29.2, build 5becea4c
```
Теперь необходимо создать файл-манифест, в котором описан наш контейнер с postgres. Пришлось повозиться, но получилось:
```yaml
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
    image: postgres:13.5
    container_name: mypostgres_w_vols
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
Теперь стартуем контейнер. И посмотрим запущен ли он, какие внутри работают процессы и его лог, нет ли ошибок.
```bash
user1@devopserubuntu:~$ sudo docker-compose up -d
Creating network "user1_mynetwork" with driver "bridge"
Creating mypostgres_w_vols ... done

user1@devopserubuntu:~$ sudo docker-compose ps -a
      Name                     Command              State           Ports
----------------------------------------------------------------------------------
mypostgres_w_vols   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp

user1@devopserubuntu:~$ sudo docker-compose top
mypostgres_w_vols
  UID        PID      PPID     C   STIME   TTY     TIME                      CMD
--------------------------------------------------------------------------------------------------
systemd+   1157725   1157707   0   20:34   ?     00:00:00   postgres
systemd+   1157813   1157725   0   20:34   ?     00:00:00   postgres: checkpointer
systemd+   1157814   1157725   0   20:34   ?     00:00:00   postgres: background writer
systemd+   1157815   1157725   0   20:34   ?     00:00:00   postgres: walwriter
systemd+   1157816   1157725   0   20:34   ?     00:00:00   postgres: autovacuum launcher
systemd+   1157817   1157725   0   20:34   ?     00:00:00   postgres: stats collector
systemd+   1157818   1157725   0   20:34   ?     00:00:00   postgres: logical replication launcher

user1@devopserubuntu:~$ sudo sudo docker logs --tail 10 mypostgres_w_vols
PostgreSQL init process complete; ready for start up.
2022-02-18 09:15:35.815 UTC [1] LOG:  starting PostgreSQL 13.5 (Debian 13.5-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
2022-02-18 09:15:35.815 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2022-02-18 09:15:35.815 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2022-02-18 09:15:35.817 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2022-02-18 09:15:35.822 UTC [65] LOG:  database system was shut down at 2022-02-18 09:15:35 UTC
2022-02-18 09:15:35.826 UTC [1] LOG:  database system is ready to accept connections
```
Посмотрим слушается ли порт на хостовой машине:
```bash
user1@devopserubuntu:~$ netstat -apn | grep 5432
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 0.0.0.0:5432            0.0.0.0:*               LISTEN      -
```
Отлично. Попробуем подключиться:
```bash
user1@devopserubuntu:~$ psql -h 10.20.8.77 -p 5432 -d mydb -U admin
Password for user admin:
psql (13.5 (Ubuntu 13.5-0ubuntu0.21.10.1))
Type "help" for help.

mydb=#
```
Если посмотреть содержимое примонтированной папки то видно, что `postgres` там развернулся по полной.
```bash
user1@devopserubuntu:~$ sudo ls -la postgres_data/
total 128
drwx------ 19 systemd-coredump user1             4096 Feb 18 09:19 .
drwxr-x--- 18 user1            user1             4096 Feb 18 09:14 ..
drwx------  6 systemd-coredump systemd-coredump  4096 Feb 18 09:15 base
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:16 global
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_commit_ts
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_dynshmem
-rw-------  1 systemd-coredump systemd-coredump  4782 Feb 18 09:15 pg_hba.conf
-rw-------  1 systemd-coredump systemd-coredump  1636 Feb 18 09:15 pg_ident.conf
drwx------  4 systemd-coredump systemd-coredump  4096 Feb 18 09:19 pg_logical
drwx------  4 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_multixact
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_notify
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_replslot
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_serial
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_snapshots
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:19 pg_stat
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:19 pg_stat_tmp
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_subtrans
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_tblspc
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_twophase
-rw-------  1 systemd-coredump systemd-coredump     3 Feb 18 09:15 PG_VERSION
drwx------  3 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_wal
drwx------  2 systemd-coredump systemd-coredump  4096 Feb 18 09:15 pg_xact
-rw-------  1 systemd-coredump systemd-coredump    88 Feb 18 09:15 postgresql.auto.conf
-rw-------  1 systemd-coredump systemd-coredump 28156 Feb 18 09:15 postgresql.conf
-rw-------  1 systemd-coredump systemd-coredump    36 Feb 18 09:15 postmaster.opts
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

### Ответ
Подключаемся к postgres
```bash
user1@devopserubuntu:~$ psql -h 10.20.8.77 -p 5432 -d mydb -U admin
Password for user admin:
psql (13.5 (Ubuntu 13.5-0ubuntu0.21.10.1))
Type "help" for help.

mydb=#
```
Посмотрим, какие есть БД в нашем postgres:
```bash
mydb=# \l+
 mydb      | admin | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default |
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 |                   | 7901 kB | pg_default | default administrative connection database
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +| 7753 kB | pg_default | unmodifiable empty database
           |       |          |            |            | admin=CTc/admin   |         |            |
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +| 7753 kB | pg_default | default template for new databases
           |       |          |            |            | admin=CTc/admin   |         |            |
```
создаём пользователя и проверим их список:
```bash
mydb=# create USER "test-admin-user";
CREATE ROLE

mydb=# ALTER USER "test-admin-user" PASSWORD '123456';
ALTER ROLE

mydb=# \du
 admin           | Superuser, Create role, Create DB, Replication, Bypass RLS | {}
 test-admin-user |                                                            | {}
```
Обращаю внимание, что имя пользователя указано в двойных кавычках так как имя содержит дефис. Без него кавычки не нужны.
Теперь создадим новую БД:
```bash
postgres=# create DATABASE test_db;
CREATE DATABASE

postgres=# \l
 mydb      | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin         +
           |       |          |            |            | admin=CTc/admin
 test_db   | admin | UTF8     | en_US.utf8 | en_US.utf8 |
```
Видим, что она добавилась.
Переключаемся на работу с новой базой:
```bash
mydb=# \c test_db
You are now connected to database "test_db" as user "admin".
```
Создаём таблицу `orders` как указано в задании с одним главным ключём, а затем посмотрим что создалось:
```bash
test_db=# create TABLE orders (id SERIAL PRIMARY KEY, name CHAR(20), price INT);
CREATE TABLE

test_db=# \d+ orders;
                                                   Table "public.orders"
 Column |     Type      | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+---------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer       |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 name   | character(20) |           |          |                                    | extended |              |
 price  | integer       |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Access method: heap
```
Создаём таблицу `clients`, как указано в задании с главным ключём и внешним ключём:
```bash
test_db=# create TABLE clients (id SERIAL PRIMARY KEY, secondname CHAR(20), country CHAR(20), order_id INT REFERENCES orders(id));
CREATE TABLE


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
Выдаём пользователю права на БД и её таблицы:
```bash
test_db=# GRANT ALL ON DATABASE test_db TO "test-admin-user";
GRANT
test_db=# \dp test_db

test_db=# GRANT ALL ON TABLE orders TO "test-admin-user";
GRANT

test_db=# GRANT ALL ON TABLE clients TO "test-admin-user";
GRANT

test_db=# \dp test_db
                            Access privileges
 Schema | Name | Type | Access privileges | Column privileges | Policies
--------+------+------+-------------------+-------------------+----------
(0 rows)

test_db=# \dp
                                          Access privileges
 Schema |      Name      |   Type   |        Access privileges        | Column privileges | Policies
--------+----------------+----------+---------------------------------+-------------------+----------
 public | clients        | table    | admin=arwdDxt/admin            +|                   |
        |                |          | "test-admin-user"=arwdDxt/admin |                   |
 public | clients_id_seq | sequence |                                 |                   |
 public | orders         | table    | admin=arwdDxt/admin            +|                   |
        |                |          | "test-admin-user"=arwdDxt/admin |                   |
 public | orders_id_seq  | sequence |                                 |                   |
(4 rows)
```
Изначально выдал права только на БД, но этого было не достаточно чтобы даже просто select выполнить из таблиц. Пришлось выдать права на каждую таблицу.
Вторая странность заключается в том, что права на БД не отображаются командой \dp. 
Жду ответа экспертов.

Создаём нового пользователя и выдаём ему определённые права на таблицы:
```bash
test_db=# CREATE USER "test-simple-user" WITH PASSWORD '123456';
CREATE ROLE
test_db=# GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE orders TO "test-simple-user";
GRANT
test_db=# GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE clients TO "test-simple-user";
GRANT
test_db=#
```

Итоговые результаты по Задаче 2:
- итоговый список БД после выполнения пунктов выше,
```bash
test_db=# \l+
                                                                    List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    |      Access privileges      |  Size   | Tablespace |                Description
-----------+-------+----------+------------+------------+-----------------------------+---------+------------+--------------------------------------------
 mydb      | admin | UTF8     | en_US.utf8 | en_US.utf8 |                             | 7901 kB | pg_default |
 postgres  | admin | UTF8     | en_US.utf8 | en_US.utf8 |                             | 7901 kB | pg_default | default administrative connection database
 template0 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin                   +| 7753 kB | pg_default | unmodifiable empty database
           |       |          |            |            | admin=CTc/admin             |         |            |
 template1 | admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/admin                   +| 7753 kB | pg_default | default template for new databases
           |       |          |            |            | admin=CTc/admin             |         |            |
 test_db   | admin | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/admin                  +| 8037 kB | pg_default |
           |       |          |            |            | admin=CTc/admin            +|         |            |
           |       |          |            |            | "test-admin-user"=CTc/admin |         |            |
(5 rows)
```
- описание таблиц (describe)
```bash
test_db=# \dt+;
                           List of relations
 Schema |  Name   | Type  | Owner | Persistence |  Size   | Description
--------+---------+-------+-------+-------------+---------+-------------
 public | clients | table | admin | permanent   | 0 bytes |
 public | orders  | table | admin | permanent   | 0 bytes |
(2 rows)


test_db=# \d+ orders;
                                                   Table "public.orders"
 Column |     Type      | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------+---------------+-----------+----------+------------------------------------+----------+--------------+-------------
 id     | integer       |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 name   | character(20) |           |          |                                    | extended |              |
 price  | integer       |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id)
Access method: heap


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
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```bash
test_db=# SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name='clients' or  table_name='orders';
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 orders     | admin            | INSERT
 orders     | admin            | SELECT
 orders     | admin            | UPDATE
 orders     | admin            | DELETE
 orders     | admin            | TRUNCATE
 orders     | admin            | REFERENCES
 orders     | admin            | TRIGGER
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 clients    | admin            | INSERT
 clients    | admin            | SELECT
 clients    | admin            | UPDATE
 clients    | admin            | DELETE
 clients    | admin            | TRUNCATE
 clients    | admin            | REFERENCES
 clients    | admin            | TRIGGER
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
(36 rows)
```
- список пользователей с правами над таблицами test_db
```bash
test_db=# \dp+;
                                          Access privileges
 Schema |      Name      |   Type   |        Access privileges        | Column privileges | Policies
--------+----------------+----------+---------------------------------+-------------------+----------
 public | clients        | table    | admin=arwdDxt/admin            +|                   |
        |                |          | "test-admin-user"=arwdDxt/admin+|                   |
        |                |          | "test-simple-user"=arwd/admin   |                   |
 public | clients_id_seq | sequence |                                 |                   |
 public | orders         | table    | admin=arwdDxt/admin            +|                   |
        |                |          | "test-admin-user"=arwdDxt/admin+|                   |
        |                |          | "test-simple-user"=arwd/admin   |                   |
 public | orders_id_seq  | sequence |                                 |                   |
(4 rows)
```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

### Ответ
Заполняем таблицу заказов:
```bash
test_db=# INSERT INTO orders VALUES (0, 'Шоколад', 10);
INSERT 0 1
test_db=# INSERT INTO orders VALUES (1, 'Принтер', 3000);
INSERT 0 1
test_db=# INSERT INTO orders VALUES (2, 'Книга', 500);
INSERT 0 1
test_db=# INSERT INTO orders VALUES (3, 'Монитор', 7000);
INSERT 0 1
test_db=# INSERT INTO orders VALUES (4, 'Гитара', 4000);
INSERT 0 1

test_db=# SELECT * FROM orders;
 id |         name         | price
----+----------------------+-------
  0 | Шоколад              |    10
  1 | Принтер              |  3000
  2 | Книга                |   500
  3 | Монитор              |  7000
  4 | Гитара               |  4000
(5 rows)
```
Заполняем таблицу клиентов:
```bash
test_db=# INSERT INTO clients VALUES (0, 'Иванов Иван Иванович', 'USA');
INSERT 0 1
test_db=# INSERT INTO clients VALUES (1, 'Петров Петр Петрович', 'Canada');
INSERT 0 1
test_db=# INSERT INTO clients VALUES (2, 'Иоганн Себастьян Бах', 'Japan');
INSERT 0 1
test_db=# INSERT INTO clients VALUES (3, 'Ронни Джеймс Дио', 'Russia');
INSERT 0 1
test_db=# INSERT INTO clients VALUES (4, 'Ritchie Blackmore', 'Russia');
INSERT 0 1
test_db=# select * from clients;
 id |      secondname      |       country        | order_id
----+----------------------+----------------------+----------
  0 | Иванов Иван Иванович | USA                  |
  1 | Петров Петр Петрович | Canada               |
  2 | Иоганн Себастьян Бах | Japan                |
  3 | Ронни Джеймс Дио     | Russia               |
  4 | Ritchie Blackmore    | Russia               |
(5 rows)
```
Для подсчёта количества строк в таблицах воспользуемся функцией COUNT(). 

Если в качестве аргумента этой функции выступает *, то подсчитываются все строки таблицы. А если в качестве аргумента указывается имя столбца, то подсчитываются только те строки, которые имеют значение в указанном столбце.
```bash
test_db=# SELECT COUNT(*) FROM orders;
 count
-------
     5
(1 row)

test_db=# SELECT COUNT(*) FROM clients;
 count
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

### Ответ

Важно, что при заполнении номера заказа необходимо указывать id заказа такой, который реально имеется в таблице заказов. Иначе такой клиент не вносится.

Можно выбирать клиента по номеру или по имени:
```bash
test_db=# UPDATE clients SET order_id=2 WHERE id=0;
UPDATE 1
test_db=# UPDATE clients SET order_id=3 WHERE secondname='Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET order_id=4 WHERE secondname='Иоганн Себастьян Бах';
UPDATE 1

test_db=# select * from clients;
 id |      secondname      |       country        | order_id
----+----------------------+----------------------+----------
  3 | Ронни Джеймс Дио     | Russia               |
  4 | Ritchie Blackmore    | Russia               |
  0 | Иванов Иван Иванович | USA                  |        2
  1 | Петров Петр Петрович | Canada               |        3
  2 | Иоганн Себастьян Бах | Japan                |        4
(5 rows)
```
А теперь посмотрим, кто из клиентов сделал заказ:
```bash
test_db=# select * from clients WHERE order_id>=0;
 id |      secondname      |       country        | order_id
----+----------------------+----------------------+----------
  0 | Иванов Иван Иванович | USA                  |        2
  1 | Петров Петр Петрович | Canada               |        3
  2 | Иоганн Себастьян Бах | Japan                |        4
(3 rows)
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

### Ответ
Выполняя любой запрос, Postgres разрабатывает для него план запроса. Выбор правильного плана, соответствующего структуре запроса и характеристикам данным, крайне важен для хорошей производительности, поэтому в системе работает сложный планировщик, задача которого — подобрать хороший план. Узнать, какой план был выбран для какого-либо запроса, можно с помощью команды EXPLAIN. 
```bash
test_db=# EXPLAIN  select * from clients;
                         QUERY PLAN
------------------------------------------------------------
 Seq Scan on clients  (cost=0.00..14.00 rows=400 width=176)
(1 row)
```
Этот запрос не содержит предложения WHERE, поэтому он должен просканировать все строки таблицы, так что планировщик выбрал план простого последовательного сканирования. Числа, перечисленные в скобках (слева направо), имеют следующий смысл:

- Приблизительная стоимость запуска. Это время, которое проходит, прежде чем начнётся этап вывода данных, например для сортирующего узла это время сортировки.

- Приблизительная общая стоимость. Она вычисляется в предположении, что узел плана выполняется до конца, то есть возвращает все доступные строки. На практике родительский узел может досрочно прекратить чтение строк дочернего.

- Ожидаемое число строк, которое должен вывести этот узел плана. При этом так же предполагается, что узел выполняется до конца.

- Ожидаемый средний размер строк, выводимых этим узлом плана (в байтах).

Стоимость может измеряться в произвольных единицах, определяемых параметрами планировщика. Традиционно единицей стоимости считается операция чтения страницы с диска; то есть seq_page_cost обычно равен 1.0

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

### Ответ
Вспоминаем, что внутрь контейнера у нас смонтирована папка для бекапов. На хостовой машине она `/home/user1/postgres_backup` , а внутри контейнера `/postgres_backup`.

Теперь инициируем выполнение бекапа внутри контейнера:
```bash
user1@devopserubuntu:~$ sudo docker exec mypostgres_w_vols bash -c "pg_dump -d test_db -U admin -W > /postgres_backup/backup_test_db"

user1@devopserubuntu:~$ sudo docker exec mypostgres_w_vols ls -la /postgres_backup
total 16
drwxrwxr-x 2 1000 1000 4096 Feb 24 05:43 .
drwxr-xr-x 1 root root 4096 Feb 18 20:34 ..
-rw-r--r-- 1 root root 4271 Feb 24 05:43 backup_test_db

user1@devopserubuntu:~$ ls -la /home/user1/postgres_backup/
total 16
drwxrwxr-x  2 user1 user1 4096 Feb 24 05:43 .
drwxr-x--- 18 user1 user1 4096 Feb 20 08:01 ..
-rw-r--r--  1 root  root  4271 Feb 24 05:43 backup_test_db
```
Как видно файл бекапа появился, где ожидалось, на хостовой машине.

Как впоследствии оказалось, эта команда бекапа сохраниила нам SQL файл, но в нём отсутсвует создание самой базы. А также отсутсвует создание пользователей, которым назначаются права. Вероятно более правильно было бы использовать команду `pg_dumpall`. Но так как у нас уже есть такой бекап, то будем восстанавливаться из него. 

Останавливаем старый контейнер.
```bash
user1@devopserubuntu:~$ sudo docker-compose down
Stopping mypostgres_w_vols ... done
```
Редактируем файл `docker-compose.yaml` старый контейнер комментируем, вписываем новый, монтируя туда папку с бекапом.
```bash
user1@devopserubuntu:~$ cat docker-compose.yaml
version: '2.1'

networks:
  mynetwork:
    driver: bridge

volumes:
#    postgres_data: {}
    postgres_backup: {}

services:

#  postgres:
#    image: postgres:13.5
#    container_name: mypostgres_w_vols
#    volumes:
#      - ./postgres_data:/var/lib/postgresql/data
#      - ./postgres_backup:/postgres_backup
#    restart: always
#    environment:
#      - POSTGRES_USER=admin
#      - POSTGRES_PASSWORD=123456
#      - POSTGRES_DB=mydb
#      - PGDATA=/var/lib/postgresql/data/pgdata
#    networks:
#      - mynetwork
#    ports:
#      - "0.0.0.0:5432:5432"

  postgres1:
    image: postgres:13.5
    container_name: mypostgres1_w_vols
    volumes:
#      - ./postgres_data:/var/lib/postgresql/data
      - ./postgres_backup:/postgres_backup
    restart: always
    environment:
      - POSTGRES_USER=admin
      - POSTGRES_PASSWORD=123456
      - POSTGRES_DB=mydb
    networks:
      - mynetwork
    ports:
      - "0.0.0.0:5432:5432"
```
Запускаем
```bash
user1@devopserubuntu:~$ sudo docker-compose up -d
Creating network "user1_mynetwork" with driver "bridge"
Creating mypostgres1_w_vols ... done

user1@devopserubuntu:~$ sudo docker-compose ps -a
       Name                     Command              State           Ports
-----------------------------------------------------------------------------------
mypostgres1_w_vols   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp
```
Проверяем, что папка с бекапом имеется:
```bash
user1@devopserubuntu:~$ sudo docker exec mypostgres1_w_vols ls -la /postgres_backup
total 16
drwxrwxr-x 2 1000 1000 4096 Feb 24 05:43 .
drwxr-xr-x 1 root root 4096 Feb 24 06:32 ..
-rw-r--r-- 1 root root 4271 Feb 24 05:43 backup_test_db
```
Подключаемся к postgres как и раньше с хостовой машины:
```bash
user1@devopserubuntu:~$ psql -h 10.20.8.77 -p 5432 -d mydb -U admin
Password for user admin:
psql (13.5 (Ubuntu 13.5-0ubuntu0.21.10.1))
Type "help" for help.

mydb=#
```
Так как у нас в бекапе нет создания базы и юзеров, то придётся их создать руками перед восстановлением БД.
```bash
mydb=# create USER "test-admin-user" WITH PASSWORD '123456';
CREATE ROLE
mydb=# create USER "test-simple-user" WITH PASSWORD '123456';
CREATE ROLE
mydb=# create DATABASE test_db;
CREATE DATABASE


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
 test_db   | admin | UTF8     | en_US.utf8 | en_US.utf8 |
(5 rows)

mydb=# \c test_db;
You are now connected to database "test_db" as user "admin".

test_db=# \dp
                            Access privileges
 Schema | Name | Type | Access privileges | Column privileges | Policies
--------+------+------+-------------------+-------------------+----------
(0 rows)
```
Теперь на хостовой машине выполняем команду запуска восстановления бд из бекапа внутри контейнера:
```bash
user1@devopserubuntu:~$ sudo docker exec mypostgres1_w_vols bash -c "psql -d test_db -U admin -W < /postgres_backup/backup_test_db"
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
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      1
(1 row)

 setval
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
```
Смотрим что у нас получилось:
```bash
test_db=# \dp+
                                          Access privileges
 Schema |      Name      |   Type   |        Access privileges        | Column privileges | Policies
--------+----------------+----------+---------------------------------+-------------------+----------
 public | clients        | table    | admin=arwdDxt/admin            +|                   |
        |                |          | "test-admin-user"=arwdDxt/admin+|                   |
        |                |          | "test-simple-user"=arwd/admin   |                   |
 public | clients_id_seq | sequence |                                 |                   |
 public | orders         | table    | admin=arwdDxt/admin            +|                   |
        |                |          | "test-admin-user"=arwdDxt/admin+|                   |
        |                |          | "test-simple-user"=arwd/admin   |                   |
 public | orders_id_seq  | sequence |                                 |                   |
(4 rows)

test_db=# SELECT * FROM clients;
 id |      secondname      |       country        | order_id
----+----------------------+----------------------+----------
  3 | Ронни Джеймс Дио     | Russia               |
  4 | Ritchie Blackmore    | Russia               |
  0 | Иванов Иван Иванович | USA                  |        2
  1 | Петров Петр Петрович | Canada               |        3
  2 | Иоганн Себастьян Бах | Japan                |        4
(5 rows)

test_db=# SELECT * FROM orders;
 id |         name         | price
----+----------------------+-------
  0 | Шоколад              |    10
  1 | Принтер              |  3000
  2 | Книга                |   500
  3 | Монитор              |  7000
  4 | Гитара               |  4000
(5 rows)
```
Все таблицы с правами юзеров, а также данные присутствуют.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
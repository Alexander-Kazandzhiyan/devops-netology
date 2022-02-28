# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

---

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### Ответ
Скачиваем образ для создания контейнера mysql.
```bash
user1@devopserubuntu:~$ sudo docker pull mysql
Using default tag: latest
latest: Pulling from library/mysql
6552179c3509: Pull complete
d69aa66e4482: Pull complete
3b19465b002b: Pull complete
7b0d0cfe99a1: Pull complete
9ccd5a5c8987: Pull complete
44f5f7765d10: Pull complete
7e8f1dd5efbe: Pull complete
71174f5fcbee: Pull complete
a1e368ab37ac: Pull complete
66dd10975b5e: Pull complete
04e9459cbd3e: Pull complete
e1c492527944: Pull complete
Digest: sha256:0962b771c2398c6dcddbbe77b3cf6658408396229b612035d938fb7c8d11c23c
Status: Downloaded newer image for mysql:latest
docker.io/library/mysql:latest

user1@devopserubuntu:~$ sudo docker images
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
mysql             latest    6126b4587b1b   3 days ago     519MB
postgres          latest    6a3c44872108   12 days ago    374MB
```
Подготовим файл `docker-compose.yaml`:
```bash
user1@devopserubuntu:~$ cat docker-compose.yaml
version: '2.1'

networks:
  mynetwork:
    driver: bridge

volumes:
    mysql_data: {}
    mysql_backup: {}

services:

  postgres:
    image: mysql
    container_name: mysql_w_vols
    volumes:
      - ./mysql_data:/var/lib/mysql
      - ./mysql_backup:/mysql_backup
    restart: always
    environment:
      - MYSQL_ROOT_PASSWORD=123456
    networks:
      - mynetwork
    ports:
      - "0.0.0.0:3306:3306"
```
Тут настроено монтирование папок внутрь контейнера, а также присваивание пароля пользователя root для подключения к mysql. Также настроена сеть для контейнера и проброс порта 3306.
Запускаем контейнер и смотрим открыт ли порт для подключения:
```bash
user1@devopserubuntu:~$ sudo docker-compose up -d
[sudo] password for user1:
Creating network "user1_mynetwork" with driver "bridge"
Creating volume "user1_mysql_data" with default driver
Creating volume "user1_mysql_backup" with default driver
Creating mysql_w_vols ... done

user1@devopserubuntu:~$ sudo docker-compose ps -a
    Name                 Command             State                 Ports
--------------------------------------------------------------------------------------
mysql_w_vols   docker-entrypoint.sh mysqld   Up      0.0.0.0:3306->3306/tcp, 33060/tcp

user1@devopserubuntu:~$ netstat -apn | grep 3306
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
tcp        0      0 0.0.0.0:3306            0.0.0.0:*               LISTEN      -
```
Попробуем подключиться к полученному mysql с хостовой машины.
```bash
root@devopserubuntu:/home/user1# mysql -h 0.0.0.0 -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
mysql> 
```
Получилось. Можно работать так, но в задании просили подключаться к mysql внутри контейнера.
```bash
user1@devopserubuntu:~$ sudo docker exec -it mysql_w_vols mysql -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.28 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```
Выведем справку по командам:
```bash
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'
```
Посмотрим состояние сервера mysql:
```bash
mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          10
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.28 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 19 min 49 sec

Threads: 3  Questions: 8  Slow queries: 0  Opens: 117  Flush tables: 3  Open tables: 36  Queries per second avg: 0.006
--------------
```
Версия сервера: `8.0.28`.

Теперь восстановим БД из бекапа приведённого в задании. Раз уж мы смонтировали папку для бекапов внутрь контейнара, то в неё и положим бекап из задания.
```bash
user1@devopserubuntu:~$ cd mysql_backup/
user1@devopserubuntu:~/mysql_backup$ sudo wget https://github.com/netology-code/virt-homeworks/raw/virt-11/06-db-03-mysql/test_data/test_dump.sql
[sudo] password for user1:
--2022-02-27 18:50:16--  https://github.com/netology-code/virt-homeworks/raw/virt-11/06-db-03-mysql/test_data/test_dump.sql
Resolving github.com (github.com)... 140.82.121.4
Connecting to github.com (github.com)|140.82.121.4|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://raw.githubusercontent.com/netology-code/virt-homeworks/virt-11/06-db-03-mysql/test_data/test_dump.sql [following]
--2022-02-27 18:50:16--  https://raw.githubusercontent.com/netology-code/virt-homeworks/virt-11/06-db-03-mysql/test_data/test_dump.sql
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 185.199.111.133, 185.199.109.133, 185.199.108.133, ...
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|185.199.111.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2073 (2.0K) [text/plain]
Saving to: ‘test_dump.sql’

test_dump.sql                                   100%[=====================================================================================================>]   2.02K  --.-KB/s    in 0s

2022-02-27 18:50:17 (10.6 MB/s) - ‘test_dump.sql’ saved [2073/2073]
```
А теперь провери, что файл виден внутри контейнера:
```bash
user1@devopserubuntu:~$ sudo docker exec mysql_w_vols ls -la /mysql_backup
total 12
drwxr-xr-x 2 root root 4096 Feb 27 18:50 .
drwxr-xr-x 1 root root 4096 Feb 27 18:23 ..
-rw-r--r-- 1 root root 2073 Feb 27 18:50 test_dump.sql
```
Посмотрим, что внутри:
```bash
user1@devopserubuntu:~$ sudo docker exec mysql_w_vols cat /mysql_backup/test_dump.sql
-- MySQL dump 10.13  Distrib 8.0.21, for Linux (x86_64)
--
-- Host: localhost    Database: test_db
-- ------------------------------------------------------
-- Server version       8.0.21

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(80) NOT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,'War and Peace',100),(2,'My little pony',500),(3,'Adventure mysql times',300),(4,'Server gravity falls',300),(5,'Log gossips',123);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-10-11 18:15:33
```
Как можно видеть в бекапе содержится бекап базы `test_db`, но её пока нет у нас в СУБД. Надо перед восстановлением создать её.
```bash
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
4 rows in set (0.01 sec)

mysql> create database test_db;
Query OK, 1 row affected (0.01 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)
```
Теперь зальём бекап в базу. Делаем это внутри контейнера.
```bash
user1@devopserubuntu:~$ sudo docker exec -it mysql_w_vols bash -c "mysql -D test_db -u root -p < /mysql_backup/test_dump.sql"
Enter password:
```
Ошибок не выдал. Теперь посмотрим, что получилось:
```bash
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)
```
Таблица и данные в ней присутствуют. 
Теперь посмотрим, сколько строк в таблице имеют цену > 300.
```bash
mysql> select count(*) from orders where price>300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```
Одна запись.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

### Ответ
Посмотрим, какие юзеры в данный момент имеются в системе и какой плагин для них используется:
```bash
mysql> select User, plugin from user;
+------------------+-----------------------+
| User             | plugin                |
+------------------+-----------------------+
| root             | caching_sha2_password |
| mysql.infoschema | caching_sha2_password |
| mysql.session    | caching_sha2_password |
| mysql.sys        | caching_sha2_password |
| root             | caching_sha2_password |
+------------------+-----------------------+
5 rows in set (0.00 sec)
```
Создадим пользователя с заданными требованиями:
```bash
mysql> CREATE USER test IDENTIFIED WITH mysql_native_password BY 'test-pass' WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
Query OK, 0 rows affected (0.04 sec)
```
Для формирования этого запроса использовал данные о структуре таблицы `mysql.user` отсюда:
https://dev.mysql.com/doc/refman/8.0/en/grant-tables.html#grant-tables-user-db

А синтаксис и параметры команды отсюда: https://dev.mysql.com/doc/refman/8.0/en/create-user.html

Посмотрим, что за пользователь у нас создался:
```bash
mysql> select User, plugin, max_questions, password_lifetime, User_attributes from mysql.user where User='test';
+------+-----------------------+---------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| User | plugin                | max_questions | password_lifetime | User_attributes                                                                                                                     |
+------+-----------------------+---------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| test | mysql_native_password |           100 |               180 | {"metadata": {"fname": "James", "lname": "Pretty"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 0}} |
+------+-----------------------+---------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```
Похоже все требования удовлетворены.

Даём права пользователю `test` на операции `SELECT` базы `test_db`:
```bash
mysql> GRANT SELECT ON test_db.* TO 'test';
Query OK, 0 rows affected (0.02 sec)
```
Формат команды и параметры взяты отсюда: https://dev.mysql.com/doc/refman/8.0/en/grant.htm

Посмотрим данные о новом пользователе в таблице `INFORMATION_SCHEMA.USER_ATTRIBUTES`/ 
```bash
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+------+---------------------------------------+
| USER | HOST | ATTRIBUTE                             |
+------+------+---------------------------------------+
| test | %    | {"fname": "James", "lname": "Pretty"} |
+------+------+---------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### Ответ
Включаем профилирование и посмотрим, что оно покажет.
```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)
```
Пока пусто. Выполним какие-то команды, например переход в базу `test_db` и просмотр содержимого таблицы `orders`, а затем выведем профили:
```bash
mysql> SHOW PROFILES;
+----------+------------+----------------------+
| Query_ID | Duration   | Query                |
+----------+------------+----------------------+
|        1 | 0.00024475 | use test_db'         |
|        2 | 0.00041800 | SELECT DATABASE()    |
|        3 | 0.00463650 | show databases       |
|        4 | 0.00504975 | show tables          |
|        5 | 0.00196400 | select * from orders |
+----------+------------+----------------------+
5 rows in set, 1 warning (0.00 sec)
```
** Первая команда содержала лишнюю ковычку и не сработала, однако в список попала.

Попробуем вывести детальную информацию о выполнении запроса 4, например по использованию процессора:
```bash
mysql> SHOW PROFILE CPU FOR QUERY 4;
+--------------------------------+----------+----------+------------+
| Status                         | Duration | CPU_user | CPU_system |
+--------------------------------+----------+----------+------------+
| starting                       | 0.000671 | 0.000671 |   0.000000 |
| Executing hook on transaction  | 0.000011 | 0.000009 |   0.000000 |
| starting                       | 0.000024 | 0.000025 |   0.000000 |
| checking permissions           | 0.000008 | 0.000007 |   0.000000 |
| checking permissions           | 0.000008 | 0.000008 |   0.000000 |
| Opening tables                 | 0.003668 | 0.003669 |   0.000000 |
| init                           | 0.000015 | 0.000013 |   0.000000 |
| System lock                    | 0.000019 | 0.000018 |   0.000000 |
| optimizing                     | 0.000034 | 0.000035 |   0.000000 |
| statistics                     | 0.000134 | 0.000134 |   0.000000 |
| preparing                      | 0.000038 | 0.000038 |   0.000000 |
| Creating tmp table             | 0.000060 | 0.000060 |   0.000000 |
| executing                      | 0.000103 | 0.000103 |   0.000000 |
| checking permissions           | 0.000062 | 0.000062 |   0.000000 |
| end                            | 0.000010 | 0.000009 |   0.000000 |
| query end                      | 0.000006 | 0.000006 |   0.000000 |
| waiting for handler commit     | 0.000015 | 0.000014 |   0.000000 |
| closing tables                 | 0.000020 | 0.000020 |   0.000000 |
| freeing items                  | 0.000125 | 0.000055 |   0.000000 |
| cleaning up                    | 0.000024 | 0.000023 |   0.000000 |
+--------------------------------+----------+----------+------------+
20 rows in set, 1 warning (0.00 sec)
```
Детальная информация по профилированию тут: https://dev.mysql.com/doc/refman/8.0/en/show-profile.html

Теперь посмотрим, какой движок (`Engine`) у нас используется для нашей единственной таблицы в бд:
```bash
mysql> SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)
```
Видим, что `InnoDB`.
Нас просят включить профилирование, изменить движок таблицы на `MyISAM`, а затем обратно и посмотреть что покажет профилирование.
```bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.06 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.04 sec)
Records: 5  Duplicates: 0  Warnings: 0
```
Посмотрим что собрал профилировщик. 
```bash
mysql> SHOW PROFILES;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.05385775 | ALTER TABLE orders ENGINE = MyISAM |
|        2 | 0.03402200 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
2 rows in set, 1 warning (0.00 sec)
```
Видим, что наши оба запроса попали в профиль. Выведем детальную информацию по ним.
```bash
mysql> SHOW PROFILE FOR QUERY 1;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000098 |
| Executing hook on transaction  | 0.000012 |
| starting                       | 0.000031 |
| checking permissions           | 0.000009 |
| checking permissions           | 0.000007 |
| init                           | 0.000038 |
| Opening tables                 | 0.001395 |
| setup                          | 0.000172 |
| creating table                 | 0.004624 |
| waiting for handler commit     | 0.000014 |
| waiting for handler commit     | 0.002886 |
| After create                   | 0.000541 |
| System lock                    | 0.000018 |
| copy to tmp table              | 0.000163 |
| waiting for handler commit     | 0.000013 |
| waiting for handler commit     | 0.000015 |
| waiting for handler commit     | 0.000042 |
| rename result table            | 0.001260 |
| waiting for handler commit     | 0.007110 |
| waiting for handler commit     | 0.000012 |
| waiting for handler commit     | 0.003238 |
| waiting for handler commit     | 0.000011 |
| waiting for handler commit     | 0.028240 |
| waiting for handler commit     | 0.000015 |
| waiting for handler commit     | 0.000283 |
| end                            | 0.001478 |
| query end                      | 0.002043 |
| closing tables                 | 0.000011 |
| waiting for handler commit     | 0.000019 |
| freeing items                  | 0.000033 |
| cleaning up                    | 0.000032 |
+--------------------------------+----------+
31 rows in set, 1 warning (0.00 sec)

mysql> SHOW PROFILE FOR QUERY 2;
+--------------------------------+----------+
| Status                         | Duration |
+--------------------------------+----------+
| starting                       | 0.000107 |
| Executing hook on transaction  | 0.000010 |
| starting                       | 0.000029 |
| checking permissions           | 0.000009 |
| checking permissions           | 0.000012 |
| init                           | 0.000023 |
| Opening tables                 | 0.000376 |
| setup                          | 0.000106 |
| creating table                 | 0.000102 |
| After create                   | 0.014910 |
| System lock                    | 0.000020 |
| copy to tmp table              | 0.000203 |
| rename result table            | 0.001191 |
| waiting for handler commit     | 0.000014 |
| waiting for handler commit     | 0.002536 |
| waiting for handler commit     | 0.000012 |
| waiting for handler commit     | 0.006396 |
| waiting for handler commit     | 0.000013 |
| waiting for handler commit     | 0.002140 |
| waiting for handler commit     | 0.000012 |
| waiting for handler commit     | 0.001318 |
| end                            | 0.000436 |
| query end                      | 0.003669 |
| closing tables                 | 0.000011 |
| waiting for handler commit     | 0.000310 |
| freeing items                  | 0.000030 |
| cleaning up                    | 0.000032 |
+--------------------------------+----------+
27 rows in set, 1 warning (0.00 sec)
```
Тут можно увидеть, что коротко говоря, не происходит просто изменение какого-то параметра таблицы, а создаётся временная таблица на новом движке, туда копируются данные из старой таблицы, затем новая таблица переименовывается. Не углядел, где удаление старой таблицы, но оно где-то тут тоже должно быть по логике.

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

### Ответ
Посмотрим содержимое файла настроек mysql:
```bash
user1@devopserubuntu:~$ sudo docker exec -it mysql_w_vols cat /etc/mysql/my.cnf
[sudo] password for user1:
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#.....много букв......
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
Добавим значения нужных параметров:

- Скорость IO важнее сохранности данных

`innodb_flush_log_at_trx_commit = 2`
- Нужна компрессия таблиц для экономии места на диске

в файл `my.cnf` добавляем

`innodb_file_per_table=1;` для хранения каждой таблицы в отдельном файле.

`innodb_file_format=Barracuda;` использовать формат файлов, поддерживающий сжатие.

А при создании каждой таблицы надо указывать, что таблица должна храниться со сжатием, а также размер блока. Примерно так `CREATE TABLE t1
(c1 INT PRIMARY KEY)
ROW_FORMAT=COMPRESSED
KEY_BLOCK_SIZE=8;`
Я не нашёл, как указать эти параметры в конфиге для использования по-умолчанию.

- Размер буффера с незакомиченными транзакциями 1 Мб

`innodb_log_buffer_size = 1M`
- Буффер кеширования 30% от ОЗУ

`innodb_buffer_pool_size = 30%`
- Размер файла логов операций 100 Мб

`innodb_log_file_size = 100M`

Файл `my.cnf` должен выглядеть примерно так:
```bash

user1@devopserubuntu:~$ sudo docker exec -it mysql_w_vols cat /etc/mysql/my.cnf
[sudo] password for user1:
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#.....много букв......
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL
innodb_file_per_table = 1
innodb_file_format = Barracuda
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 30%
innodb_log_file_size = 100M

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
Но также надо не забывать при создании таблицуказывать размер блока и признак сжатия (не обязательно).

---
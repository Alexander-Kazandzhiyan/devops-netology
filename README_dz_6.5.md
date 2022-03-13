# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---
## Выполнение

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Ответ

Качаем образ `Centos`:
```bash
 sudo docker pull centos
```
Установился:
```bash
user1@devopserubuntu:~$  sudo docker image ls | grep centos
centos            latest    5d0da3dc9764   5 months ago     231MB
```

Итак, у нас есть оригинальный `Centos` образ для контейнера. Теперь на его основе нам нужно создать свой образ, который будет иметь уже все установленные и настроенные программы, включая `elasticsearch`.
Прежде чем изготавливать файл манифеста для изготовления образа, я решил сначала запустить оригинальный контейнер с `Centos` и выполнить в нём всю последовательность команд для установки и настройки всего, что требуется.
И будем записывать их все сюда:
```bash
# Чиним yum
cd /etc/yum.repos.d/
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# устанавливаем нужные вещи
yum -y install wget
yum -y install mc
yum -y install perl-Digest-SHA

# Скачиваем, проверяем и распаковываем elastic
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512
# Проверяем и распаковываем архив
if shasum -a 512 -c elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512; then echo "Checksum OK"; else echo "Checksum FAILED"; exit; fi
tar -xzf elasticsearch-8.0.1-linux-x86_64.tar.gz -C /
cd /elasticsearch-8.0.1/
#Обявляем переменную окружения с указанием папки установки elastic и записываем её чтоб при перезапуске она появлялась.
export ES_HOME=`pwd`
echo "ES_HOME="$ES_HOME >> /etc/environment
# делаем бекап дефолтного конфига
cp $ES_HOME/config/elasticsearch.yml $ES_HOME/config/elasticsearch.yml.bak
```
Это ещё не всё. По дефолту в `elasticsearch.yml` все настройки закоментированы. Но мы не будет раскоментировать их. Мы просто добавим строчки с настройками в конец файла.
Но если вот эти настройки:
```bash
echo "cluster.name: Netology-Cluster" >> $ES_HOME/config/elasticsearch.yml
echo "node.name: netology_test" >> $ES_HOME/config/elasticsearch.yml
echo "path.data: /var/lib/elastic" >> $ES_HOME/config/elasticsearch.yml
```
вопросов не вызывают. То есть делаем по заданию, как попросили. То есть кое что на чём придётся остановиться - настройки безопасности.

Итак, по-дефолту при первом запуске `elasticsearch` создаёт в своём конфиге ещё ряд параметров по безопасности, которых там нет изначально. А именно включает механизмы авторизации, чтобы каждый запрос к нему должен был сопровозжаться вводом пользователя и пароля. При первом запуске он сам создаёт юзера `elastic` и генерит ему пароль, который выводит на экран.
Кроме того при первом запуске он настраивает себя на работу с SSL то есть по https. А для этого генерирует SSL-сертифкат, который тоже выдаёт на экран.

Таким образом с дефолтными настройками безопасности он при первом запуске выдаёт нам:
```bash
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 Elasticsearch security features have been automatically configured!
 Authentication is enabled and cluster connections are encrypted.

ℹ️  Password for the elastic user (reset with `bin/elasticsearch-reset-password -u elastic`):
  jKsKZM5yubpr0FQ*WuJz

ℹ️  HTTP CA certificate SHA-256 fingerprint:
  d84f162b69431a77713ac58bcd67ab37a636a8d20682f5d53ca780ec165b6a1e

ℹ️  Configure Kibana to use this cluster:
• Run Kibana and click the configuration link in the terminal when Kibana starts.
• Copy the following enrollment token and paste it into Kibana in your browser (valid for the next 30 minutes):
  eyJ2ZXIiOiI4LjAuMSIsImFkciI6WyIxNzIuMTcuMC4yOjkyMDAiXSwiZmdyIjoiZDg0ZjE2MmI2OTQzMWE3NzcxM2FjNThiY2Q2N2FiMzdhNjM2YThkMjA2ODJmNWQ1M2NhNzgwZWMxNjViNmExZSIsImtleSI6IkxXWlVhWDhCNnNJcjZvMnR1TjJtOkVZaV9FWExlVDE2QUp3WE5YWk1CMFEifQ==

ℹ️  Configure other nodes to join this cluster:
• On this node:
  ⁃ Create an enrollment token with `bin/elasticsearch-create-enrollment-token -s node`.
  ⁃ Uncomment the transport.host setting at the end of config/elasticsearch.yml.
  ⁃ Restart Elasticsearch.
• On other nodes:
  ⁃ Start Elasticsearch with `bin/elasticsearch --enrollment-token <token>`, using the enrollment token that you generated.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
В этом случае нам придётся решать, как узнать пароль и получить сертификат вне контейнера, чтоб потом при запросах их использовать. Это отдельная задача, которую нас решать не просили. Поэтому мы заранее, то есть до первого запуска, прямо в конфиге вносим параметры безопасности в отключённом варианте:
```bash
echo "xpack.security.enabled: false" >> $ES_HOME/config/elasticsearch.yml
echo "xpack.security.enrollment.enabled: false" >> $ES_HOME/config/elasticsearch.yml
```
Для работы сервиса потребуется пользователь, так как запускаться из-под root он не будет (это у ниего в кишках зашито)
```bash
#Создаём пользователя под которым будет запускаться elastic
useradd elasticsearch
chown elasticsearch:elasticsearch -R $ES_HOME
# Создаём папку под данные, как просили в задании и даём права
mkdir /var/lib/elastic
chown elasticsearch:elasticsearch -R /var/lib/elastic
```
И в конце концов для запуска сервиса из-под правильного юзера нужно использовать команду:
```bash
su elasticsearch -c "$ES_HOME/bin/elasticsearch"
```
или для запуска в режиме демона:
```bash
su elasticsearch -c "$ES_HOME/bin/elasticsearch -d"
```

Хочется отметить, что по дефолту elastic стартует на localhost и не принимает подключения с внешних ip. Поэтому ве запросы в дальнейшем придётся делать внутри контейнера. Но при необходимости можно было бы "высунуть" его во вне. Для этого надо было бы в конфиге указать параметр `network.host:адрес на котором слушать`.

Теперь используя эти знания создадим `Dockerfile`:
```bash
root@devopserubuntu:/home/user1# cat Dockerfile
FROM centos

RUN cd /etc/yum.repos.d/ &&\
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&\
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum -y install wget &&\
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz &&\
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512

RUN yum -y install mc

RUN yum -y install perl-Digest-SHA &&\
shasum -a 512 -c elasticsearch-8.0.1-linux-x86_64.tar.gz.sha512 &&\
tar -xzf elasticsearch-8.0.1-linux-x86_64.tar.gz -C / &&\
cd /elasticsearch-8.0.1/ &&\
export ES_HOME=`pwd` &&\
echo "ElasticSearch распакован в папку" $ES_HOME &&\
echo "ES_HOME="$ES_HOME >> /etc/environment &&\
cp $ES_HOME/config/elasticsearch.yml $ES_HOME/config/elasticsearch.yml.bak &&\
echo "cluster.name: Netology-Cluster" >> $ES_HOME/config/elasticsearch.yml &&\
echo "node.name: netology_test" >> $ES_HOME/config/elasticsearch.yml &&\
echo "path.data: /var/lib/elastic" >> $ES_HOME/config/elasticsearch.yml &&\
echo "xpack.security.enabled: false" >> $ES_HOME/config/elasticsearch.yml &&\
echo "xpack.security.enrollment.enabled: false" >> $ES_HOME/config/elasticsearch.yml &&\
useradd elasticsearch &&\
chown elasticsearch:elasticsearch -R $ES_HOME &&\
mkdir /var/lib/elastic &&\
chown elasticsearch:elasticsearch -R /var/lib/elastic

ENV ES_HOME="/elasticsearch-8.0.1"
CMD su elasticsearch -c "$ES_HOME/bin/elasticsearch"
```
Всё, что находится под директивами RUN - это так называемые слои. То есть команды, которые должны выполняться для того чтобы из образа Centos получился нужный нам образ для контейнера с elasticsearch.
Эта запись `ENV ES_HOME="/elasticsearch-8.0.1"` создаёт в контейнере глобальную переменную.
Эта запись `CMD su elasticsearch -c "$ES_HOME/bin/elasticsearch"` организует автозапуск команды при старте контейнера.

Теперь осуществим создание нашего нового образа на основе образа `Centos` и `Dockerfile`:
```bash
user1@devopserubuntu:~$ sudo docker build . -t centoselastic:0.5
...много букв про выполнение всех команд....
Successfully built 2987dfd3aff1
Successfully tagged centoselastic:0.5
```
Проверяем, что образ создался
```bash
user1@devopserubuntu:~$ sudo docker image ls | grep centos
centoselastic     0.5       2987dfd3aff1   17 minutes ago   2GB
centos            latest    5d0da3dc9764   5 months ago     231MB
```
Отлично. Запускаем создание контейнера и проверяем, что он создался и запустился:
```bash
user1@devopserubuntu:~$ sudo docker run -d -it --name centos-elastix centoselastic:0.5
f7e19b6f94534944f830d90d57dc4c151786ac4acc16620392f1f08b61475e7d

user1@devopserubuntu:~$ sudo sudo docker ps -a
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS                     PORTS     NAMES
f7e19b6f9453   centoselastic:0.5   "/bin/sh -c 'su elas…"   6 seconds ago   Up 5 seconds                         centos-elastix
```
Теперь сделаем запрос к `elasticsearch`, запустив `curl` внутри контейнера:
```bash
user1@devopserubuntu:~$ sudo docker exec -it centos-elastix bash -c "curl -k http://localhost:9200"
{
  "name" : "netology_test",
  "cluster_name" : "Netology-Cluster",
  "cluster_uuid" : "ZNnQL93bTtq6FFADssY__A",
  "version" : {
    "number" : "8.0.1",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "801d9ccc7c2ee0f2cb121bbe22ab5af77a902372",
    "build_date" : "2022-02-24T13:55:40.601285296Z",
    "build_snapshot" : false,
    "lucene_version" : "9.0.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```
Задание 1 выполнено.

В случае необходимости для работы внутри контейнера можно выполнить команду и попасть в его консоль:
```bash
user1@devopserubuntu:~$ sudo docker exec -it centos-elastix /bin/bash
[sudo] password for user1:
[root@f7e19b6f9453 /]# 
```
Для примера посмотрим, что сервис запущен и слушает порты:
```bash
[root@f7e19b6f9453 /]# ps -aux | grep elastic
root           1  0.0  0.1 101828  4624 pts/0    Ss+  12:43   0:00 su elasticsearch -c /elasticsearch-8.0.1/bin/elasticsearch
elastic+       8  4.7 59.4 5873568 2389524 ?     Ssl  12:43   1:10 /elasticsearch-8.0.1/jdk/bin/java -Xshare:auto -Des.networkaddress.cache.ttl=60 -Des.networkaddress.cache.negative.ttl=10 -Djava.security.manager=allow -XX:+AlwaysPreTouch -Xss1m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djna.nosys=true -XX:-OmitStackTraceInFastThrow -XX:+ShowCodeDetailsInExceptionMessages -Dio.netty.noUnsafe=true -Dio.netty.noKeySetOptimization=true -Dio.netty.recycler.maxCapacityPerThread=0 -Dio.netty.allocator.numDirectArenas=0 -Dlog4j.shutdownHookEnabled=false -Dlog4j2.disable.jmx=true -Dlog4j2.formatMsgNoLookups=true -Djava.locale.providers=SPI,COMPAT --add-opens=java.base/java.io=ALL-UNNAMED -XX:+UseG1GC -Djava.io.tmpdir=/tmp/elasticsearch-13973868574844199650 -XX:+HeapDumpOnOutOfMemoryError -XX:+ExitOnOutOfMemoryError -XX:HeapDumpPath=data -XX:ErrorFile=logs/hs_err_pid%p.log -Xlog:gc*,gc+age=trace,safepoint:file=logs/gc.log:utctime,pid,tags:filecount=32,filesize=64m -Xms1962m -Xmx1962m -XX:MaxDirectMemorySize=1028653056 -XX:G1HeapRegionSize=4m -XX:InitiatingHeapOccupancyPercent=30 -XX:G1ReservePercent=15 -Des.path.home=/elasticsearch-8.0.1 -Des.path.conf=/elasticsearch-8.0.1/config -Des.distribution.flavor=default -Des.distribution.type=tar -Des.bundled_jdk=true -cp /elasticsearch-8.0.1/lib/* org.elasticsearch.bootstrap.Elasticsearch
elastic+     297  0.0  0.1 121220  6944 ?        Sl   12:43   0:00 /elasticsearch-8.0.1/modules/x-pack-ml/platform/linux-x86_64/bin/controller
root         380  0.0  0.0   9208  1124 pts/1    S+   13:07   0:00 grep --color=auto elastic

[root@f7e19b6f9453 /]# ss -an | grep LISTEN
tcp   LISTEN 0      4096       127.0.0.1:9200         0.0.0.0:*
tcp   LISTEN 0      4096       127.0.0.1:9300         0.0.0.0:*
```

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

### Ответ

Зайдём внутрь контейнера, то есть войдём в его bash:
```bash
user1@devopserubuntu:~$ sudo docker exec -it centos-elastix /bin/bash
[sudo] password for user1:
[root@f7e19b6f9453 /]# 
```
Попробуем сделать запросы для добавления индексов:
```bash
[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/ind-1" -H 'Content-Type: application/json' -d '
> {
>   "settings" : {
>     "number_of_shards" : 1,
>     "number_of_replicas" : 0
>   }
> }
> '
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /ind-1 HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 83
>
* upload completely sent off: 83 out of 83 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 64
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}


[f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/ind-2" -H 'Content-Type: application/json' -d '
{
  "settings" : {
    "number_of_shards" : 2,
    "number_of_replicas" : 1
  }
}
'
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /ind-2 HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 83
>
* upload completely sent off: 83 out of 83 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 64
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}


[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/ind-3" -H 'Content-Type: application/json' -d '
{
  "settings" : {
    "number_of_shards" : 4,
    "number_of_replicas" : 2
  }
}
'
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /ind-3 HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 83
>
* upload completely sent off: 83 out of 83 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 64
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}
```

Посмотрим данные по всем трём индексам:
```bash
[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/ind-*?pretty'
{
  "ind-1" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "ind-1",
        "creation_date" : "1647134514780",
        "number_of_replicas" : "0",
        "uuid" : "JtjxEyAcRhSxSawlvFaJ6A",
        "version" : {
          "created" : "8000199"
        }
      }
    }
  },
  "ind-2" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "2",
        "provided_name" : "ind-2",
        "creation_date" : "1647134989032",
        "number_of_replicas" : "1",
        "uuid" : "bR2Fs2HjSYifIBIQMcWBjQ",
        "version" : {
          "created" : "8000199"
        }
      }
    }
  },
  "ind-3" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "4",
        "provided_name" : "ind-3",
        "creation_date" : "1647135104811",
        "number_of_replicas" : "2",
        "uuid" : "cJ7sWJdoT4KIE2_A_LUBsA",
        "version" : {
          "created" : "8000199"
        }
      }
    }
  }
}

```
Посмотрим состояние кластера
```bash
[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_cluster/health/?pretty'
{
  "cluster_name" : "Netology-Cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```
Проверяем состояние индексов:
```bash
[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_cat/indices'
green  open ind-1 JtjxEyAcRhSxSawlvFaJ6A 1 0 0 0 225b 225b
yellow open ind-3 cJ7sWJdoT4KIE2_A_LUBsA 4 2 0 0 900b 900b
yellow open ind-2 bR2Fs2HjSYifIBIQMcWBjQ 2 1 0 0 450b 450b
```
Как мы видим кластер в состояние `yelow` , а также ind-2 и ind-3.
Очевидно, что индекс 1 зелёный так как текущее положение вещей соответствует, заданным ему при создании, параметрам. А именно 1 шард и 0 реплик.
А вот для 2 и 3 явно не хватает ни шард ни реплик, поэтому у них статус yellow.

Кластер в состоянии 'yellow' из-за того, что в нём у ноды нет реплик, а значит нет возможности обеспечить отказоустойчивость и сохранность данных.

Удаляем все индексы:
```bash
[root@f7e19b6f9453 /]# curl -XDELETE 'localhost:9200/ind-1'
{"acknowledged":true}[root@f7e19b6f9453 /]#

[root@f7e19b6f9453 /]# curl -XDELETE 'localhost:9200/ind-2'
{"acknowledged":true}

[root@f7e19b6f9453 /]# curl -XDELETE 'localhost:9200/ind-3'
{"acknowledged":true}
```

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

### Ответ
Создал директорию. Дал права пользователю под которым работает сервис.
```bash
[root@f7e19b6f9453 /]# mkdir $ES_HOME\snapshots
[root@f7e19b6f9453 /]# chown elasticsearch:elasticsearch -R $ES_HOME\snapshots
```
Долго я пытался с помощью только API зарегистрировать снепшот-репозиторий, но оказалось, что сначала папку необходимо объявить вообще локальным репозиторием в конфиг-файле:
вот в таком виде:
```bash
path:
  repo:
    - /elasticsearch-8.0.1/snapshots
```
Делаем:
```bash
[root@f7e19b6f9453 /]# echo "path:
  repo:
    - /elasticsearch-8.0.1/snapshots" >> $ES_HOME/config/elasticsearch.yml
```
Теперь нужно перезапустить контейнер, ну иди можно было только elasticsearch перезапустить.

А вот теперь уже через API можно объявить, что эта папка будет именно снепшот-репозиторием:
```bash
[root@f7e19b6f9453 /]# curl -v -XPOST "localhost:9200/_snapshot/netology_backup" -H 'Content-Type: application/json' -d '
{
  "type": "fs",
  "settings": {
    "location": "/elasticsearch-8.0.1/snapshots"
  }
}
'
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_snapshot/netology_backup HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 90
>
* upload completely sent off: 90 out of 90 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 21
<
* Connection #0 to host localhost left intact
{"acknowledged":true}
```
Проверим, что снепшот-репозиторий зарегистрировался:
```bash
[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_snapshot?pretty'
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-8.0.1/snapshots"
    }
  }
}
```
Сделаем верификацию, то есть проверку, что снепшот репозиторий функционирует:
```bash
[root@f7e19b6f9453 /]# curl -XPOST 'localhost:9200/_snapshot/netology_backup/_verify?pretty'
{
  "nodes" : {
    "Za6M0XvcRFSoTcdMu2OF4A" : {
      "name" : "netology_test"
    }
  }
}
```
Создаём новый индекс `test`:
```bash
[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/test" -H 'Content-Type: application/json' -d '
{
  "settings" : {
    "number_of_shards" : 1,
    "number_of_replicas" : 0
  }
}
'
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /test HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 83
>
* upload completely sent off: 83 out of 83 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 63
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
```
Проверяем его наличие и состояние:
```bash
[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_cat/indices'
green open test zJ0r8Ub8TnS4nyczr79RAQ 1 0 0 0 225b 225b
```
Делаем снепшот и проверяем список снепшотов (`*` - для вывода всех имеющихся в репозитории):
```bash
[root@f7e19b6f9453 /]# curl -XPUT 'localhost:9200/_snapshot/netology_backup/snapshot-13032022-13:30'

[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_snapshot/netology_backup/*?pretty'
{
  "snapshots" : [
    {
      "snapshot" : "snapshot-13032022-13:30",
      "uuid" : "MgGV9ugdRdu_6L1wvliGRQ",
      "repository" : "netology_backup",
      "version_id" : 8000199,
      "version" : "8.0.1",
      "indices" : [
        "test",
        ".geoip_databases"
      ],
      "data_streams" : [ ],
      "include_global_state" : true,
      "state" : "SUCCESS",
      "start_time" : "2022-03-13T13:31:10.683Z",
      "start_time_in_millis" : 1647178270683,
      "end_time" : "2022-03-13T13:31:12.485Z",
      "end_time_in_millis" : 1647178272485,
      "duration_in_millis" : 1802,
      "failures" : [ ],
      "shards" : {
        "total" : 2,
        "failed" : 0,
        "successful" : 2
      },
      "feature_states" : [
        {
          "feature_name" : "geoip",
          "indices" : [
            ".geoip_databases"
          ]
        }
      ]
    }
  ],
  "total" : 1,
  "remaining" : 0
}
```
Посмотрим, что получилось в папке со снепшотами:
```bash
[root@f7e19b6f9453 /]# ls -la /elasticsearch-8.0.1/snapshots/
total 48
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Mar 13 13:31 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Mar 13 12:55 ..
-rw-r--r-- 1 elasticsearch elasticsearch   856 Mar 13 13:31 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Mar 13 13:31 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Mar 13 13:31 indices
-rw-r--r-- 1 elasticsearch elasticsearch 17435 Mar 13 13:31 meta-MgGV9ugdRdu_6L1wvliGRQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   363 Mar 13 13:31 snap-MgGV9ugdRdu_6L1wvliGRQ.dat
```

Удаляем старый индекс `test` и создаём индекс `test-2`, проверяем список индексов:
```bash
[root@f7e19b6f9453 /]# curl -XDELETE 'localhost:9200/test'
{"acknowledged":true}

[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/test-2" -H 'Content-Type: application/json' -d '
> {
>   "settings" : {
>     "number_of_shards" : 1,
>     "number_of_replicas" : 0
>   }
> }
> '
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /test-2 HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 83
>
* upload completely sent off: 83 out of 83 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 65
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}

[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_cat/indices'
green open test-2 69rFGJ-iS3i8IbpCoT7jrQ 1 0 0 0 225b 225b
```
Теперь если попытаться восстановиться из снепшота, то восстанавливается старый индекс `test`, а новый `test-2` остаётся также:
```bash
[root@f7e19b6f9453 /]# curl -XPOST 'localhost:9200/_snapshot/netology_backup/snapshot-13032022-13:30/_restore'
{"accepted":true}

[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_cat/indices'
green open test-2 69rFGJ-iS3i8IbpCoT7jrQ 1 0 0 0 225b 225b
green open test   13DmgIZJRsyZyzwvWy44vw 1 0 0 0 225b 225b
```
Как я понимаю от настребуетсяполное восстановление состояния кластера. Эта операция требует множества шагов. Итак, попробуем:

Останавливаем индексирование для:
* GeoIP database downloader
```bash
[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d '
{
  "persistent": {
    "ingest.geoip.downloader.enabled": false
  }
}
'

*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /_cluster/settings HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 72
>
* upload completely sent off: 72 out of 72 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 105
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"persistent":{"ingest":{"geoip":{"downloader":{"enabled":"false"}}}},"transient":{}}
```
* ILM
```bash
[root@f7e19b6f9453 /]# curl -v -XPOST "localhost:9200/_ilm/stop"
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_ilm/stop HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 21
<
* Connection #0 to host localhost left intact
{"acknowledged":true}
```
* Machine Learning
```bash
[root@f7e19b6f9453 /]# curl -v -XPOST "localhost:9200/_ml/set_upgrade_mode?enabled=true"
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_ml/set_upgrade_mode?enabled=true HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 21
<
* Connection #0 to host localhost left intact
{"acknowledged":true} 
```
* Monitoring
```bash
[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d '
{
  "persistent": {
    "xpack.monitoring.collection.enabled": false
  }
}
'
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /_cluster/settings HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 76
>
* upload completely sent off: 76 out of 76 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< Warning: 299 Elasticsearch-8.0.1-801d9ccc7c2ee0f2cb121bbe22ab5af77a902372 "[xpack.monitoring.collection.enabled] setting was deprecated in Elasticsearch and will be removed in a future release."
< content-type: application/json
< content-length: 109
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"persistent":{"xpack":{"monitoring":{"collection":{"enabled":"false"}}}},"transient":{}}
```
* Watcher
```bash
[root@f7e19b6f9453 /]# curl -v -XPOST "localhost:9200/_watcher/_stop"
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_watcher/_stop HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 21
<
* Connection #0 to host localhost left intact
{"acknowledged":true} 
```
Теперь необходимо выполнить команду, чтобы можно было удалять сущности кластера по маске, например `*`
```bash
# curl -v -XPUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d '
{
  "persistent": {
    "action.destructive_requires_name": false
  }
}
'
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /_cluster/settings HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 73
>
* upload completely sent off: 73 out of 73 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< Warning: 299 Elasticsearch-8.0.1-801d9ccc7c2ee0f2cb121bbe22ab5af77a902372 "[xpack.monitoring.collection.enabled] setting was deprecated in Elasticsearch and will be removed in a future release."
< content-type: application/json
< content-length: 98
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"persistent":{"action":{"destructive_requires_name":"false"}},"transient":{}}
```
Теперь можно удалить все дата-стримы:
```bash
[root@f7e19b6f9453 /]# curl -XDELETE 'localhost:9200/_data_stream/*?expand_wildcards=all'
# {"acknowledged":true}
```
Теперь удаляем все индексы:
```bash
[root@f7e19b6f9453 /]# curl -XDELETE 'localhost:9200/*?expand_wildcards=all'
{"acknowledged":true}
```
Всё подчистили. Теперь можно восстанавливаться из снепшота:
```bash
curl -v -XPOST "localhost:9200/_snapshot/netology_backup/snapshot-13032022-13:30/_restore" -H 'Content-Type: application/json' -d '
{
  "indices": "*",
  "include_global_state": true
}
'
Note: Unnecessary use of -X or --request, POST is already inferred.
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_snapshot/netology_backup/snapshot-13032022-13:30/_restore HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 54
>
* upload completely sent off: 54 out of 54 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< Warning: 299 Elasticsearch-8.0.1-801d9ccc7c2ee0f2cb121bbe22ab5af77a902372 "[xpack.monitoring.collection.enabled] setting was deprecated in Elasticsearch and will be removed in a future release."
< content-type: application/json
< content-length: 17
<
* Connection #0 to host localhost left intact
{"accepted":true}
```
Проверяем восстановился ли индекс `test`:
```bash
[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_cat/indices'
green open test kxS8JN3hQbONfGDQqGuxOg 1 0 0 0 225b 225b
```
Теперь запускаем всё, что остановили:
```bash
[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d '
{
  "persistent": {
    "ingest.geoip.downloader.enabled": true
  }
}
'
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /_cluster/settings HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 71
>
* upload completely sent off: 71 out of 71 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 104
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"persistent":{"ingest":{"geoip":{"downloader":{"enabled":"true"}}}},"transient":{}}

[root@f7e19b6f9453 /]# curl -v -XPOST "localhost:9200/_ilm/start"
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_ilm/start HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 21
<
* Connection #0 to host localhost left intact
{"acknowledged":true}

[root@f7e19b6f9453 /]# curl -v -XPOST "localhost:9200/_ml/set_upgrade_mode?enabled=false"
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_ml/set_upgrade_mode?enabled=false HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 21
<
* Connection #0 to host localhost left intact
{"acknowledged":true}

[root@f7e19b6f9453 /]# curl -v -XPUT "localhost:9200/_cluster/settings" -H 'Content-Type: application/json' -d '
{
  "persistent": {
    "xpack.monitoring.collection.enabled": true
  }
}
'
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> PUT /_cluster/settings HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
> Content-Type: application/json
> Content-Length: 75
>
* upload completely sent off: 75 out of 75 bytes
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< Warning: 299 Elasticsearch-8.0.1-801d9ccc7c2ee0f2cb121bbe22ab5af77a902372 "[xpack.monitoring.collection.enabled] setting was deprecated in Elasticsearch and will be removed in a future release."
< content-type: application/json
< content-length: 108
<
* Connection #0 to host localhost left intact
{"acknowledged":true,"persistent":{"xpack":{"monitoring":{"collection":{"enabled":"true"}}}},"transient":{}}

[root@f7e19b6f9453 /]# curl -v -XPOST "localhost:9200/_watcher/_start"
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to localhost (127.0.0.1) port 9200 (#0)
> POST /_watcher/_start HTTP/1.1
> Host: localhost:9200
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< X-elastic-product: Elasticsearch
< content-type: application/json
< content-length: 21
<
* Connection #0 to host localhost left intact
{"acknowledged":true}
```
Всё запустилось без ошибок.

Для восстановления использованы материалы [статьи](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html).

Итак, повторюсь. Для восстановления был использован запрос:
```bash
curl -v -XPOST "localhost:9200/_snapshot/netology_backup/snapshot-13032022-13:30/_restore" -H 'Content-Type: application/json' -d '
{
  "indices": "*",
  "include_global_state": true
}
'
```
Смотрим, что у нас синтексами после восстановления.
```bash
[root@f7e19b6f9453 /]# curl -XGET 'localhost:9200/_cat/indices'
green open test                        kxS8JN3hQbONfGDQqGuxOg 1 0  0 0    225b    225b
green open .monitoring-es-7-2022.03.14 -DCfS7jfQUyIvPAp_fbujg 1 0 27 5 296.8kb 296.8kb
```
Индекс `test`, как мы видим восстановился. И ещё тут какой-то системный индекс мониторинга появился. Видимо из-за того, что мы службу мониторинга стартанули, видимо она раньше не была запущена.

---
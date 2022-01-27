
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

### Ответ
- создайте свой репозиторий на https://hub.docker.com;

Зарегистрировался на `hub.docker.com`. 


- выберете любой образ, который содержит веб-сервер Nginx;

Выбираю докер с Nginx: https://hub.docker.com/_/nginx
 
- создайте свой fork образа;

Скачиваем и Устанавливаем Docker на Ubuntu Server :
```bash
user1@devopserubuntu:~$  curl -fsSL get.docker.com -o get-docker.sh && chmod +x get-docker.sh && ./get-docker.sh
# Executing docker install script, commit: 93d2499759296ac1f9c510605fef85052a2c32be
+ sudo -E sh -c apt-get update -qq >/dev/null
[sudo] password for user1:
+ sudo -E sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null
+ sudo -E sh -c curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
+ sudo -E sh -c echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu impish stable" > /etc/apt/sources.list.d/docker.list
+ sudo -E sh -c apt-get update -qq >/dev/null
+ sudo -E sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends  docker-ce-cli docker-scan-plugin docker-ce >/dev/null
+ version_gte 20.10
+ [ -z  ]
+ return 0
+ sudo -E sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce-rootless-extras >/dev/null
+ sudo -E sh -c docker version
Client: Docker Engine - Community
 Version:           20.10.12
 API version:       1.41
 Go version:        go1.16.12
 Git commit:        e91ed57
 Built:             Mon Dec 13 11:45:33 2021
 OS/Arch:           linux/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.12
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.12
  Git commit:       459d0df
  Built:            Mon Dec 13 11:43:41 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.12
  GitCommit:        7b11cfaabd73bb80907dd23182b9347b4245eb5d
 runc:
  Version:          1.0.2
  GitCommit:        v1.0.2-0-g52b36a2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

================================================================================

To run Docker as a non-privileged user, consider setting up the
Docker daemon in rootless mode for your user:

    dockerd-rootless-setuptool.sh install

Visit https://docs.docker.com/go/rootless/ to learn about rootless mode.


To run the Docker daemon as a fully privileged service, but granting non-root
users access, refer to https://docs.docker.com/go/daemon-access/

WARNING: Access to the remote API on a privileged Docker daemon is equivalent
         to root access on the host. Refer to the 'Docker daemon attack surface'
         documentation for details: https://docs.docker.com/go/attack-surface/

================================================================================
```
Проверяем, что он установился и работает:
```bash
user1@devopserubuntu:~$ docker --version
\Docker version 20.10.12, build e91ed57

user1@devopserubuntu:~$ sudo docker ps
[sudo] password for user1:
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
Скачиваем и Устанавливаем новый образ для создания контейнера:
```bash
user1@devopserubuntu:~$ sudo docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
a2abf6c4d29d: Pull complete
a9edb18cadd1: Pull complete
589b7251471a: Pull complete
186b1aaa4aa6: Pull complete
b4df32aa5a72: Pull complete
a0bcbecc962e: Pull complete
Digest: sha256:0d17b565c37bcbd895e9d92315a05c1c3c9a29f762b011a10c54a66cd53c9b31
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
```
Проверяем, что у нас появился образ в локальном репозитории:
```bash
user1@devopserubuntu:~$ sudo docker image ls
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    605c77e624dd   3 weeks ago   141MB
```
Запустим контейнер в фоновом режиме, дав ему имя `first-nginx`:
```bash
user1@devopserubuntu:~$ sudo docker run -d --name first-nginx nginx
5e8e1a90095fbaee03086e40ae35bf802945a15a6b18f0e4ac8fa9b837362a66

user1@devopserubuntu:~$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS     NAMES
5e8e1a90095f   nginx     "/docker-entrypoint.…"   6 seconds ago   Up 5 seconds   80/tcp    first-nginx
```
Попробуем выполнить в контейнере какие-то команды. Например посмотреть версию nginx, а также попробовать открыть страничку, опубликованную сейчас в nginx:
```bash
user1@devopserubuntu:~$ sudo docker exec -it first-nginx nginx -v
nginx version: nginx/1.21.5

user1@devopserubuntu:~$ sudo docker exec -it first-nginx curl 127.0.0.1
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
Как видно, локально выводится html код демо-страницы nginx.
Попробуем настроить сеть, чтобы открыть страничку с локальной машины (с docker-хоста).
Для этого будет достаточно подключить контейнер к сети с режимом `host`.
Посмотрим список имеющихся сетей:
```bash
user1@devopserubuntu:~$ sudo docker network ls
NETWORK ID     NAME       DRIVER    SCOPE
68afe4007796   bridge     bridge    local
f74c0e5813ae   host       host      local
0acd11ff288d   none       null      local
```
Видим, что такая сеть есть и она называется `host`. Подключаем уже запущенный контейнер к этой сети:
```bash
user1@devopserubuntu:~$ sudo docker network connect host first-nginx
Error response from daemon: container cannot be disconnected from host network or connected to host network
```
Как видим, ошибка. Оказывается сеть типа `host` нельзя подключать к уже созданному контейнеру, надо подключать при создании.
Удалим контейнер и создадим заново, подключая сеть сразу:
```bash
user1@devopserubuntu:~$ sudo docker stop first-nginx
first-nginx

user1@devopserubuntu:~$ sudo docker rm first-nginx
first-nginx

user1@devopserubuntu:~$ sudo docker run -d --name first-nginx --net host nginx
3c4dc45f438a53c7107d97bfaac0ff49322a901f72599a6e8f60bf8be0147361
```
Теперь с виртуальной сетью этого типа сеть контейнера будет частью сети docker-хоста. Убедимся в этом, проверив прослушивается ли порт 80 на docker-хосте.
```bash
root@devopserubuntu:~# netstat -apn | grep 80
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      211745/nginx: maste
tcp6       0      0 :::80                   :::*                    LISTEN      211745/nginx: maste
```
Попробуем локально, находясь на docker-хосте, открыть страничку с нашего контейнерного nginx:
```bash
root@devopserubuntu:/var# curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
Круто, сеть заработала. И страничка открывается даже снаружи докер-хоста из моей windows.

- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
По умолчанию nginx внутри контейнера открывает демо-страничку, которая хранится в виде html-файла `/usr/share/nginx/html/index.html`.
Чтобы начала выдаваться наша страничка вместо этой надо внести изменение в образ из которого запускается контейнер.
Для этого нужно выполнить билд образа, для чего нужно создать файл `Dockerfile`, который описывает, от какого образа будет наследоваться наш новый образ и какие изменения в него должны быть внесены.

У меня было два варианта решения поставленной задачи и сначала я попробовал выполнить более сложный.
####Вариант1. 
Сначала Я пытался сделать следующее: В `Dockerfile` я запрограммировал создание папки `/data/www`, затем создание в ней файла `index.html`, а затем добавлял в нужное место файла конфигурации nginx настройку чтобы "домашней" папкой для него стала `/data/www` и соответственно рассчитывал, что наша страничка будет открываться вместо демо-странички.
Не смотря на  простоту я потратил много времени, чтобы это реализовать и раз уж я проделал это то приведу здесь результаты:
```bash
root@devopserubuntu:/home/user1/Make-own-docker-image# cat Dockerfile
FROM nginx

RUN mkdir /data && \
    cd /data && \
    mkdir www && \
    cd www && \
    echo "<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>" > index.php

RUN  sed '/http {/a server { location / { root /data/www; } }' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf-new && \
    mv /etc/nginx/nginx.conf-new /etc/nginx/nginx.conf
```
Затем выполнялась сборка образа:
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker build . -t mynginx:0.5
Sending build context to Docker daemon  2.048kB
Step 1/3 : FROM nginx
 ---> 605c77e624dd
Step 2/3 : RUN mkdir /data &&     cd /data &&     mkdir www &&     cd www &&     echo "<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>" > index.html
 ---> Running in b41b088ceb12
Removing intermediate container b41b088ceb12
 ---> f20b8676e450
Step 3/3 : RUN  sed '/http {/a server { location / { root /data/www; } }' /etc/nginx/nginx.conf > /etc/nginx/nginx.conf-new &&     mv /etc/nginx/nginx.conf-new /etc/nginx/nginx.conf
 ---> Running in 774adb7dd501
Removing intermediate container 774adb7dd501
 ---> 2cc6139e76e9
Successfully built 2cc6139e76e9
Successfully tagged mynginx:0.5
```
В результате появился образ `mynginx` с тегом `0.5` так как это была уже 5 версия :)

Затем из этого образа я запускал контейнер:
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker run -d --name second-mynginx-new-dir --net host mynginx:0.5
[sudo] password for user1:
c86dee4ef31b93294e3d3874fd37981b1e7baee8b804e8d879059e3717d4e5ec
```
Для интереса смотрим, что там внутри контейнера нашего добавилось. Смотрим, что в файле настроек nginx появилась наша строка `server { location / { root /data/www; } }` с указанием домашенй папки:
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker exec -it second-mynginx-new-dir cat /etc/nginx/nginx.conf

user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
server { location / { root /data/www; } }
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```
Смотрим, что папка создалась и в ней лежит файл странички :
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker exec -it second-mynginx-new-dir cat /data/www/index.html
<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>
```
А вот дальше произошёл косяк, который видимо связан с не полным пониманием настроек nginx. Я предполагал, что при любом обращении к веб-серверу, он залезет в домашнюю папку и покажет наш файл `index.html` и попробовал это сделать локально с докер-хоста и получил снова несчастную демо страничку:
```bash
root@devopserubuntu:/home/user1/Make-own-docker-image# curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
и подумал, что я что-то сделал не так и отказался от этого решения и сделал Вариант 2. Но оказывается (я сегодня обраружил), что если обратиться оттуда же, но не по lockalhost, а по адресу (докер-хоста = контейнера (сеть же типа host)), то откроется то что надо:
```bash
root@devopserubuntu:/home/user1/Make-own-docker-image# curl 10.20.8.77
<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>
```
Так что сегодня выяснилось, что Вариант 1 был тоже правильный.
Но я уже сделал более тупой Вариант 2. Привожу его тоже.

####Вариант 2.
Смысл в том, что-бы заменить в образе содержимое файла демо странички `/usr/share/nginx/html/index.html`
Для этого делаем совсем простой `Dockerfile`:
```bash
root@devopserubuntu:/home/user1/Make-own-docker-image# cat Dockerfile
FROM nginx

RUN echo "<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>" > /usr/share/nginx/html/index.html
```
Собираем образ:
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker build . -t mynginx:0.7
Sending build context to Docker daemon  3.072kB
Step 1/2 : FROM nginx
 ---> 605c77e624dd
Step 2/2 : RUN echo "<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>" > /usr/share/nginx/html/index.html
 ---> Running in 38f831590444
Removing intermediate container 38f831590444
 ---> fcf6f4373363
Successfully built fcf6f4373363
Successfully tagged mynginx:0.7
```
Запускаем контейнер:
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker run -d --name second-mynginx --net host mynginx:0.7
d7165fcb60dc1f0114f3eba7c5a9721fba3fbf3746320ab548c9e679c90e14c4
```
Проверяем, что теперь при любом обращении nginx выдаёт нам нашу страничку:
```bash
root@devopserubuntu:/home/user1/Make-own-docker-image# curl localhost
<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>

root@devopserubuntu:/home/user1/Make-own-docker-image# curl 10.20.8.77
<html><head>Hey, Netology</head><body><h1>I’m DevOps Engineer!</h1></body></html>
```

- Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

Посмотрим, что у нас имеется теперь в списке образов:
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker images
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
mynginx      0.7       fcf6f4373363   19 hours ago   141MB
mynginx      0.6       d2e089cada3f   19 hours ago   141MB
mynginx      0.5       2cc6139e76e9   19 hours ago   141MB
mynginx      0.4       34bbfb254817   19 hours ago   141MB
mynginx      0.3       8b3bc9f1a152   19 hours ago   141MB
mynginx      0.2       62657ed9126c   20 hours ago   141MB
mynginx      0.1       a97876048b1e   20 hours ago   141MB
nginx        latest    605c77e624dd   3 weeks ago    141MB
```
Будем публиковать образ из Варианта 2. То есть `mynginx:0.7`.

Логинимся на докер-хабе:
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker login -u akazand
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
На докерхабе надо создать репозиторий под конкретно этот продукт. У нас продукт будет называться `mynginx`. Поэтому созданный под моим логином репозиторий будет называться `akazand/mynginx`. Надо понимать, что один продукт = один репозиторий. В него другие продукты лить не надо, а вот все версии одного продукта могут там храниться с разными тегами.
Так как при создании образов мы вообще даже не знали как устроено именование в докерхабе, поэтому я наделал образов по простым именем `mynginx` с разными тегами. Они лежат в локальном репозитории.
Теперь чтобы любой из них залить в докерхабовский репозиторий надо образ переименовать:
```bash
$ sudo docker image tag mynginx:0.7 akazand/mynginx:0.7
```

Интересно, что если теперь взглянуть на список локальных образов то оказывается он не переименоваля, а скопировался, точнее так как `ID` (хеш) у него остался тот же, значит наверное у этого образа появилось второе имя. Смотри первые 2 строчки.
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker images
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
akazand/mynginx   0.7       fcf6f4373363   21 hours ago   141MB
mynginx           0.7       fcf6f4373363   21 hours ago   141MB
mynginx           0.6       d2e089cada3f   21 hours ago   141MB
mynginx           0.5       2cc6139e76e9   22 hours ago   141MB
mynginx           0.4       34bbfb254817   22 hours ago   141MB
mynginx           0.3       8b3bc9f1a152   22 hours ago   141MB
mynginx           0.2       62657ed9126c   22 hours ago   141MB
mynginx           0.1       a97876048b1e   23 hours ago   141MB
mynginx           latest    bbd004f8d6ec   23 hours ago   141MB
nginx             latest    605c77e624dd   4 weeks ago    141MB
```
А теперь уже можно его запушить в наш репозиторий `akazand/mynginx`
```bash
user1@devopserubuntu:~/Make-own-docker-image$ sudo docker push akazand/mynginx:0.7
Using default tag: 0.7
The push refers to repository [docker.io/akazand/mynginx]
c52441665635: Pushed
d874fd2bc83b: Pushed
32ce5f6a5106: Pushed
f1db227348d0: Pushed
b8d6e692a25e: Pushed
e379e8aedd4d: Pushed
2edcec3590a4: Pushed
latest: digest: sha256:c730443b40c778fe6d6fceeb49ea276af0a8359e48a52cd167034688f126d0d0 size: 1777
```
Заглянув в мой репозиторий я вижу там этот образ:
https://hub.docker.com/repository/docker/akazand/mynginx/


## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

### Ответ:
- Высоконагруженное монолитное java веб-приложение;

Нужно разместить на физическом сервере или на ВМ. Я лично предпочёл бы ВМ даже если ей придётся отдать все ресурсы гипервизора, так как удобнее и безопаснее работать с ВМ (легче целеком бекапить (не выключая) , восстанавливать, мигрировать в случае неисправностей железа). Тот же Физический же сервер, но уже напрямую без гипервизора  может дать чуть больше мощности, но пропадает удобство эксплуатации, падает отказоустойчивость.

- Nodejs веб-приложение;

Можно разместить в контейнере или ВМ. Нет смысла использовать физ сервер.

- Мобильное приложение c версиями для Android и iOS;

Думаю, что удобнее разместить каждую версию в свой контейнер, а также навернякак потребуются ещё пара контейнеров, которые будут содержать какие-то общие для всего продукта элементы, например в одном БД, в другом Веб-интерфейс или Back-end.

- Шина данных на базе Apache Kafka;

Думаю ему и в контейнере будет хорошо. 

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

Однозначно не физ сервер. Нужно использовать ВМ или Контейнеры. Скорее контейнеры. Быстро разворачиваются, легко масштабируются (мжно быстро добавить ещё ноды).

- Мониторинг-стек на базе Prometheus и Grafana;

Думаю удобно разместить в контейнерах. Все части решения каждый в своём контейнере и ещё какие-то общие контейнеры с БД и Веб-сервером.

- MongoDB, как основное хранилище данных для java-приложения;

Думаю контейнер подойдёт. Физ хост и даже ВМ, пожалуй будет избыточно.

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

Можно и физ сервер, но Думаю ВМ лучше всего подойдёт. Для Контейнера задачи тяжеловаты. А минусы физ сервера в сравнении с ВМ я описывал выше в первом сценарии. 

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

### Ответ
Скачиваем образы:
```bash
user1@devopserubuntu:~$ sudo docker pull centos
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest

user1@devopserubuntu:~$ sudo docker pull debian
Using default tag: latest
latest: Pulling from library/debian
0c6b8ff8c37e: Pull complete
Digest: sha256:fb45fd4e25abe55a656ca69a7bef70e62099b8bb42a279a5e0ea4ae1ab410e0d
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest

user1@devopserubuntu:~$ sudo docker images
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
debian            latest    04fbdaf87a6a   29 hours ago   124MB
akazand/mynginx   latest    fcf6f4373363   31 hours ago   141MB
mynginx           0.7       fcf6f4373363   31 hours ago   141MB
mynginx           0.5       2cc6139e76e9   31 hours ago   141MB
nginx             latest    605c77e624dd   4 weeks ago    141MB
centos            latest    5d0da3dc9764   4 months ago   231MB
```
Видим, что нужные образы появились в локальном репозитории.

Создаём локально папку `/home/user1/data`.
```bash
user1@devopserubuntu:~$ pwd
/home/user1

user1@devopserubuntu:~$ mkdir data

user1@devopserubuntu:~$ ll | grep data
drwxrwxr-x  2 user1 user1  4096 Jan 27 06:24 data/
```

Теперь запускаем контейнер с Centos c примонтированной папкой (в фоновом режиме с запуском bash внутри в интерактивном режиме):
```bash
user1@devopserubuntu:~$ sudo docker run -d -it -v /home/user1/data:/data --name ContCentos centos bash
fc71d06439b1ced02ad8cd09b83e1b5f5dec2d8c0e18790aa9db8a97326f99aa

user1@devopserubuntu:~$ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS                     PORTS     NAMES
fc71d06439b1   centos        "bash"                   8 seconds ago   Up 7 seconds                         ContCentos
```
Попробуем выполнить команду чтоб посмотреть версию Centos, а также о ядре системы:
```bash
user1@devopserubuntu:~$ sudo docker exec ContCentos cat /etc/centos-release
CentOS Linux release 8.4.2105

user1@devopserubuntu:~$ sudo docker exec ContCentos uname -a
Linux fc71d06439b1 5.13.0-27-generic #29-Ubuntu SMP Wed Jan 12 17:36:47 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```
Видим, что стоит Centos 8, но забавно, что ядро у него отображается от docker-хоста то есть Ubuntu.

Теперь сделаем всё то же самое с Debian. Создаём контейнер, запускаем, проверяем версию и версию ядра:
```bash
user1@devopserubuntu:~$ sudo docker run -d -it -v /home/user1/data:/data --name ContDebian debian bash
465439fc6c8c3eb82545a3e97da5d82af978d2c1f2bf802e3f3c6b239bc5a847

user1@devopserubuntu:~$ sudo docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED          STATUS          PORTS     NAMES
465439fc6c8c   debian    "bash"    10 seconds ago   Up 9 seconds              ContDebian
fc71d06439b1   centos    "bash"    11 minutes ago   Up 11 minutes             ContCentos

user1@devopserubuntu:~$ sudo docker exec ContDebian cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
NAME="Debian GNU/Linux"
VERSION_ID="11"
VERSION="11 (bullseye)"
VERSION_CODENAME=bullseye
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

user1@devopserubuntu:~$ sudo docker exec ContDebian uname -a
Linux 465439fc6c8c 5.13.0-27-generic #29-Ubuntu SMP Wed Jan 12 17:36:47 UTC 2022 x86_64 GNU/Linux
```

Теперь посмотрим, что оба контейнера примонтировали папку `/data` :
```bash
user1@devopserubuntu:~$ sudo docker exec ContCentos ls -la / | grep data
drwxrwxr-x   2 1000 1000 4096 Jan 27 06:24 data

user1@devopserubuntu:~$ sudo docker exec ContDebian ls -la / | grep data
drwxrwxr-x   2 1000 1000 4096 Jan 27 06:24 data
```
Папка есть. Теперь создаём файл с текстом в `/data` через контейнер Centos. 
```bash
user1@devopserubuntu:~$ sudo docker exec ContCentos /bin/bash -c "echo test1 > /data/test1.txt"
user1@devopserubuntu:~$ sudo docker exec ContCentos cat /data/test1.txt
test1
```
Это сработало. Но никакие другие варианты передать команду `echo test1 > /data/test1.txt` на исполнение в контейнер не получились (вариантов было море).
Поэтому в итоге запускаем через `/bin/bash -c "команда на выполнение" `.

Теперь на докер-хосте создаём в папке, которая смонтирована в контейнерные ОС, ещё один файл:
```bash
user1@devopserubuntu:~$ echo test2 > /home/user1/data/test2.txt
```
А теперь в контейнере Debian смотрим содержимое папки /data:
```bash
user1@devopserubuntu:~$ sudo docker exec ContDebian ls -la /data
total 16
drwxrwxr-x 2 1000 1000 4096 Jan 27 08:14 .
drwxr-xr-x 1 root root 4096 Jan 27 06:52 ..
-rw-r--r-- 1 root root    6 Jan 27 08:01 test1.txt
-rw-rw-r-- 1 1000 1000    6 Jan 27 08:14 test2.txt
```
Видим наши оба файла. Таким образом мы посмотрели, как "шарится" папка между хостовой машиной и двумя контейнерами.

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.
Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

#### Ответ
На докер-хосте создаём папку, кладём туда файл `Dockerfile`.
```bash
user1@devopserubuntu:~$ mkdir Make-own-docker-image-ansible
user1@devopserubuntu:~$ cd Make-own-docker-image-ansible/
```

```bash
user1@devopserubuntu:~/Make-own-docker-image-ansible$ cat Dockerfile
FROM alpine:3.14

RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 && \
    apk --no-cache add \
        sudo \
        python3\
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        openssl-dev \
        libressl-dev \
        build-base && \
    pip install --upgrade pip wheel && \
    pip install --upgrade cryptography cffi && \
    pip install ansible==2.9.24 && \
    pip install mitogen ansible-lint jmespath && \
    pip install --upgrade pywinrm && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

CMD [ "ansible-playbook", "--version" ]
```
Видим, что образ нашего будущего контейнера должен делаться на основании образа `alpine:3.14`, которого у нас пока нет.
Закачиваем в локальный репозиторий:
```bash
user1@devopserubuntu:~/Make-own-docker-image-ansible$ sudo docker pull alpine:3.14
[sudo] password for user1:
3.14: Pulling from library/alpine
97518928ae5f: Pull complete
Digest: sha256:635f0aa53d99017b38d1a0aa5b2082f7812b03e3cdb299103fe77b5c8a07f1d2
Status: Downloaded newer image for alpine:3.14
docker.io/library/alpine:3.14


user1@devopserubuntu:~/Make-own-docker-image-ansible$ sudo docker images
REPOSITORY        TAG       IMAGE ID       CREATED        SIZE
debian            latest    04fbdaf87a6a   39 hours ago   124MB
akazand/mynginx   0.7       fcf6f4373363   41 hours ago   141MB
mynginx           0.7       fcf6f4373363   41 hours ago   141MB
mynginx           0.5       2cc6139e76e9   41 hours ago   141MB
nginx             latest    605c77e624dd   4 weeks ago    141MB
alpine            3.14      0a97eee8041e   2 months ago   5.61MB
centos            latest    5d0da3dc9764   4 months ago   231MB
```
Видим, что он появился в списке образов.
Как мы поняли в предыдущей задаче, необходимо заранее знать, в какой репозиторий потом мы должны будем его загружать. Поэтому сначала пойдём на докер-хаб и создадим свой новый репозиторий.
Создали `akazand/ansible`. https://hub.docker.com/repository/docker/akazand/ansible

Теперь надо произвести cборку нового образа применив `Dockerfile`. Запускаем сборку нахдясь в папке с файлом.
```bash
user1@devopserubuntu:~/Make-own-docker-image-ansible$ sudo docker build -t akazand/ansible:2.9.24 .
Sending build context to Docker daemon   2.56kB
Step 1/5 : FROM alpine:3.14
 ---> 0a97eee8041e
Step 2/5 : RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 &&     apk --no-cache add         sudo         python3        py3-pip         openssl         ca-certificates         sshpass         openssh-client         rsync         git &&     apk --no-cache add --virtual build-dependencies         python3-dev         libffi-dev         musl-dev         gcc         cargo         openssl-dev         libressl-dev         build-base &&     pip install --upgrade pip wheel &&     pip install --upgrade cryptography cffi &&     pip install ansible==2.9.24 &&     pip install mitogen ansible-lint jmespath &&     pip install --upgrade pywinrm &&     apk del build-dependencies &&     rm -rf /var/cache/apk/* &&     rm -rf /root/.cache/pip &&     rm -rf /root/.cargo
 ---> Running in fa5cd343c497
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/community/x86_64/APKINDEX.tar.gz
(1/55) Installing ca-certificates (20211220-r0)
(2/55) Installing brotli-libs (1.0.9-r5)
(3/55) Installing nghttp2-libs (1.43.0-r0)
.... пропускаем большой листинг .......
(34/37) Purging pcre (8.44-r0)
(35/37) Purging libssh2 (1.9.0-r1)
(36/37) Purging libressl3.3-libcrypto (3.3.3-r0)
(37/37) Purging libmagic (5.40-r1)
Executing busybox-1.33.1-r6.trigger
OK: 98 MiB in 69 packages
Removing intermediate container fa5cd343c497
 ---> dfa76f09c252
Step 3/5 : RUN mkdir /ansible &&     mkdir -p /etc/ansible &&     echo 'localhost' > /etc/ansible/hosts
 ---> Running in 992a715df8c9
Removing intermediate container 992a715df8c9
 ---> 48c1fe90dd7a
Step 4/5 : WORKDIR /ansible
 ---> Running in a1b26c9cc224
Removing intermediate container a1b26c9cc224
 ---> 038303fb14be
Step 5/5 : CMD [ "ansible-playbook", "--version" ]
 ---> Running in 0baa16529242
Removing intermediate container 0baa16529242
 ---> 885b0988c5e0
Successfully built 885b0988c5e0
Successfully tagged akazand/ansible:2.9.24
```
Проверяем, что новый образ `akazand/ansible:2.9.24` появился в списке:
```bash
user1@devopserubuntu:~/Make-own-docker-image-ansible$ sudo docker images
REPOSITORY        TAG       IMAGE ID       CREATED          SIZE
akazand/ansible   2.9.24    885b0988c5e0   24 seconds ago   227MB
debian            latest    04fbdaf87a6a   42 hours ago     124MB
akazand/mynginx   0.7       fcf6f4373363   44 hours ago     141MB
mynginx           0.7       fcf6f4373363   44 hours ago     141MB
mynginx           0.5       2cc6139e76e9   44 hours ago     141MB
nginx             latest    605c77e624dd   4 weeks ago      141MB
alpine            3.14      0a97eee8041e   2 months ago     5.61MB
centos            latest    5d0da3dc9764   4 months ago     231MB
```
Теперь логинимся и отправляем его в глобальный репозиторий:
```bash
user1@devopserubuntu:~/Make-own-docker-image-ansible$ sudo docker login -u akazand
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
Login Succeeded

user1@devopserubuntu:~/Make-own-docker-image-ansible$ sudo docker push akazand/ansible:2.9.24
The push refers to repository [docker.io/akazand/ansible]
a92e9a29c0d3: Pushed
eefeff69ac5a: Pushed
1a058d5342cc: Mounted from library/alpine
2.9.24: digest: sha256:7161dd1f400fc572abd8870ebb845ebcab0659864cb808973ad350779caeba48 size: 947
```
Проверил через веб. Образ присутствует.

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
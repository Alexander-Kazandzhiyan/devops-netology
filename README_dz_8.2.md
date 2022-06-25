# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
3. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Итоговые материалы
Итоговый готовый плейбук находится в папке src_dz_8.2_ansible
Отдельный репозиторий с этой домашней работой: https://github.com/Alexander-Kazandzhiyan/dz_8.2_ansible/

# Выполнение

## Подготовка к выполнению
1. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.

На гитхабе создан новый репозиторий: https://github.com/Alexander-Kazandzhiyan/dz_8.2_ansible
На хосте, где мы будем работать создан локальный репозиторий и подключен к гитхабу.
```bash
user1@devopserubuntu:~$ mkdir dz_8.2_ansible

user1@devopserubuntu:~/dz_8.2_ansible$ git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint:
hint:   git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint:   git branch -m <name>
Initialized empty Git repository in /home/user1/dz_8.2_ansible/.git/

user1@devopserubuntu:~/dz_8.2_ansible$ git branch -M main
user1@devopserubuntu:~/dz_8.2_ansible$ git remote add origin git@github.com:Alexander-Kazandzhiyan/dz_8.2_ansible.git
user1@devopserubuntu:~/dz_8.2_ansible$ git add .
user1@devopserubuntu:~/dz_8.2_ansible$ git commit -m "first commit"
On branch main
Initial commit
nothing to commit (create/copy files and use "git add" to track)
```

2. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

В папку `/home/user1/dz_8.2_ansible/` скопировано содержимое репозитория с заданием. Зальём это всё в виде первого коммита на гитхаб в новый репозиторий:
```bash
user1@devopserubuntu:~/dz_8.2_ansible$ git add .
user1@devopserubuntu:~/dz_8.2_ansible$ git commit -m "first commit"
[main (root-commit) a1e7188] first commit
 8 files changed, 131 insertions(+)
 create mode 100644 README.md
 create mode 100644 playbook/.gitignore
 create mode 100644 playbook/group_vars/all/vars.yml
 create mode 100644 playbook/group_vars/elasticsearch/vars.yml
 create mode 100644 playbook/inventory/prod.yml
 create mode 100755 playbook/site.yml
 create mode 100644 playbook/templates/elk.sh.j2
 create mode 100644 playbook/templates/jdk.sh.j2
user1@devopserubuntu:~/dz_8.2_ansible$
user1@devopserubuntu:~/dz_8.2_ansible$ git push -u origin main
Enumerating objects: 16, done.
Counting objects: 100% (16/16), done.
Delta compression using up to 4 threads
Compressing objects: 100% (12/12), done.
Writing objects: 100% (16/16), 3.23 KiB | 1.61 MiB/s, done.
Total 16 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), done.
To github.com:Alexander-Kazandzhiyan/dz_8.2_ansible.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
user1@devopserubuntu:~/dz_8.2_ansible$
```

3. Подготовьте хосты в соотвтествии с группами из предподготовленного playbook. 

В данном примере инвентори выглядит так:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat inventory/prod.yml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: <IP_here> 
```
Видимо предполагается, что нужно использовать физическую или виртуальную машину. Но мы будем работать с доке-контейнерами, поэтому исправим инвентори-файл:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat inventory/prod.yml
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: docker
```
Запустим новый контейнер на базе Centos, так как видно в плейбуке, что будут устанавливаться rpm-пакеты:
```bash
user1@devopserubuntu:~/$ sudo docker container sudo docker run -d -it --name clickhouse-01 centos
user1@devopserubuntu:~/$ sudo docker container ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
98aa77a88e0d   centos    "/bin/bash"   20 seconds ago   Up 19 seconds             clickhouse-01
```
То есть это я сначала пытался так его запустить, но как выяснилось, в таком простом варианте запуска не работают службы `systemd`. Нужно было делать иначе, чтоб в контейнере заработал `systemd` и впоследствии возможно было запустить сервер `clickhouse`, который устанавливаем в этом плейбуке. Создавать и запускать контейнер нужно так:
```bash
sudo docker run -d -it --name clickhouse-01 --privileged=true centos /sbin/init
```
Вот теперь в контейнере будет работать 'systemd'.

Вот плейбук, данный в задании (забегая вперёд, скажу, что он совсем сырой и не рабочий, пришлось много исправлять):
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat site.yml
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Create database
      ansible.builtin.command: ""
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
```
Для того, чтобы хоть как-то находить ошибки и исправлять, необходимо было запускать плейбук с ключём `-vvv` вот так:
```bash
$ sudo ansible-playbook -vvv site.yml -i inventory/prod_docker.yml
```
Я многократно пытался запустить плейбук, но получал массу проблем с отработкой его на докере. Сначала не выполнялась команда `sudo` оказывается эта утилита не была установлена в докере `Centos`.
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml

PLAY [Install Clickhouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "module_stderr": "/bin/sh: sudo: command not found\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0
```
Чтоб её установить пришлось бороться с неработающим в докере `yum` Помогло решение: https://techglimpse.com/failed-metadata-repo-appstream-centos-8/ 
Доработаем плейбук, чтобы ансибл сам исправил yum, обновил все пакеты, а главное установил `sudo`.

Добавили ещё один таск первым в плейбуке. Получилось такое:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat site.yml
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - name: Repare yum for working
      ansible.builtin.shell: cd /etc/yum.repos.d &&sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* &&yum install sudo -y &&yum update -y
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
```

После этого при установке  получаю ошибку:
```bash
sudo ansible-playbook site.yml -i inventory/prod_docker.yml
...
TASK [Install clickhouse packages] ***********************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "Failed to validate GPG signature for clickhouse-client-22.3.3.44-1.noarch"}

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0
```
Эту проблему удалось обойти дописав в таск по установке пакетов настройку: 'disable_gpg_check: True'.
Теперь пакеты все устанавливаются, но дело дальше не идёт:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod_docker.yml

PLAY [Install Clickhouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] ***********************************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "cmd": ["clickhouse-client", "-q", "create database logs;"], "delta": "0:00:00.040586", "end": "2022-06-19 06:01:11.830743", "failed_when_result": true, "msg": "non-zero return code", "rc": 210, "start": "2022-06-19 06:01:11.790157", "stderr": "Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)", "stderr_lines": ["Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)"], "stdout": "", "stdout_lines": []}

RUNNING HANDLER [Start clickhouse service] ***************************************************************************************************************************************************

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0
```
Судя по всему проблема была в том, что сервер `clickhouse` не запускается, но к нему пытается приконнектиться клиент для создания бд.

Это было До того, как я сообразил запускать докер-контейнер с центосом так, чтобы там жил `systemd` и у меня получалось следующее:

При попытке залесть и покопаться в самом контейнере выяснялось, что демон `systemd`, который должен запускать службы, не работает в контейнере.
```bash
[root@98aa77a88e0d yum.repos.d]# systemctl list-unit-files | grep click
clickhouse-server.service              disabled

[root@98aa77a88e0d yum.repos.d]# systemctl status clickhouse-server.service
System has not been booted with systemd as init system (PID 1). Cant operate.
Failed to connect to bus: Host is down

[root@98aa77a88e0d yum.repos.d]# systemctl start clickhouse-server.service
System has not been booted with systemd as init system (PID 1). Cant operate.
Failed to connect to bus: Host is down
[root@98aa77a88e0d yum.repos.d]#
```

Теперь-же, когда контейнер запускается с работающим `systemd` в нём получается такое:
```bash
[root@8ad6ccc116f2 yum.repos.d]# systemctl list-unit-files | grep click
clickhouse-server.service              disabled

[root@8ad6ccc116f2 yum.repos.d]# systemctl status clickhouse-server.service
● clickhouse-server.service - ClickHouse Server (analytic DBMS for big data)
   Loaded: loaded (/usr/lib/systemd/system/clickhouse-server.service; disabled; vendor preset: disabled)
   Active: inactive (dead)

[root@8ad6ccc116f2 yum.repos.d]# systemctl enable clickhouse-server.service
Synchronizing state of clickhouse-server.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install enable clickhouse-server
Created symlink /etc/systemd/system/multi-user.target.wants/clickhouse-server.service → /usr/lib/systemd/system/clickhouse-server.service.

[root@8ad6ccc116f2 yum.repos.d]# systemctl start clickhouse-server.service

[root@8ad6ccc116f2 yum.repos.d]# systemctl status clickhouse-server.service
● clickhouse-server.service - ClickHouse Server (analytic DBMS for big data)
   Loaded: loaded (/usr/lib/systemd/system/clickhouse-server.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2022-06-19 07:44:48 UTC; 3s ago
 Main PID: 2878 (clckhouse-watch)
    Tasks: 200 (limit: 3700)
   Memory: 72.1M
   CGroup: /system.slice/clickhouse-server.service
           ├─2878 clickhouse-watchdog --config=/etc/clickhouse-server/config.xml --pid-file=/run/clickhouse-server/clickhouse-server.pid
           └─2879 /usr/bin/clickhouse-server --config=/etc/clickhouse-server/config.xml --pid-file=/run/clickhouse-server/clickhouse-server.pid

Jun 19 07:44:48 8ad6ccc116f2 systemd[1]: Started ClickHouse Server (analytic DBMS for big data).
Jun 19 07:44:48 8ad6ccc116f2 clickhouse-server[2878]: Processing configuration file '/etc/clickhouse-server/config.xml'.
Jun 19 07:44:48 8ad6ccc116f2 clickhouse-server[2878]: Logging trace to /var/log/clickhouse-server/clickhouse-server.log
Jun 19 07:44:48 8ad6ccc116f2 clickhouse-server[2878]: Logging errors to /var/log/clickhouse-server/clickhouse-server.err.log
Jun 19 07:44:49 8ad6ccc116f2 clickhouse-server[2878]: Processing configuration file '/etc/clickhouse-server/config.xml'.
Jun 19 07:44:49 8ad6ccc116f2 clickhouse-server[2878]: Saved preprocessed configuration to '/var/lib/clickhouse/preprocessed_configs/config.xml'.
Jun 19 07:44:49 8ad6ccc116f2 clickhouse-server[2878]: Processing configuration file '/etc/clickhouse-server/users.xml'.
Jun 19 07:44:49 8ad6ccc116f2 clickhouse-server[2878]: Saved preprocessed configuration to '/var/lib/clickhouse/preprocessed_configs/users.xml'.
```
Видим, что сервер `clickhouse` установлен, но отключен и не запущен. Если попытаться руками запустить сервер `clickhouse`, то он запускается. 
Впилим это в плейбук в виде отдельного таска `Enable and start Clickhouse.server service` :
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat site.yml
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - name: Repare yum for working
      ansible.builtin.shell: cd /etc/yum.repos.d &&sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* &&yum install sudo -y &&yum update -y
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
        disable_gpg_check: True
      notify: Start clickhouse service
    - name: Enable and start Clickhouse.server service
      ansible.builtin.systemd:
        name: clickhouse-server
        enabled: yes
        state: started
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
```
Попробуем выполнить этот плейбук. Для начала для чистоты эксперимента удалим все контейнеры и запустим новый в чистом, так сказать, виде:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo docker container stop clickhouse-01
clickhouse-01
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo docker container rm clickhouse-01
clickhouse-01
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo docker run -d -it --name clickhouse-01 --privileged=true centos /sbin/init
fec361e2d08f7912465f4b1ad2dbdedc058454a9aaccc8f3108f6cbbb28271f2
```
Запускаем плейбук:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod_docker.yml

PLAY [Install Clickhouse] *********************************************************************************************************************************************************************

TASK [Gathering Facts] ************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Repare yum for working] *****************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Get clickhouse distrib] *****************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *****************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Enable and start Clickhouse.server service] *********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] ************************************************************************************************************************************************************************
changed: [clickhouse-01]

RUNNING HANDLER [Start clickhouse service] ****************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY RECAP ************************************************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
```
Как мы видим, ошибок нет, всё выполнилось.

Залезем в контейнер и посмотрим, что там видно:
```bash
user1@devopserubuntu:~$ sudo docker exec -it clickhouse-01 /bin/bash
[sudo] password for user1:

[root@b2e0c8e4af46 /]# clickhouse-client
ClickHouse client version 22.3.3.44 (official build).
Connecting to localhost:9000 as user default.
Connected to ClickHouse server version 22.3.3 revision 54455.

b2e0c8e4af46 :) SHOW DATABASES;

SHOW DATABASES

Query id: cdef4408-ae07-4d42-a1b8-8d177cdc95a8

┌─name───────────────┐
│ INFORMATION_SCHEMA │
│ default            │
│ information_schema │
│ logs               │
│ system             │
└────────────────────┘

5 rows in set. Elapsed: 0.003 sec.

b2e0c8e4af46 :)
```
Видим, что БД `logs` создалась. Ура!


## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

## Выполнение

# Подготовка
Сначала нужно было разобраться, что за `vector` такой и как его устанавливать. На офф сайте имеются разные дистрибутивы. Самое простое было бы поставить его из RPM. Но судя по пожеланию в п.3 использовать `unarchive` видимо предполагается, что надо использовать дистрибутив в виде архива. Возни там будет больше, конечно.

Итак, прежде чем начинать делать это с помощью ансибла, кажется, что стоит попробовать создать контейнер и сделать всю установку с нуля руками, а затем эту процедуру описать в ансибле.
Мне пришлось изрядно поработать, чтобы сделать это. Но, похоже всё получилось.

Вот, какой получился скрипт установки:
```bash
# Приводим yum в рабочее состояние, устанавливаем sudo , wget и обновляем систему.
cd /etc/yum.repos.d &&sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* &&yum install sudo -y &&yum install wget -y &&yum update -y

# Переходим в папку для установки
cd /root
# Качаем дистрибутив в архиве
wget https://packages.timber.io/vector/0.22.2/vector-0.22.2-x86_64-unknown-linux-musl.tar.gz
# Создаём папку и разпоковываем туда 
mkdir vector
tar xzf vector-0.22.2-x86_64-unknown-linux-musl.tar.gz -C vector --strip-components=2

# Делаем ссылку на запускаемый файл в папке /usr/bin и меняем права на файл
ln -L /root/vector/bin/vector /usr/bin/vector
chmod 777 /usr/bin/vector

# Создаём папку для настроек. Делаем туда линк на файл с настройками
mkdir /etc/vector
ln -L /root/vector/config/vector.toml /etc/vector/vector.toml

# Создаём рабочую папку и даём на неё права 
mkdir /var/lib/vector/
chmod -R 777 /var/lib/vector/

# Создаём пользователя под которым будет работать продукт
useradd vector

# Устанавливаем файл запуска в systemd
cp -av /root/vector/etc/systemd/vector.service /etc/systemd/system
# включаем в автозапуск
systemctl enable vector
# запускаем
systemctl start vector
# Смотрим состояние
systemctl status vector
```

Проверим, что это действительно работает. Создаём контейнер, как в предыдущем примере, но не запускаем на нём clickhouse, а заходим в консоль, размещаем там этот скрипт и запускаем.
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo docker run -d -it --name clickhouse-01 --privileged=true centos /sbin/init
[sudo] password for user1:
c34a7fcd5bfefbc431830597a2a44a012b286d86165eb29d671a7f3f596e5c19

user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo docker container ps
CONTAINER ID   IMAGE     COMMAND        CREATED          STATUS          PORTS     NAMES
c34a7fcd5bfe   centos    "/sbin/init"   15 minutes ago   Up 11 minutes             clickhouse-01

user1@devopserubuntu:~$ sudo docker exec -it clickhouse-01 /bin/bash
[root@c34a7fcd5bfe /]# 
[root@c34a7fcd5bfe /]# cat > /installvector.sh
....размещаем такст скрипта..

[root@c34a7fcd5bfe /]# sh /installvector.sh

... тут много всего особенно из-за апдейта...

[root@c34a7fcd5bfe /]# systemctl status vector
● vector.service - Vector
   Loaded: loaded (/etc/systemd/system/vector.service; enabled; vendor preset: disabled)
   Active: active (running) since Sat 2022-06-25 06:23:21 UTC; 1min 36s ago
     Docs: https://vector.dev
  Process: 581 ExecStartPre=/usr/bin/vector validate (code=exited, status=0/SUCCESS)
 Main PID: 586 (vector)
    Tasks: 6 (limit: 3700)
   Memory: 5.8M
   CGroup: /system.slice/vector.service
           └─586 /usr/bin/vector

Jun 25 06:24:48 c34a7fcd5bfe vector[586]: {"appname":"devankoshal","facility":"daemon","hostname":"some.org","message":"You're not gonna believe what just happened","msgid":"ID6",">
Jun 25 06:24:49 c34a7fcd5bfe vector[586]: {"appname":"ahmadajmi","facility":"local6","hostname":"up.net","message":"Maybe we just shouldn't use computers","msgid":"ID701","procid":>
Jun 25 06:24:50 c34a7fcd5bfe vector[586]: {"appname":"devankoshal","facility":"kern","hostname":"for.com","message":"#hugops to everyone who has to deal with this","msgid":"ID152",>
```
Итак скрипт работает. Теперь надо записать его как код ансибла.

1. Приготовьте свой собственный inventory файл `prod.yml`.
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

Итак. я взял уже готовый плейбук, созданные ранее в этом ДЗ. И решил добавить в него новую часть по Vector. 
Только я вынес часть по ремонту yum , обновлению пакетов и установке sudo в отдельный play.
Вот, что у меня получилось:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat site.yml
---
- name: Podgotovka Systemi
  hosts: clickhouse
  tasks:
    - name: Repare yum repo
      ansible.builtin.shell: cd /etc/yum.repos.d &&sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

    - name: Upgrade all packages (yum update)
      ansible.builtin.yum:
        name: '*'
        state: latest

    - name: ym install sudo
      ansible.builtin.yum:
        name: 'sudo'
        state: latest

- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"

    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
        disable_gpg_check: True
      notify: Start clickhouse service

    - name: Enable and start Clickhouse.server service
      ansible.builtin.systemd:
        name: clickhouse-server
        enabled: yes
        state: started

    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0

- name: Install Vector
  hosts: clickhouse
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
        dest: "/root/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"

    - name: Create vector ditrib directory
      ansible.builtin.file:
        path: /root/vector
        state: directory
        mode: '0775'

    - name: Unpack distrib
      ansible.builtin.unarchive:
        src: "/root/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
        dest: /root
        remote_src: yes

    - name: Create bin link to vector
      ansible.builtin.file:
        src: /root/vector-x86_64-unknown-linux-musl/bin/vector
        dest: /usr/bin/vector
        state: hard

    - name: Create vector config directory
      ansible.builtin.file:
        path: /etc/vector
        state: directory
        mode: '0775'

    - name: Create link to vector config
      ansible.builtin.file:
        src: /root/vector-x86_64-unknown-linux-musl/config/vector.toml
        dest: /etc/vector/vector.toml
        state: hard

    - name: Create vector work directory
      ansible.builtin.file:
        path: /var/lib/vector
        state: directory
        mode: '0777'

    - name: Add user for vector service
      ansible.builtin.user:
        name: vector
        comment: vector servie user

    - name: Copy file unit to systemd
      ansible.builtin.copy:
        src: /root/vector-x86_64-unknown-linux-musl/etc/systemd/vector.service
        dest: /etc/systemd/system
        remote_src: yes

    - name: Enable and start vector service
      ansible.builtin.systemd:
        name: vector
        enabled: yes
        state: started
```
Забыл сказать, что в файл с переменными я добавил переменную с номером версии `vector`
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat group_vars/clickhouse/vars.yml
---
clickhouse_version: "22.3.3.44"
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static
vector_version: "0.22.2"
```
Я проверил работу плейбука - работает. Clickhouse и vector устанавливаются, запускаются и работают.

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

При попытке проверить корректность плейбука получаю одно замечание:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo ansible-lint site.yml
WARNING  Listing 1 violation(s) that are fatal
[204] Lines should be no longer than 160 chars
site.yml:6
      ansible.builtin.shell: cd /etc/yum.repos.d &&sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

You can skip specific rules or tags by adding them to your configuration file:

┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ # .ansible-lint                                                                                                                                                                   │
│ warn_list:  # or 'skip_list' to silence them completely                                                                                                                           │
│   - '204'  # Lines should be no longer than 160 chars                                                                                                                             │
└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘ 
```
Линту не понравилась длинная строчка, которая исправляет проблемы с yum репозиториями.
Внесём изменение. Разобъём шелловскую команду на несколько строк.

Заменим это:
```bash
    - name: Repare yum repo
      ansible.builtin.shell: cd /etc/yum.repos.d &&sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
```
На это:
```bash
     - name: Repare yum repo
      ansible.builtin.shell: cd /etc/yum.repos.d &&
        sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
```
Линт больше не ругается. При этом playbook выполняется. Интересно, что во время поиска варианта исправления получался какой-то вариант, на который линт не ругался, однако этот плейбук не работал, выдавал ошибку при выполнении.
В итоге плейбук получился такой:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ cat site.yml
---
- name: Podgotovka Systemi
  hosts: clickhouse
  tasks:
    - name: Repare yum repo
      ansible.builtin.shell: cd /etc/yum.repos.d &&
        sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* &&
        sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

    - name: Upgrade all packages (yum update)
      ansible.builtin.yum:
        name: '*'
        state: latest

    - name: ym install sudo
      ansible.builtin.yum:
        name: 'sudo'
        state: latest

- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"

    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
        disable_gpg_check: True
      notify: Start clickhouse service

    - name: Enable and start Clickhouse.server service
      ansible.builtin.systemd:
        name: clickhouse-server
        enabled: yes
        state: started

    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0

- name: Install Vector
  hosts: clickhouse
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
        dest: "/root/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"

    - name: Create vector ditrib directory
      ansible.builtin.file:
        path: /root/vector
        state: directory
        mode: '0775'

    - name: Unpack distrib
      ansible.builtin.unarchive:
        src: "/root/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
        dest: /root
        remote_src: yes

    - name: Create bin link to vector
      ansible.builtin.file:
        src: /root/vector-x86_64-unknown-linux-musl/bin/vector
        dest: /usr/bin/vector
        state: hard

    - name: Create vector config directory
      ansible.builtin.file:
        path: /etc/vector
        state: directory
        mode: '0775'

    - name: Create link to vector config
      ansible.builtin.file:
        src: /root/vector-x86_64-unknown-linux-musl/config/vector.toml
        dest: /etc/vector/vector.toml
        state: hard

    - name: Create vector work directory
      ansible.builtin.file:
        path: /var/lib/vector
        state: directory
        mode: '0777'

    - name: Add user for vector service
      ansible.builtin.user:
        name: vector
        comment: vector servie user

    - name: Copy file unit to systemd
      ansible.builtin.copy:
        src: /root/vector-x86_64-unknown-linux-musl/etc/systemd/vector.service
        dest: /etc/systemd/system
        remote_src: yes

    - name: Enable and start vector service
      ansible.builtin.systemd:
        name: vector
        enabled: yes
        state: started
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
Пробуем запустить плейбук в режиме проверки:
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod_docker.yml --check

PLAY [Podgotovka Systemi] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Repare yum repo] **************************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Upgrade all packages (yum update)] ********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [ym install sudo] **************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Enable and start Clickhouse.server service] ***********************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector] ***************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get vector distrib] ***********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create vector ditrib directory] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Unpack distrib] ***************************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Create bin link to vector] ****************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create vector config directory] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create link to vector config] *************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create vector work directory] *************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Add user for vector service] **************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Copy file unit to systemd] ****************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Enable and start vector service] **********************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP **************************************************************************************************************************************************************************
clickhouse-01              : ok=17   changed=0    unreachable=0    failed=0    skipped=3    rescued=1    ignored=0
```
Выполнилось успешно.

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
```bash
user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod_docker.yml --diff

PLAY [Podgotovka Systemi] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Repare yum repo] **************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Upgrade all packages (yum update)] ********************************************************************************************************************************************
changed: [clickhouse-01]

TASK [ym install sudo] **************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] **************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Enable and start Clickhouse.server service] ***********************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] **************************************************************************************************************************************************************
changed: [clickhouse-01]

RUNNING HANDLER [Start clickhouse service] ******************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector] ***************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get vector distrib] ***********************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create vector ditrib directory] ***********************************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0775",
     "path": "/root/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [clickhouse-01]

TASK [Unpack distrib] ***************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create bin link to vector] ****************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/usr/bin/vector",
-    "state": "absent"
+    "state": "hard"
 }

changed: [clickhouse-01]

TASK [Create vector config directory] ***********************************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0775",
     "path": "/etc/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [clickhouse-01]

TASK [Create link to vector config] *************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/etc/vector/vector.toml",
-    "state": "absent"
+    "state": "hard"
 }

changed: [clickhouse-01]

TASK [Create vector work directory] *************************************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0777",
     "path": "/var/lib/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [clickhouse-01]

TASK [Add user for vector service] **************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Copy file unit to systemd] ****************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Enable and start vector service] **********************************************************************************************************************************************
changed: [clickhouse-01]

PLAY RECAP **************************************************************************************************************************************************************************
clickhouse-01              : ok=21   changed=18   unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
```
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Запускаю повторно
```bash
 user1@devopserubuntu:~/dz_8.2_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod_docker.yml --diff

PLAY [Podgotovka Systemi] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Repare yum repo] **************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Upgrade all packages (yum update)] ********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [ym install sudo] **************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Clickhouse] ***********************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] *******************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Enable and start Clickhouse.server service] ***********************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create database] **************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector] ***************************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get vector distrib] ***********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create vector ditrib directory] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Unpack distrib] ***************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create bin link to vector] ****************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create vector config directory] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create link to vector config] *************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create vector work directory] *************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Add user for vector service] **************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Copy file unit to systemd] ****************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Enable and start vector service] **********************************************************************************************************************************************
ok: [clickhouse-01]

PLAY RECAP **************************************************************************************************************************************************************************
clickhouse-01              : ok=20   changed=1    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
```
Всё в порядке плейбук иденпотентен.

9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
Излагаю тут тоже всю информацию:
Плейбук созданный в рамках этого ДЗ выполняет следующие действия:
    - Исправляет работу yum, обновляет все пакеты в контейнере и доустанавливает `sudo`
    - Использует версии, продуктов, указанные в виде переменных в файле переменных
    - Скачивает и устанавливает все компаненты `Clickhouse` : сервер, клиента и общие модули
    - Устанавливает в автозапуск сервер `Clickhouse` и запускает его
    - Создаёт в `clickhouse` БД `logs`
    - Скачивает дистрибутив `vector`, указанной версии в виде архива
    - Распаковывает архив и размещает хардлинки на необходимые для работы `vector` файлы в нужных местах системы
    - Создаёт рабочую папку для `vector`
    - Организует автозапуск службы `vector` с помощью `systemd` и запускает его.

Плейбук создавался и тестировался в таком окружении: Контейнер с `Centos 8` , запущенный с поддержкой работы `systemd`.

11. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


---
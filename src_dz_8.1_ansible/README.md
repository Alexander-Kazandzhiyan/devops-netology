# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.
2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.
3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.
4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.
2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.
3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

## Выполнение
## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.

Ansible уже установлен:
```bash
 user1@devopserubuntu:~$ sudo ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.9.7 (default, Sep 10 2021, 14:59:43) [GCC 11.2.0]
```
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.

Зашёл на гитхаб под собой и создал новый репозииторий: https://github.com/Alexander-Kazandzhiyan/dz_8.1_ansible
Зашёл в настройки профиля гитхаба и добавил там публичный ssh-ключ с этого своего сервера, создав его командой:
```bash
# ssh-keygen -t ed25519 -C "7822119@gmail.com"
# cat /home/user1/.ssh/id_ed25519.pub
```
содержимое файла разместил в настройках профиля гитхаба.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

Создал папку 
```bash
user1@devopserubuntu:~$ mkdir dz_all_ansible
user1@devopserubuntu:~$ git clone https://github.com/netology-code/mnt-homeworks.git
```
Скачался весь репозиторий.

Теперь готовим к работе свой репо, прикрепляя его к гитхабовскому. 
Создал локально папку `dz_8.1_ansible`.  Копируем сюда содержимое папки `/home/user1/mnt-homeworks/08-ansible-01-base`

Зашёл в папку
```bash
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:Alexander-Kazandzhiyan/dz_8.1_ansible.git
git config --global user.name "Alexander K"
git config --global user.email "77777777777@gmail.com"
sudo git push -u origin main
```
В гитхаб закачались все файлы плейбука.
![img_87.png](img_87.png)

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 21.10 on host localhost should use /usr/bin/python3, but is using /usr/bin/python for backward compatibility with prior Ansible releases. A future
 Ansible release will default to using the discovered platform python for this host. See https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more
information. This feature will be removed in version 2.12. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Как мы видим мы получили информацию, что ансибл решил использовать устаревший python. Проверяем, что версия python3 установлена и он её видит.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible --version | grep "python version"
  python version = 3.9.7 (default, Sep 10 2021, 14:59:43) [GCC 11.2.0]
```
Видим, что есть. Попробуем его использовать:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-playbook site.yml -i inventory/test.yml -e 'ansible_python_interpreter=/usr/bin/python3'

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Получилось. Но чтобы каждый раз не указывать путь к пайтону, можно сделать конфиг для ансибла. Я честно попробовал. Сделал конфиг в текущей папке (другие варианты размещения тоже пробовал). Проверил, что он его видит:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-config view
[defaults]
deprecation_warnings=False
#ansible_python_interpreter=/usr/bin/python3
```
Сейчас строчка с пайтоном закомментирована, потому что эта опция никак не помогала избавиться от варнинга. Поэтому пришлось просто отключить уведомление настройкой `deprecation_warnings=False`. 
Теперь всё ок.

Отвечая на вопрос : В плейбуке `site.yml` мы видим, что данная переменная должна выводиться в таске `Print facts` смотрим, что было в выводе.
Итак `some_fact` = 12.

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

Файл найден:
```bash
$ cat ~/dz_8.1_ansible/playbook/group_vars/all/examp.yml
---
  some_fact: 12
```
Меняем значение:
```bash
$ cat ~/dz_8.1_ansible/playbook/group_vars/all/examp.yml
---
  some_fact: all default fact
```
Смотрим на результат:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

см. далее

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

Посмотрим, что у нас описано в окружении  `prod.yml`:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
```
Видим, что требуется два контейнера `Centos7` и `Ubuntu`.
смотрим, какие есть образы у нас в системе
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo docker image ls | grep centos
centos                      latest          5d0da3dc9764   8 months ago    231MB
```
Центос имеется.
Ubuntu нет, заливаем.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo docker image ls | grep ubuntu

user1@devopserubuntu:~$ sudo docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
405f018f9d1d: Pull complete
Digest: sha256:b6b83d3c331794420340093eb706a6f152d9c1fa51b262d9bf34594887c2c7ac
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest

user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo docker image ls | grep ubuntu
ubuntu                      latest          27941809078c   4 days ago      77.8MB
```
Запускаем контейнеры, давая им имена, как указано в окружении `prod.yaml`
```bash
user1@devopserubuntu:~$ sudo docker container ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

user1@devopserubuntu:~$ sudo docker run -d -it --name centos7 centos
31136b98505374afba62f2d45f72c3c2d9011d901fd067fb9078027edfa5f979

user1@devopserubuntu:~$ sudo docker run -d -it --name ubuntu ubuntu
56806c01a1069e12675be25ea31a7eaf2734afd045b655962f27fbb1290cf62c

user1@devopserubuntu:~$ sudo docker container ps
CONTAINER ID   IMAGE     COMMAND       CREATED         STATUS         PORTS     NAMES
56806c01a106   ubuntu    "bash"        5 seconds ago   Up 4 seconds             ubuntu
31136b985053   centos    "/bin/bash"   3 minutes ago   Up 3 minutes             centos7
```
Оба запустились. Пробуем запустить плейбук
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
fatal: [ubuntu]: FAILED! => {"ansible_facts": {}, "changed": false, "failed_modules": {"ansible.legacy.setup": {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python"}, "failed": true, "module_stderr": "/bin/sh: 1: /usr/bin/python: not found\n", "module_stdout": "", "msg": "The module failed to execute correctly, you probably need to set the interpreter.\nSee stdout/stderr for the exact error", "rc": 127, "warnings": ["No python interpreters found for host ubuntu (tried ['/usr/bin/python', 'python3.9', 'python3.8', 'python3.7', 'python3.6', 'python3.5', 'python2.7', 'python2.6', '/usr/libexec/platform-python', '/usr/bin/python3', 'python'])"]}}, "msg": "The following modules failed to execute: ansible.legacy.setup\n"}
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=0    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
Видим, что с Центосом всё в порядке, а по поводу ubuntu нам сообщают, что там отсутствует python.
Попробуем его доустановить, подключившись в контейнер:
```bash
user1@devopserubuntu:~$ sudo docker exec -it ubuntu /bin/bash
root@6ac054c16c87:~#
root@6ac054c16c87:~# apt-get update
.....
root@6ac054c16c87:~# apt-get install python3.
.....

root@6ac054c16c87:~# python3 --version
Python 3.10.4
```
Снова пробуем плейбук:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Теперь всё успешно. 

Some_facts для centos7 = "el"

Some_facts для  ubuntu = "deb"

6. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

Добиться вывода в `msg` требуемых записей можно разными способами. Самый простой  - в плейбуке `site.yaml` приписать продолжение строки вывода факта вот так:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat site.yml
---
  - name: Print os facts
    hosts: all
    tasks:
      - name: Print OS
        debug:
          msg: "{{ ansible_distribution }}"
      - name: Print fact
        debug:
          msg: "{{ some_fact }} default fact"
```
Можно в файлах переменных по каждой группе хостов добавить ещё один факт, а затем при выводе в плейбуке их склеить.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook/group_vars/deb$ cat examp.yml
---
  some_fact: "deb"
  some_subfact: "default fact"
```
и
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook/group_vars/el$ cat examp.yml
---
  some_fact: "el"
  some_subfact: "default fact"
```
и
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat site.yml
---
  - name: Print os facts
    hosts: all
    tasks:
      - name: Print OS
        debug:
          msg: "{{ ansible_distribution }}"
      - name: Print fact
        debug:
          msg: "{{ some_fact }} {{ some_subfact }}"
```
А, ну есть совсем простой способ - просто в имеющихся фактах `some_fact` в файле по каждой группе дописать ` default fact`

Результат во всех способах будет одинаковый.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml
[sudo] password for user1:

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

7. Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

Не вполне понял зачем, но да, работает :)

8. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

В составе ansible есть утилита `ansible-vault`, которая может шифровать и расшифровывать содержимое плейбуков и их одтельных частей. Причём они будут потом работать и при этом не будут расшифрованы на фс.
Попробуем зашифровать один из файлов с фактами:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat ./group_vars/el/examp.yml
---
  some_fact: "el"
  some_subfact: "default fact"

user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-vault encrypt ./group_vars/el/examp.yml
New Vault password:
Confirm New Vault password:
Encryption successful

user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat ./group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
65626437316365346336643864376338623937393337396439353531666363653232346561303462
3361643764626532353733616532646534336465353864380a633964633830353830376539333432
61393165373232316161323365363932313830323862646332623534376235343465363136366534
3065616433626131610a323535343766343130303463383037653839653663356263366231656431
35366538643566623161393862653837623138363061383662663666353662393632656233666533
31633264336639663839383234316165336138343363366137323234656266613337626536333562
616363653634653034653834613836386663
```
видим, что весть файл зашифровался.
На всякий случай, например, хочу посмотреть его содержимое без расшифровки на фс.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-vault view ./group_vars/el/examp.yml
Vault password:
---
  some_fact: "el"
  some_subfact: "default fact"
```
Вместо того, чтобы также зашифровать весь файл параметров для группы `deb` для разнообразия предлагаю зашифровать только один параметр из него и руками вставим его в файл вместо значения параметра.

Было так:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat ./group_vars/deb/examp.yml
---
  some_fact: "deb"
  some_subfact: "default fact"
```
Шифруем значение параметра то есть `deb` просто как строку:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-vault encrypt_string
New Vault password:
Confirm New Vault password:
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
deb
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          31323231323332643565386139663564313132646132363630663933303831626265366234333637
          3836663339663061326630363038633835373036613132660a643762356332316235656134393465
          34346331396630326335343361306434623262626334343938633733306230323031343233363132
          3032346435313630300a636439613931346364336537336636306330623332633635363730643966
          6135
Encryption successful
```
Скопировали этот зашифрованный текст и вставили вместо значения параметра в файл. Получилось так:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat ./group_vars/deb/examp.yml
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          31323231323332643565386139663564313132646132363630663933303831626265366234333637
          3836663339663061326630363038633835373036613132660a643762356332316235656134393465
          34346331396630326335343361306434623262626334343938633733306230323031343233363132
          3032346435313630300a636439613931346364336537336636306330623332633635363730643966
          6135
  some_subfact: "default fact"
```
Итак у нас зашифровал один файл целеком, а во втором только занчение одного параметра. Если попробовать как обычно запустить плейбук, ансибл сообщает, что у нас что-то зашифровано:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] ************************************************************************************************************************************************************************
ERROR! Attempting to decrypt but no vault secrets found
```
9. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

Теперь пробуем запустить плейбук, указав ключ для запроса пароля расшифровки.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password:

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
10. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

Выводим весь список имеющихся плагинов для подключений:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ ansible-doc -t connection -l
ansible.netcommon.httpapi      Use httpapi to run command on network appliances
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection
ansible.netcommon.napalm       Provides persistent connection using NAPALM
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol
ansible.netcommon.network_cli  Use network_cli to run command on network appliances
ansible.netcommon.persistent   Use a persistent unix socket for connection
community.aws.aws_ssm          execute via AWS Systems Manager
community.docker.docker        Run tasks in docker containers
community.docker.docker_api    Run tasks in docker containers
community.general.chroot       Interact with local chroot
community.general.docker       Run tasks in docker containers
community.general.funcd        Use funcd to connect to target
community.general.iocage       Run tasks in iocage jails
community.general.jail         Run tasks in jails
community.general.lxc          Run tasks in lxc containers via lxc python library
community.general.lxd          Run tasks in lxc containers via lxc CLI
community.general.oc           Execute tasks in pods running on OpenShift
community.general.qubes        Interact with an existing QubesOS AppVM
community.general.saltstack    Allow ansible to piggyback on salt minions
community.general.zone         Run tasks in a zone instance
community.kubernetes.kubectl   Execute tasks in pods running on Kubernetes
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines
community.okd.oc               Execute tasks in pods running on OpenShift
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools
containers.podman.buildah      Interact with an existing buildah container
containers.podman.podman       Interact with an existing podman container
local                          execute on controller
paramiko_ssh                   Run tasks via python ssh (paramiko)
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol
ssh                            connect via ssh client binary
winrm                          Run tasks over Microsoft's WinRM
```
Так как `control node` это у нас тот хост, на котором собственно и запускается ansible, то есть отностительно самого ansible это получается `localhost`, для такого полключения используется плагин `local`.

11. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

В файл инвентори добавил localhost:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat inventory/prod.yml
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```
При попытке запустить плейбук с таким инвентори получаем проблему:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
[sudo] password for user1:
Vault password:

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"msg": "The task includes an option with an undefined variable. The error was: 'some_subfact' is undefined\n\nThe error appears to be in '/home/user1/dz_8.1_ansible/playbook/site.yml': line 8, column 9, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n          msg: \"{{ ansible_distribution }}\"\n      - name: Print fact\n        ^ here\n"}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Понимаем, что у нас не определены параметры в `group_vars` для группы хостов `local`. создаём папку и файл.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ mkdir group_vars/local
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cd group_vars/local/
user1@devopserubuntu:~/dz_8.1_ansible/playbook/group_vars/local$ touch examp.yml

пропиисываем в него всё что надо

user1@devopserubuntu:~/dz_8.1_ansible/playbook/group_vars/local$ cat examp.yml
---
  some_fact: "loc"
  some_subfact: "default fact"
```
12. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ sudo ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
[sudo] password for user1:
Vault password:

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]
ok: [centos7]
ok: [ubuntu]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "loc default fact"
}
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Как мы видим всё честно отработало. По локалхосту вывелось правильное значение факта.

13. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
Я сюда тоже скопирую эти вопросы и ответы:
### Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?

Вот он:
```bash
user1@devopserubuntu:~/dz_8.1_ansible/playbook$ cat group_vars/all/examp.yml
---
  some_fact: all default fact
```
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

`ansible-playbook site.yml -i inventory/test.yml`
3. Какой командой можно зашифровать файл?

`ansible-vault encrypt имя_файла`

4. Какой командой можно расшифровать файл?

`ansible-vault decrypt имя_файла`

5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?

Да, для этого используется опция `view` вот так:

`ansible-vault view имя_файла`

6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?

Есть два варианта. 
- Можно указать ключ для запроса пароля расшифровки в интерактивном режиме:

`ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass`

- Можно указать ключ для считывания пароля расшифровки из файла:

`ansible-playbook site.yml -i inventory/prod.yml --vault-password-file имя_файла_с_паролем`

7. Как называется модуль подключения к host на windows?

`psrp`

8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh

`ansible-doc -t connection ssh`

9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?

`remote_user`

---
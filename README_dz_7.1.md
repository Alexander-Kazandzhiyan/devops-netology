# Домашнее задание к занятию "7.1. Инфраструктура как код"

## Задача 1. Выбор инструментов. 
 
### Легенда
 
Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо 
будет уже сегодня. 
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам.
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.

Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.  
   
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры.
На данный момент в вашей компании уже используются следующие инструменты: 
- остатки Сloud Formation, 
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform, 
- разработчики привыкли использовать Docker, 
- уже есть большая база Kubernetes конфигураций, 
- для автоматизации процессов используется Teamcity, 
- также есть совсем немного Ansible скриптов, 
- и ряд bash скриптов для упрощения рутинных задач.  

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:

1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?
1. Будет ли центральный сервер для управления инфраструктурой?
1. Будут ли агенты на серверах?
1. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 
 
В связи с тем, что проект стартует уже сегодня, в рамках совещания надо будет определиться со всеми этими вопросами.

### В результате задачи необходимо

1. Ответить на четыре вопроса представленных в разделе "Легенда". 
1. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта? 
1. Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта? 

Если для ответа на эти вопросы недостаточно информации, то напишите какие моменты уточните на совещании.

### Ответ 

п.1. Отвечаем на вопросы из легенды:
1. Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый?

Инфраструктура должна быть не изменяемой. Это необходимое условие использования шаблонизации серверов. Это означает, что сервера разворачиваются из шаблонов и затем в них не вносится никаких изменений. Если требуется изменение конфигурации, то создаётся новый шаблон и из него разворачивается сервер заново.

2. Будет ли центральный сервер для управления инфраструктурой?
3. Будут ли агенты на серверах?

На вопросы 2 и 3 ответы должны быть одинаковыми так как агенты на серверах требуются при использовании инфраструктуры развёртывания с использованием центрального сервера. А вот использовать ли центральный сервер - это вопрос на который пока сложно дать однозначный ответ. Возможно, сстоит уточнить на совещании, планируется ли использоваться инфраструктура популярных обласных провайдеров или бы будем создавать всё с нуля у себя в ДЦ. Если первое, то центральный сервер, пожалуй не нужен ибо управлять разёртыванием мы будем обращаясь к API провайдера. Этот API и будет выполнять роль центрального сервера, на который мы будем воздействовать через средства нициализации ресурсов, такие, как `Terraform`. В случае-же построения инфраструктуры на базе собственных серверов в ДЦ, возможно нам придётся использовать и центральный сервер и агенты на серверах.
То, что в легенде указано, что недавно стали активно использовать `Teraform`, говорит скорее о том, что своих серверов скорее всего нет и компания пользуется облачными решениями от каких-то провайдеров.

4. Будут ли использованы средства для управления конфигурацией или инициализации ресурсов? 

Тут снова тот же вопрос. Но раз мы пришли к выводу, что скорее всего парка физических серверов у нашей компании нет, значит всё-таки будем использовать не средства управления конфигурациями (типа Chef, Puppet, Ansible и SaltStack), а средства управления ресурсами такие, как CloudFormation, Terraform и OpenStack Heat.  

п.2. Какие инструменты из уже используемых вы хотели бы использовать для нового проекта? 

Думаю, что стоит оставить для дальнейшего использования и развития следующие инструменты:
- некоторые образы Packer, хотя скорее всего придётся создавать новые,
- Terraform, 
- Docker и Kubernetes. Пока не имею достаточных знаний по Kubernetes, чтобы однозначно сделать вывод нужно ли для чего-то оставлять Docker или всё может взять на себя Kuber. Наверное оставил бы оба инструмента раз разработчики привыкли к Docker. 
- Teamcity ещё не изучен, не знаю, чем он лучше тех же bash скриптов... 
- Ansible наверняка пригодится
- Ну, а bash всегда для чего-то пригождается. Мы без него никуда...  

п.3.  Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта? 
Пока затрудняюсь с ответом, ибо кажется, что и этого всего вполне достаточно.

## Задача 2. Установка терраформ. 

Официальный сайт: https://www.terraform.io/

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
В виде результата этой задачи приложите вывод команды `terraform --version`.

### Ответ

Для этого задания я взял описание ранее выполненной установки. 
Устанавливаем `Terraform`:
```bash
user1@devopserubuntu:~$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
[sudo] password for user1:
Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
OK

user1@devopserubuntu:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Repository: 'deb [arch=amd64] https://apt.releases.hashicorp.com impish main'
Description:
Archive for codename: impish components: main
More info: https://apt.releases.hashicorp.com
Adding repository.
Press [ENTER] to continue or Ctrl-c to cancel.
Found existing deb entry in /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-impish.list
Adding deb entry to /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-impish.list
Found existing deb-src entry in /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-impish.list
Adding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-impish.list
Hit:1 https://apt.releases.hashicorp.com impish InRelease
Hit:2 http://de.archive.ubuntu.com/ubuntu impish InRelease
Hit:3 https://download.docker.com/linux/ubuntu impish InRelease
Get:4 http://de.archive.ubuntu.com/ubuntu impish-updates InRelease [110 kB]
Get:5 http://de.archive.ubuntu.com/ubuntu impish-backports InRelease [101 kB]
Get:6 http://de.archive.ubuntu.com/ubuntu impish-security InRelease [110 kB]
Fetched 321 kB in 1s (284 kB/s)
Reading package lists... Done

user1@devopserubuntu:~$ sudo apt-get update && sudo apt-get install terraform
Hit:1 http://de.archive.ubuntu.com/ubuntu impish InRelease
Hit:2 https://download.docker.com/linux/ubuntu impish InRelease
Hit:3 https://apt.releases.hashicorp.com impish InRelease
Hit:4 http://de.archive.ubuntu.com/ubuntu impish-updates InRelease
Hit:5 http://de.archive.ubuntu.com/ubuntu impish-backports InRelease
Hit:6 http://de.archive.ubuntu.com/ubuntu impish-security InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  terraform
0 upgraded, 1 newly installed, 0 to remove and 30 not upgraded.
Need to get 18.7 MB of archives.
After this operation, 62.0 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com impish/main amd64 terraform amd64 1.1.4 [18.7 MB]
Fetched 18.7 MB in 4s (5,171 kB/s)
Selecting previously unselected package terraform.
(Reading database ... 139141 files and directories currently installed.)
Preparing to unpack .../terraform_1.1.4_amd64.deb ...
Unpacking terraform (1.1.4) ...
Setting up terraform (1.1.4) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.
No services need to be restarted.
No containers need to be restarted.
No user sessions are running outdated binaries.
```
Это всё я делал ранее на курсе. 

А теперь сейчас проверим версию:
```bash
user1@devopserubuntu:~$ sudo terraform --version
Terraform v1.1.4
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.1.7. You can update by downloading from https://www.terraform.io/downloads.html
```
Видим, что у нас стоит версия `1.1.4`, но нас уведомляют, что она устарела и есть новее, `1.1.7`.

## Задача 3. Поддержка легаси кода. 

В какой-то момент вы обновили терраформ до новой версии, например с 0.12 до 0.13. 
А код одного из проектов настолько устарел, что не может работать с версией 0.13. 
В связи с этим необходимо сделать так, чтобы вы могли одновременно использовать последнюю версию терраформа установленную при помощи
штатного менеджера пакетов и устаревшую версию 0.12. 

В виде результата этой задачи приложите вывод `--version` двух версий терраформа доступных на вашем компьютере 
или виртуальной машине.

### Ответ
Итак, как мы уже увидели на нашем сервере стоит устаревшая версия. Будем пробовать установить новую рядом со старой.

Для начала попробуем выяснить, гдележит сам исполняемый файл `terraform` и нет ли у него каких-то специальных библиотек.
Для этого выполним команду. Она нам покажет много чего, но мы ищем то, что нас интересует.
```bash
user1@devopserubuntu:~$ sudo find / | grep terraform
.......
/usr/bin/terraform
.......
```
Итак, похоже никаких папок с библиотеками нет и `Terraform` представляет собой лишь исполняемый файл.

Прежде чем устанавливать новую версию, мы переименуем старый файл.
```bash
user1@devopserubuntu:~$ sudo mv /usr/bin/terraform /usr/bin/terraform_1.1.4

user1@devopserubuntu:~$ sudo ls -la /usr/bin/terraform*
-rwxr-xr-x 1 root root 61960192 Jan 19 18:30 /usr/bin/terraform_1.1.4
```
Теперь установим новую версию:
```bash
user1@devopserubuntu:~$ sudo apt-get update && sudo apt-get install terraform
Hit:1 http://de.archive.ubuntu.com/ubuntu impish InRelease
Get:2 http://de.archive.ubuntu.com/ubuntu impish-updates InRelease [115 kB]
Hit:3 https://download.docker.com/linux/ubuntu impish InRelease
Get:4 https://apt.releases.hashicorp.com impish InRelease [10.3 kB]
Get:5 http://de.archive.ubuntu.com/ubuntu impish-backports InRelease [101 kB]
Get:6 http://de.archive.ubuntu.com/ubuntu impish-security InRelease [110 kB]
Get:7 http://de.archive.ubuntu.com/ubuntu impish-updates/main amd64 Packages [336 kB]
Get:8 https://apt.releases.hashicorp.com impish/main amd64 Packages [50.7 kB]
Fetched 723 kB in 1s (659 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be upgraded:
  terraform
1 upgraded, 0 newly installed, 0 to remove and 37 not upgraded.
Need to get 18.8 MB of archives.
After this operation, 1,303 kB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com impish/main amd64 terraform amd64 1.1.7 [18.8 MB]
Fetched 18.8 MB in 6s (3,335 kB/s)
(Reading database ... 237377 files and directories currently installed.)
Preparing to unpack .../terraform_1.1.7_amd64.deb ...
Unpacking terraform (1.1.7) over (1.1.4) ...
Setting up terraform (1.1.7) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Restarting services...
Service restarts being deferred:
 systemctl restart containerd.service
 systemctl restart cron.service
 /etc/needrestart/restart.d/dbus.service
 systemctl restart docker.service
 systemctl restart getty@tty1.service
 systemctl restart irqbalance.service
 systemctl restart multipathd.service
 systemctl restart networkd-dispatcher.service
 systemctl restart open-vm-tools.service
 systemctl restart packagekit.service
 systemctl restart polkit.service
 systemctl restart rsyslog.service
 systemctl restart ssh.service
 systemctl restart systemd-journald.service
 systemctl restart systemd-logind.service
 systemctl restart systemd-networkd.service
 systemctl restart systemd-resolved.service
 systemctl restart systemd-udevd.service
 systemctl restart udisks2.service
 systemctl restart unattended-upgrades.service
 systemctl restart upower.service
 systemctl restart user@1000.service
 systemctl restart vgauth.service

No containers need to be restarted.

No user sessions are running outdated binaries.
```
Проверим, установилась ли новая версия и осталась ли старая:
```bash
user1@devopserubuntu:~$ sudo terraform --version
Terraform v1.1.7
on linux_amd64

user1@devopserubuntu:~$ sudo terraform_1.1.4 --version
Terraform v1.1.4
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.1.7. You can update by downloading from https://www.terraform.io/downloads.html
```
Обе версии присутствуют.

---
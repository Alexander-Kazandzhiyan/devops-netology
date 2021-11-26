# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

Ответ:
Делал на Alma Linux.
Скачал и распаковал node_exporter в /root/node_exporter-1.3.0.linux-amd64/
Сделал пробный запуск. Запускается. Порт 9100 слушает.
Для его автозапуска создаём Unit-файл:

```bash
[root@DevOpser system]# systemctl edit --full --force node_exporter.service
```
команда открывает редактор для создания файла. ЗАполняем:

```
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=root
Group=root
Type=simple
ExecStart=/root/node_exporter-1.3.0.linux-amd64/node_exporter
[Install]
WantedBy=multi-user.target
```
При сохранении создалса файл:
``/etc/systemd/system/node_exporter.service``

Пробуем узнать текущий статус, затем запустить и затем посмотреть текущий статус и проверяем, что процесс запущен и слушает порт 9100, и завершить:
```bash
[root@DevOpser system]#  systemctl status node_exporter
● node_exporter.service - Node Exporter
   Loaded: loaded (/etc/systemd/system/node_exporter.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
[root@DevOpser system]#  systemctl start node_exporter
[root@DevOpser system]#  systemctl status node_exporter
● node_exporter.service - Node Exporter
   Loaded: loaded (/etc/systemd/system/node_exporter.service; disabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-11-26 11:57:04 MSK; 12s ago
 Main PID: 1666 (node_exporter)
    Tasks: 3 (limit: 11396)
   Memory: 20.8M
   CGroup: /system.slice/node_exporter.service
           └─1666 /root/node_exporter-1.3.0.linux-amd64/node_exporter

Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.535Z caller=node_exporter.go:115 level=info collector=thermal_zone
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.535Z caller=node_exporter.go:115 level=info collector=time
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.535Z caller=node_exporter.go:115 level=info collector=timex
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.535Z caller=node_exporter.go:115 level=info collector=udp_queues
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.535Z caller=node_exporter.go:115 level=info collector=uname
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.535Z caller=node_exporter.go:115 level=info collector=vmstat
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.535Z caller=node_exporter.go:115 level=info collector=xfs
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.536Z caller=node_exporter.go:115 level=info collector=zfs
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.536Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Nov 26 11:57:04 DevOpser node_exporter[1666]: ts=2021-11-26T08:57:04.536Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false

[root@DevOpser system]# netstat -apn | grep 9100
tcp6       0      0 :::9100                 :::*                    LISTEN      1666/node_exporter  

[root@DevOpser ~]# systemctl stop node_exporter.service  
[root@DevOpser ~]# systemctl status node_exporter.service
● node_exporter.service - Node Exporter
   Loaded: loaded (/etc/systemd/system/node_exporter.service; disabled; vendor preset: disabled)
   Active: inactive (dead) since Fri 2021-11-26 12:20:01 MSK; 8s ago
  Process: 1144 ExecStart=/root/node_exporter-1.3.0.linux-amd64/node_exporter (code=killed, signal=TERM)
 Main PID: 1144 (code=killed, signal=TERM)

Nov 26 12:15:12 DevOpser node_exporter[1144]: ts=2021-11-26T09:15:12.862Z caller=node_exporter.go:115 level=info collector=udp_queues
Nov 26 12:15:12 DevOpser node_exporter[1144]: ts=2021-11-26T09:15:12.862Z caller=node_exporter.go:115 level=info collector=uname
Nov 26 12:15:12 DevOpser node_exporter[1144]: ts=2021-11-26T09:15:12.862Z caller=node_exporter.go:115 level=info collector=vmstat
Nov 26 12:15:12 DevOpser node_exporter[1144]: ts=2021-11-26T09:15:12.862Z caller=node_exporter.go:115 level=info collector=xfs
Nov 26 12:15:12 DevOpser node_exporter[1144]: ts=2021-11-26T09:15:12.862Z caller=node_exporter.go:115 level=info collector=zfs
Nov 26 12:15:12 DevOpser node_exporter[1144]: ts=2021-11-26T09:15:12.862Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Nov 26 12:15:12 DevOpser node_exporter[1144]: ts=2021-11-26T09:15:12.865Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
Nov 26 12:20:01 DevOpser systemd[1]: Stopping Node Exporter...
Nov 26 12:20:01 DevOpser systemd[1]: node_exporter.service: Succeeded.
Nov 26 12:20:01 DevOpser systemd[1]: Stopped Node Exporter.
```
Добавляем службу в автозапуск:
```bash
[root@DevOpser ~]# systemctl enable node_exporter.service
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.

[root@DevOpser ~]# systemctl status node_exporter.service
● node_exporter.service - Node Exporter
   Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-11-26 12:08:40 MSK; 5min ago
 Main PID: 1538 (node_exporter)
    Tasks: 3 (limit: 11396)
   Memory: 28.6M
   CGroup: /system.slice/node_exporter.service
           └─1538 /root/node_exporter-1.3.0.linux-amd64/node_exporter

Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=thermal_zone
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=time
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=timex
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=udp_queues
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=uname
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=vmstat
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=xfs
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:115 level=info collector=zfs
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.978Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Nov 26 12:08:40 DevOpser node_exporter[1538]: ts=2021-11-26T09:08:40.979Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
```
Видим, что появился признак автозагрузки - enabled. Теперь перезагружаемся и проверяем. - Запускается.

Теперь добавляем файл с опциями. Создаём файл:
```bash
[root@DevOpser ~]# cd node_exporter-1.3.0.linux-amd64
[root@DevOpser node_exporter-1.3.0.linux-amd64]# ls
LICENSE  node_exporter  NOTICE
[root@DevOpser node_exporter-1.3.0.linux-amd64]# echo IPv4_if=10.20.8.77:9100 > node_exporter.options
[root@DevOpser node_exporter-1.3.0.linux-amd64]# 
[root@DevOpser node_exporter-1.3.0.linux-amd64]# cat node_exporter.options 
IPv4_if=10.20.8.77:9100
[root@DevOpser node_exporter-1.3.0.linux-amd64]# 
```
Теперь редактируем Unit файл, добавляя файл опций и используя переменную из него для задания интерфейса прослушивания для службы:

```buildoutcfg
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=root
Group=root
Type=simple
EnvironmentFile=/root/node_exporter-1.3.0.linux-amd64/node_exporter.options
ExecStart=/root/node_exporter-1.3.0.linux-amd64/node_exporter --web.listen-address=${IPv4_if}
[Install]
WantedBy=multi-user.target
[root@DevOpser ~]# 
```
Перезапускам systemd: `systemctl daemon-reload`
Запускаем службу и смотрим статус:
```bash
[root@DevOpser ~]# systemctl start node_exporter.service 
[root@DevOpser ~]# systemctl status node_exporter.service
● node_exporter.service - Node Exporter
   Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2021-11-26 13:03:20 MSK; 3s ago
 Main PID: 1709 (node_exporter)
    Tasks: 3 (limit: 11396)
   Memory: 4.7M
   CGroup: /system.slice/node_exporter.service
           └─1709 /root/node_exporter-1.3.0.linux-amd64/node_exporter --web.listen-address=10.20.8.77:9100

Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=thermal_zone
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=time
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=timex
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=udp_queues
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=uname
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=vmstat
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=xfs
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:115 level=info collector=zfs
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=node_exporter.go:199 level=info msg="Listening on" address=10.20.8.77:9100
Nov 26 13:03:20 DevOpser node_exporter[1709]: ts=2021-11-26T10:03:20.434Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
[root@DevOpser ~]# 
```
видим, что слушает он теперь на указанном интерфейсе `10.20.8.77:9100`.

2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

Ответ: Открыл в браузере http://10.20.8.77:9100/metrics и ознакомился. Для "лёгкого" мониторинга сервера можно было бы мониторить следующие параметры:

тут перечислены параметры, которые я бы собирал:

``` bash
//# HELP node_load1 1m load average.
//# TYPE node_load1 gauge
node_load1 0
//# HELP node_load15 15m load average.
//# TYPE node_load15 gauge
node_load15 0
//# HELP node_load5 5m load average.
//# TYPE node_load5 gauge
node_load5 0

// HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
// TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 3468.04
node_cpu_seconds_total{cpu="0",mode="iowait"} 0.5
node_cpu_seconds_total{cpu="0",mode="irq"} 1.83
node_cpu_seconds_total{cpu="0",mode="nice"} 0.19
node_cpu_seconds_total{cpu="0",mode="softirq"} 0.99
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 4.52
node_cpu_seconds_total{cpu="0",mode="user"} 9.28


// HELP node_memory_MemTotal_bytes Memory information field MemTotal_bytes.
// TYPE node_memory_MemTotal_bytes gauge
node_memory_MemTotal_bytes 1.904898048e+09

// HELP node_memory_MemFree_bytes Memory information field MemFree_bytes.
// TYPE node_memory_MemFree_bytes gauge
node_memory_MemFree_bytes 1.464111104e+09


// HELP node_filesystem_size_bytes Filesystem size in bytes.
// TYPE node_filesystem_size_bytes gauge
node_filesystem_size_bytes{device="/dev/mapper/almalinux-root",fstype="xfs",mountpoint="/"} 1.7609785344e+10
node_filesystem_size_bytes{device="/dev/sda1",fstype="vfat",mountpoint="/boot/efi"} 6.27900416e+08
node_filesystem_size_bytes{device="/dev/sda2",fstype="xfs",mountpoint="/boot"} 1.063256064e+09
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run"} 9.52446976e+08
node_filesystem_size_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/user/0"} 1.90488576e+08

// HELP node_filesystem_avail_bytes Filesystem space available to non-root users in bytes.
// TYPE node_filesystem_avail_bytes gauge
node_filesystem_avail_bytes{device="/dev/mapper/almalinux-root",fstype="xfs",mountpoint="/"} 1.4840168448e+10
node_filesystem_avail_bytes{device="/dev/sda1",fstype="vfat",mountpoint="/boot/efi"} 6.21846528e+08
node_filesystem_avail_bytes{device="/dev/sda2",fstype="xfs",mountpoint="/boot"} 8.16730112e+08
node_filesystem_avail_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run"} 9.43480832e+08
node_filesystem_avail_bytes{device="tmpfs",fstype="tmpfs",mountpoint="/run/user/0"} 1.90488576e+08

node_disk_reads_completed_total
// HELP node_disk_reads_completed_total The total number of reads completed successfully.
// TYPE node_disk_reads_completed_total counter
node_disk_reads_completed_total{device="dm-0"} 4706
node_disk_reads_completed_total{device="dm-1"} 97
node_disk_reads_completed_total{device="sda"} 6550
node_disk_reads_completed_total{device="sr0"} 9

// HELP node_disk_writes_completed_total The total number of writes completed successfully.
// TYPE node_disk_writes_completed_total counter
node_disk_writes_completed_total{device="dm-0"} 656
node_disk_writes_completed_total{device="dm-1"} 0
node_disk_writes_completed_total{device="sda"} 579
node_disk_writes_completed_total{device="sr0"} 0

// HELP node_network_up Value is 1 if operstate is 'up', 0 otherwise.
// TYPE node_network_up gauge
node_network_up{device="ens192"} 1
node_network_up{device="lo"} 0

// HELP node_network_transmit_packets_total Network device statistic transmit_packets.
// TYPE node_network_transmit_packets_total counter
node_network_transmit_packets_total{device="ens192"} 1574
node_network_transmit_packets_total{device="lo"} 0

// HELP node_network_transmit_bytes_total Network device statistic transmit_bytes.
// TYPE node_network_transmit_bytes_total counter
node_network_transmit_bytes_total{device="ens192"} 255207
node_network_transmit_bytes_total{device="lo"} 0

// HELP node_network_receive_packets_total Network device statistic receive_packets.
// TYPE node_network_receive_packets_total counter
node_network_receive_packets_total{device="ens192"} 4193
node_network_receive_packets_total{device="lo"} 0

// HELP node_network_receive_bytes_total Network device statistic receive_bytes.
// TYPE node_network_receive_bytes_total counter
node_network_receive_bytes_total{device="ens192"} 336282
node_network_receive_bytes_total{device="lo"} 0

```

3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

Ответ:
Установил. Работает. Веб-интерфейс открылся - красиво :). Ознакомился. В доказательство привожу последнюю строку из веб-интерфейса:
Released under GPL v3 or later. Netdata uses third party tools.

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Ответ: Конечно можно это понять. Например внутри VBox ОС Ubunta показывает:
```bash
vagrant@vagrant:~$ dmesg | grep virt
[    0.010423] CPU MTRRs all blank - virtualized system.
[    1.057557] Booting paravirtualized kernel on KVM
[    6.718532] systemd[1]: Detected virtualization oracle.
vagrant@vagrant:~$
```
первая же строка выдаёт, что это ВМ.

А Alma Linux на VMware ESXi:

```bash
[root@DevOpser ~]# dmesg | grep virt
[    0.000000] Booting paravirtualized kernel on VMware hypervisor
[    0.827993] systemd[1]: Detected virtualization vmware.
[    2.175694] VMware vmxnet3 virtual NIC driver - version 1.5.0.0-k-NAPI
[    4.620666] systemd[1]: Detected virtualization vmware.
[ 4093.810257] systemd[1]: Detected virtualization vmware.
```
Без специальных уловок и ухищрений виртуализацию не возможно скрыть от современной ОС.

5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

Ответ: Параметр fs.nr_open - это ограничение на максимальное кол-во открытых файлов в системе. По-умолчанию оно равно:
```bash
[root@DevOpser ~]# sysctl fs.nr_open          
fs.nr_open = 1048576
```
Но при этом в системе не возможно открыть больше чем 1024 файла из-за ограничения на максимальное количество дескрипторов открытых файлов (the maximum number of open file descriptors):
```bash
[root@DevOpser ~]# ulimit -n
1024
```

7. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

Ответ: Запускаем в отдельном терминале sleep 1h в отдельном неймспейсе:
```bash
unshare -f --pid --mount-proc sleep 1h
```
теперь в другом терминале смотрим какие есть неймспейсы и есть ли наш sleep

```bash
[root@DevOpser ~]# lsns
        NS TYPE   NPROCS   PID USER    COMMAND
4026531835 cgroup    209     1 root    /usr/lib/systemd/systemd --system --deserialize 26
4026531836 pid       208     1 root    /usr/lib/systemd/systemd --system --deserialize 26
4026531837 user      209     1 root    /usr/lib/systemd/systemd --system --deserialize 26
4026531838 uts       209     1 root    /usr/lib/systemd/systemd --system --deserialize 26
4026531839 ipc       209     1 root    /usr/lib/systemd/systemd --system --deserialize 26
4026531840 mnt       199     1 root    /usr/lib/systemd/systemd --system --deserialize 26
4026531860 mnt         1    16 root    kdevtmpfs
4026531992 net       209     1 root    /usr/lib/systemd/systemd --system --deserialize 26
4026532474 mnt         1 18115 root    /usr/lib/systemd/systemd-udevd
4026532508 mnt         4 56740 netdata /usr/sbin/netdata -P /var/run/netdata/netdata.pid -D
4026532509 mnt         2 57547 root    unshare -f --pid --mount-proc sleep 1h
4026532510 pid         1 57548 root    sleep 1h
4026532538 mnt         1   907 root    /sbin/auditd
4026532539 mnt         1   963 root    /usr/sbin/NetworkManager --no-daemon

[root@DevOpser ~]# ps aux | grep sleep
root       57547  0.0  0.0 217064   872 pts/2    S+   16:05   0:00 unshare -f --pid --mount-proc sleep 1h
root       57548  0.0  0.0 217072   880 pts/2    S+   16:05   0:00 sleep 1h
root       57908  0.0  0.0 221928  1124 pts/1    S+   16:37   0:00 grep --color=auto sleep
```
Подключаемся к неймспейсу с нашим sleep и смотрим какие процессы там есть:
```bash
[root@DevOpser ~]# nsenter --target 57548 --pid --mount      
[root@DevOpser /]# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0 217072   880 pts/2    S+   16:05   0:00 sleep 1h
root           3  0.0  0.2 236024  4180 pts/0    S    16:31   0:00 -bash
root          26  0.0  0.2 268528  4100 pts/0    R+   16:32   0:00 ps aux
```
Видим, что в этом неймспейсе наш процесс sleep имеет уже PID=1.

8. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Ответ:
`:(){ :|:& };:` - В народе это называется fork-bomb. Это объявление функции, которая запускает саму себя безконечное кол-во раз, плодя процессы bash.
После запуска она какое-то время работает потом всё прекращается. В dmesg видно, что сработал механизм:
```bash
[664336.519057] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-136.scope
```
Process Number Controller - это механизм запрещающий создавать новые процессы путём fork и clone после превышения кол-ва процессов в одной группе.
Этот лимит равен:
```bash
vagrant@vagrant:~$ cat /proc/sys/kernel/pid_max
4194304
```

Уменьшаем лимит:
```bash
vagrant@vagrant:~$ echo 50000 | sudo tee /proc/sys/kernel/pid_max
500000
```
Теперь защита сработала быстрее.

 ---

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Название файла Google Docs должно содержать номер лекции и фамилию студента. Пример названия: "1.1. Введение в DevOps — Сусанна Алиева".

Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. Чтобы это проверить, откройте ссылку в браузере в режиме инкогнито.

[Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)

[Как запустить chrome в режиме инкогнито ](https://support.google.com/chrome/answer/95464?co=GENIE.Platform%3DDesktop&hl=ru)

[Как запустить  Safari в режиме инкогнито ](https://support.apple.com/ru-ru/guide/safari/ibrw1069/mac)

Любые вопросы по решению задач задавайте в чате Slack.

---

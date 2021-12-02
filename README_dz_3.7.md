# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

Ответ: 
Alma Linux
С помощью команд ip смотрим список физ. интерфейсов и адреса на них. Для сравнения получаем ту же информацию одной командой ifconfig (хоть и считается, что она устарела)
```bash
[root@DevOpser ~]# ip -c -br link   
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
ens192           UP             00:50:56:88:a3:6d <BROADCAST,MULTICAST,UP,LOWER_UP> 

[root@DevOpser ~]# ip -c -br address
lo               UNKNOWN        127.0.0.1/8 ::1/128 
ens192           UP             10.20.8.77/24 

[root@DevOpser ~]# ifconfig         
ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.20.8.77  netmask 255.255.255.0  broadcast 10.20.8.255
        ether 00:50:56:88:a3:6d  txqueuelen 1000  (Ethernet)
        RX packets 452  bytes 44502 (43.4 KiB)
        RX errors 0  dropped 10  overruns 0  frame 0
        TX packets 96  bytes 20552 (20.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 1744  bytes 90832 (88.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1744  bytes 90832 (88.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Windows Server 2008
```bash
PS E:\vagrant> ipconfig.exe -all

Настройка протокола IP для Windows

   Имя компьютера  . . . . . . . . . : vm10807
   Основной DNS-суффикс  . . . . . . :
   Тип узла. . . . . . . . . . . . . : Гибридный
   IP-маршрутизация включена . . . . : Нет
   WINS-прокси включен . . . . . . . : Нет

Ethernet adapter Подключение по локальной сети 3:

   DNS-суффикс подключения . . . . . :
   Описание. . . . . . . . . . . . . : Сетевое подключение Intel(R) PRO/1000 MT #2
   Физический адрес. . . . . . . . . : 00-50-56-88-AF-60
   DHCP включен. . . . . . . . . . . : Нет
   Автонастройка включена. . . . . . : Да
   IPv4-адрес. . . . . . . . . . . . : 10.20.8.7(Основной)
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . : 10.20.8.253
   DNS-серверы. . . . . . . . . . . : 8.8.8.8
   NetBios через TCP/IP. . . . . . . . : Включен

Ethernet adapter VirtualBox Host-Only Network:

   DNS-суффикс подключения . . . . . :
   Описание. . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter
   Физический адрес. . . . . . . . . : 0A-00-27-00-00-10
   DHCP включен. . . . . . . . . . . : Нет
   Автонастройка включена. . . . . . : Да
   Локальный IPv6-адрес канала . . . : fe80::688b:e76a:2d8b:c68d%16(Основной)
   IPv4-адрес. . . . . . . . . . . . : 10.0.2.222(Основной)
   Маска подсети . . . . . . . . . . : 255.255.255.0
   Основной шлюз. . . . . . . . . :
   IAID DHCPv6 . . . . . . . . . . . : 336199719
   DUID клиента DHCPv6 . . . . . . . : 00-01-00-01-19-47-44-F0-00-50-56-AF-00-1C
   DNS-серверы. . . . . . . . . . . : fec0:0:0:ffff::1%1
                                       fec0:0:0:ffff::2%1
                                       fec0:0:0:ffff::3%1
   NetBios через TCP/IP. . . . . . . . : Включен
...
```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

Ответ: Для этого используется протокол LLDP. Link Layer Discovery Protocol (LLDP) — протокол канального уровня, позволяющий сетевому оборудованию оповещать оборудование, работающее в локальной сети, о своём существовании и передавать ему свои характеристики, а также получать от него аналогичные сведения.
Устанавливаем пакет для линукса:

`[root@DevOpser ~]# yum install lldpd`

Запускаем службу и пробуем посмотреть соседей и др информацию:

```bash
[root@DevOpser ~]# systemctl enable lldpd && systemctl start lldpd
Created symlink /etc/systemd/system/multi-user.target.wants/lldpd.service → /usr/lib/systemd/system/lldpd.service.
[root@DevOpser ~]# lldpctl
-------------------------------------------------------------------------------
LLDP neighbors:
-------------------------------------------------------------------------------
```
К сожалению мы на ВМ и ничего увидеть не удаётся, хотя в сети ядра виртуализации имеются коммутаторы с LLDP.

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

Ответ: Для разделения на L2 используется технология VLAN. 
Будем смотреть на Alma Linux: 
Модуль vlan уже включен.

```bash
[root@DevOpser network-scripts]# lsmod | grep 8021q
8021q                  40960  0
garp                   16384  1 8021q
mrp                    20480  1 8021q
```

Этот линукс с интерфейсом типа ens192 значит работает через NetworkManager. Через него и будем делать:

Видим, что интерфейс пока один
```bash
[root@DevOpser network-scripts]# nmcli con show
NAME    UUID                                  TYPE      DEVICE 
ens192  68c92f0d-db08-4f84-abf3-f29af65f24d6  ethernet  ens192 
```

Добавляем сетевой интерфейс в vlan 500 на базе физического интерфейса ens192:
```bash
[root@DevOpser network-scripts]# nmcli con add type vlan con-name ens192.500 ifname VLAN500 id 500 dev ens192 ip4 55.55.55.55/24
Connection 'ens192.500' (4a6e5a7e-c7bf-45c3-8595-d019135bb3eb) successfully added.
```
Смотрим, что он добавился:
```bash
[root@DevOpser network-scripts]# nmcli con show
NAME        UUID                                  TYPE      DEVICE  
ens192      68c92f0d-db08-4f84-abf3-f29af65f24d6  ethernet  ens192  
ens192.500  4a6e5a7e-c7bf-45c3-8595-d019135bb3eb  vlan      VLAN500 
```
Перезапускаем Network Manager и Проверяем, что интерфейс присутствует разными способами:
```bash
[root@DevOpser network-scripts]# systemctl restart NetworkManager

[root@DevOpser network-scripts]# nmcli con show                  
NAME        UUID                                  TYPE      DEVICE  
ens192      68c92f0d-db08-4f84-abf3-f29af65f24d6  ethernet  ens192  
ens192.500  4a6e5a7e-c7bf-45c3-8595-d019135bb3eb  vlan      VLAN500 

[root@DevOpser network-scripts]# ifconfig
VLAN500: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 55.55.55.55  netmask 255.255.255.0  broadcast 55.55.55.255
        inet6 fe80::1f9e:a973:b362:2f57  prefixlen 64  scopeid 0x20<link>
        ether 00:50:56:88:a3:6d  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 23  bytes 1554 (1.5 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ens192: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.20.8.77  netmask 255.255.255.0  broadcast 10.20.8.255
        ether 00:50:56:88:a3:6d  txqueuelen 1000  (Ethernet)
        RX packets 2129  bytes 172608 (168.5 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 723  bytes 200566 (195.8 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 1760  bytes 91920 (89.7 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1760  bytes 91920 (89.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

[root@DevOpser network-scripts]# ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
ens192           UP             00:50:56:88:a3:6d <BROADCAST,MULTICAST,UP,LOWER_UP> 
VLAN500@ens192   UP             00:50:56:88:a3:6d <BROADCAST,MULTICAST,UP,LOWER_UP> 

[root@DevOpser network-scripts]# ip -c address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:50:56:88:a3:6d brd ff:ff:ff:ff:ff:ff
    inet 10.20.8.77/24 brd 10.20.8.255 scope global noprefixroute ens192
       valid_lft forever preferred_lft forever
3: VLAN500@ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:50:56:88:a3:6d brd ff:ff:ff:ff:ff:ff
    inet 55.55.55.55/24 brd 55.55.55.255 scope global noprefixroute VLAN500
       valid_lft forever preferred_lft forever
    inet6 fe80::1f9e:a973:b362:2f57/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
Ну и посмотрим, что нам за конфиг файл создал NM:

```bash
[root@DevOpser network-scripts]# cat /etc/sysconfig/network-scripts/ifcfg-ens192.500   
VLAN=yes
TYPE=Vlan
PHYSDEV=ens192
VLAN_ID=500
REORDER_HDR=yes
GVRP=no
MVRP=no
HWADDR=
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
IPADDR=55.55.55.55
PREFIX=24
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens192.500
UUID=4a6e5a7e-c7bf-45c3-8595-d019135bb3eb
DEVICE=VLAN500
ONBOOT=yes
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

Ответ: В Linux используется Bonding для объединения нескольких сетевых интерфейсов в один для целей увеличения пропускной способности и/или отказоустойчивости. Существует несколько режимов работы аггрегирования портов:
```
Режим	Тип	         Описание и достижение Fail Tolerance и Balancing
0	Round Robin         Пакеты последовательно отправляются/принимаются через каждый интерфейс один за другим.	Fail Tolerance -	Balancing +
mode balance-rr
1	Active Backup	    Активен один интерфейс, другой находится в standby. Если активный интерфейс выходит из строя или отключается, другой интерфейс становится активным.	Fail Tolerance +	Balancing -
mode active-backup
2	XOR [exclusive OR]  В этом режиме MAC-адрес вспомогательного интерфейса сопоставляется с MAC входящего запроса, и как только это соединение установлено, тот же интерфейс используется для отправки/получения для MAC-адреса назначения.	Fail Tolerance +	Balancing +
mode balance-xor
3	Broadcast           Происходит передача во все объединенные интерфейсы, тем самым обеспечивая отказоустойчивость. Рекомендуется только для использования MULTICAST трафика.	Fail Tolerance +	Balancing -
mode broadcast
4	Dynamic Link Aggregation        Динамическое объединение одинаковых портов. В данном режиме можно значительно увеличить пропускную способность входящего так и исходящего трафика. Для данного режима необходима поддержка и настройка коммутатора/коммутаторов.	Fail Tolerance +	Balancing +
mode 802.3ad
5	Transmit Load Balancing (TLB)	Адаптивная балансировки нагрузки трафика. Входящий трафик получается только активным интерфейсом, исходящий распределяется в зависимости от текущей загрузки канала каждого интерфейса. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.	Fail Tolerance +	Balancing +
mode balance-tlb
6	Adaptive Load Balancing (ALB)	Адаптивная балансировка нагрузки. Отличается более совершенным алгоритмом балансировки нагрузки чем Mode-5). Обеспечивается балансировку нагрузки как исходящего так и входящего трафика. Не требуется специальной поддержки и настройки коммутатора/коммутаторов.	Fail Tolerance +	Balancing +
mode balance-alb
```
Для попытки настроить бондинг, я добавил в ВМ ещё 2 "физических" сетевых адаптера. Смотрим текущую конфишурацию:

```bash
[root@DevOpser ~]# nmcli con show                                      
NAME                UUID                                  TYPE      DEVICE  
Wired connection 1  5a8974d5-d562-38bb-a8df-3689c1ab9697  ethernet  ens224  
Wired connection 2  2256774b-4f3f-3103-8740-d93833e1a838  ethernet  ens256  
ens192              68c92f0d-db08-4f84-abf3-f29af65f24d6  ethernet  ens192  
ens192.500          4a6e5a7e-c7bf-45c3-8595-d019135bb3eb  vlan      VLAN500 
[root@DevOpser ~]# 
```
Видим, что добавились ens224 и ens256 и как видно ниже без настроек адресов:
```bash
[root@DevOpser ~]# ip -c address                                       
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:50:56:88:a3:6d brd ff:ff:ff:ff:ff:ff
    inet 10.20.8.77/24 brd 10.20.8.255 scope global noprefixroute ens192
       valid_lft forever preferred_lft forever
3: ens224: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:50:56:88:e0:ee brd ff:ff:ff:ff:ff:ff
    inet6 fe80::4ad0:490b:7f61:39f3/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: ens256: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:50:56:88:7d:f0 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::ea9f:6276:3a82:938d/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: VLAN500@ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:50:56:88:a3:6d brd ff:ff:ff:ff:ff:ff
    inet 55.55.55.55/24 brd 55.55.55.255 scope global noprefixroute VLAN500
       valid_lft forever preferred_lft forever
    inet6 fe80::1f9e:a973:b362:2f57/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```
Даже файлов конфигов для этих интерфейсов нет пока.

Создаём Бондинг-интерфейс в режиме balance-xor :
```bash
[root@DevOpser network-scripts]# nmcli con add type bond con-name bond0 ifname bond0 mode balance-xor ip4 7.7.7.7/24             
Connection 'bond0' (7ec707f2-802a-4a3d-8f7d-54df21fcf185) successfully added.
[root@DevOpser network-scripts]# nmcli con show
NAME                UUID                                  TYPE      DEVICE  
ens192              68c92f0d-db08-4f84-abf3-f29af65f24d6  ethernet  ens192  
ens192.500          4a6e5a7e-c7bf-45c3-8595-d019135bb3eb  vlan      VLAN500 
bond0               7ec707f2-802a-4a3d-8f7d-54df21fcf185  bond      bond0   
Wired connection 1  5a8974d5-d562-38bb-a8df-3689c1ab9697  ethernet  --      
Wired connection 2  2256774b-4f3f-3103-8740-d93833e1a838  ethernet  --      
[root@DevOpser network-scripts]# 
```
Создался bond0. 
Добавим интерфейсы ens224 и ens256 в качестве вспомогательных.
```bash
[root@DevOpser network-scripts]# nmcli con add type bond-slave ifname ens224 master bond0   
Connection 'bond-slave-ens224' (e790b346-672f-4fc9-8008-ec080edb59bd) successfully added.
[root@DevOpser network-scripts]# nmcli con add type bond-slave ifname ens256 master bond0 
Connection 'bond-slave-ens256' (6bc7b88d-6bfa-4f77-80c6-3a3520315ff2) successfully added.
```
Команда nmcli con add type bond-slave автоматически создаёт необходимые файлы конфигурации интерфейса в директории /etc/sysconfig/network-scripts. Посмотрим:

```bash
[root@DevOpser network-scripts]# ls -la  /etc/sysconfig/network-scripts/
total 24
drwxr-xr-x. 2 root root  131 Dec  2 02:25 .
drwxr-xr-x. 5 root root 4096 Dec  2 00:36 ..
-rw-r--r--  1 root root  350 Dec  2 02:20 ifcfg-bond0
-rw-r--r--  1 root root  127 Dec  2 02:25 ifcfg-bond-slave-ens224
-rw-r--r--  1 root root  127 Dec  2 02:25 ifcfg-bond-slave-ens256
-rw-r--r--. 1 root root  268 Dec  2 00:13 ifcfg-ens192
-rw-r--r--  1 root root  388 Dec  2 01:25 ifcfg-ens192.500

[root@DevOpser network-scripts]# cat ifcfg-bond-slave-ens224
TYPE=Ethernet
NAME=bond-slave-ens224
UUID=e790b346-672f-4fc9-8008-ec080edb59bd
DEVICE=ens224
ONBOOT=yes
MASTER=bond0
SLAVE=yes

[root@DevOpser network-scripts]# cat ifcfg-bond-slave-ens256
TYPE=Ethernet
NAME=bond-slave-ens256
UUID=6bc7b88d-6bfa-4f77-80c6-3a3520315ff2
DEVICE=ens256
ONBOOT=yes
MASTER=bond0
SLAVE=yes
```
Ну и на конфиг самого интерфейса bond0 посмотрим:
```bash
[root@DevOpser network-scripts]# cat ifcfg-bond0
BONDING_OPTS=mode=balance-xor
TYPE=Bond
BONDING_MASTER=yes
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
IPADDR=7.7.7.7
PREFIX=24
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=bond0
UUID=7ec707f2-802a-4a3d-8f7d-54df21fcf185
DEVICE=bond0
ONBOOT=yes
```
Активируем bonding. Если они сами не активировались. 
Сначала поднимаем вспомогательные интерфейсы, а затем bond0:
```bash
[root@DevOpser network-scripts]# nmcli con up bond-slave-ens224
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/41)

[root@DevOpser network-scripts]# nmcli con up bond-slave-ens256                          
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/42)

[root@DevOpser network-scripts]# nmcli con up bond0
Connection successfully activated (master waiting for slaves) (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/43)
```
Проверяем, что бонд и его интерфейсы поднялись и что у bond0 присутствует нужный адрес:
```bash
[root@DevOpser network-scripts]# nmcli con show                
NAME                UUID                                  TYPE      DEVICE  
ens192              68c92f0d-db08-4f84-abf3-f29af65f24d6  ethernet  ens192  
bond0               7ec707f2-802a-4a3d-8f7d-54df21fcf185  bond      bond0   
ens192.500          4a6e5a7e-c7bf-45c3-8595-d019135bb3eb  vlan      VLAN500 
bond-slave-ens224   e790b346-672f-4fc9-8008-ec080edb59bd  ethernet  ens224  
bond-slave-ens256   6bc7b88d-6bfa-4f77-80c6-3a3520315ff2  ethernet  ens256  
Wired connection 1  5a8974d5-d562-38bb-a8df-3689c1ab9697  ethernet  --      
Wired connection 2  2256774b-4f3f-3103-8740-d93833e1a838  ethernet  --      
[root@DevOpser network-scripts]# 


[root@DevOpser network-scripts]# ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
ens192           UP             00:50:56:88:a3:6d <BROADCAST,MULTICAST,UP,LOWER_UP> 
ens224           UP             00:50:56:88:e0:ee <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> 
ens256           UP             00:50:56:88:e0:ee <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> 
VLAN500@ens192   UP             00:50:56:88:a3:6d <BROADCAST,MULTICAST,UP,LOWER_UP> 
bond0            UP             00:50:56:88:e0:ee <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> 


[root@DevOpser network-scripts]# ip -c address
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:50:56:88:a3:6d brd ff:ff:ff:ff:ff:ff
    inet 10.20.8.77/24 brd 10.20.8.255 scope global noprefixroute ens192
       valid_lft forever preferred_lft forever
3: ens224: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
    link/ether 00:50:56:88:e0:ee brd ff:ff:ff:ff:ff:ff
4: ens256: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bond0 state UP group default qlen 1000
    link/ether 00:50:56:88:e0:ee brd ff:ff:ff:ff:ff:ff permaddr 00:50:56:88:7d:f0
5: VLAN500@ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:50:56:88:a3:6d brd ff:ff:ff:ff:ff:ff
    inet 55.55.55.55/24 brd 55.55.55.255 scope global noprefixroute VLAN500
       valid_lft forever preferred_lft forever
    inet6 fe80::1f9e:a973:b362:2f57/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
7: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:50:56:88:e0:ee brd ff:ff:ff:ff:ff:ff
    inet 7.7.7.7/24 brd 7.7.7.255 scope global noprefixroute bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::8252:48d9:ea25:8d39/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

Ответ: 
Маска /29 определяет подсеть из 8 адресов.
Проверяем спросим у ipcalc что он может сказать о примере сети /29:
```bash
[root@DevOpser network-scripts]# ipcalc 192.168.1.0/29                   
Network:        192.168.1.0/29
Netmask:        255.255.255.248 = 29
Broadcast:      192.168.1.7

Address space:  Private Use
Address class:  Class C
HostMin:        192.168.1.1
HostMax:        192.168.1.6
Hosts/Net:      6
```
как мы видим он сообщает нам, что для узлов сети имеется 6 адресов с .1 по .6 , а также есть адрес самой сети .0 и широковещательный .7. Итого 8.

Хотя это наверное очевидно, что в сети /24, имеющей 256 адресов должно пометиться 32 сети /29 по 8 адресов, но попросим ту же утилиту составить нам разбиение:

```bash
[root@DevOpser network-scripts]# ipcalc --split=29 192.168.22.0/24          
[Split networks]
Network:        192.168.22.0/29
Network:        192.168.22.8/29
Network:        192.168.22.16/29
Network:        192.168.22.24/29
Network:        192.168.22.32/29
Network:        192.168.22.40/29
Network:        192.168.22.48/29
Network:        192.168.22.56/29
Network:        192.168.22.64/29
Network:        192.168.22.72/29
Network:        192.168.22.80/29
Network:        192.168.22.88/29
Network:        192.168.22.96/29
Network:        192.168.22.104/29
Network:        192.168.22.112/29
Network:        192.168.22.120/29
Network:        192.168.22.128/29
Network:        192.168.22.136/29
Network:        192.168.22.144/29
Network:        192.168.22.152/29
Network:        192.168.22.160/29
Network:        192.168.22.168/29
Network:        192.168.22.176/29
Network:        192.168.22.184/29
Network:        192.168.22.192/29
Network:        192.168.22.200/29
Network:        192.168.22.208/29
Network:        192.168.22.216/29
Network:        192.168.22.224/29
Network:        192.168.22.232/29
Network:        192.168.22.240/29
Network:        192.168.22.248/29

Total:          32
Hosts/Net:      6
```
Итак. мы получили 32 подсети.

7. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

Ответ:
Вообще, для частного использования определены несколько подсетей:

10.0.0.0 — 10.255.255.255 (маска подсети: 255.0.0.0 или /8)

172.16.0.0 — 172.31.255.255 (маска подсети: 255.240.0.0 или /12)

192.168.0.0 — 192.168.255.255 (маска подсети: 255.255.0.0 или /16)

100.64.0.0 — 100.127.255.255 (маска подсети: 255.192.0.0 или /10) Carrier-Grade NAT.

Но так как первые три по условию задачи у нас заняты, то мы должны взять адреса из последнего диапазона. 

Выделим себе подсеть и проверим на калькуляторе:
```bash
[root@DevOpser network-scripts]# ipcalc 100.64.0.0/26 
Network:        100.64.0.0/26
Netmask:        255.255.255.192 = 26
Broadcast:      100.64.0.63

Address space:  Shared Address Space
Address class:  Class A
HostMin:        100.64.0.1
HostMax:        100.64.0.62
Hosts/Net:      62
```
Получилась подсеть из 64 адресов. Больше чем спрашивали, но если взять маску 27, то получится всего 32 адреса, что не достаточно.

Итак наш ответ: 100.64.0.0/26 

8. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

Ответ:
```bash
PS E:\vagrant> arp -a

Интерфейс: 10.0.2.222 --- 0x10
  адрес в Интернете      Физический адрес      Тип
  10.0.2.255            ff-ff-ff-ff-ff-ff     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический

Интерфейс: 10.20.8.7 --- 0x12
  адрес в Интернете      Физический адрес      Тип
  10.20.8.1             00-50-56-be-18-77     динамический
  10.20.8.77            00-50-56-88-a3-6d     динамический
  10.20.8.250           00-50-56-be-36-4c     динамический
  10.20.8.253           00-50-56-88-d3-a1     динамический
  10.20.8.254           00-50-56-88-a0-2d     динамический
  10.20.8.255           ff-ff-ff-ff-ff-ff     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
  255.255.255.255       ff-ff-ff-ff-ff-ff     статический
```
Удалим один адрес из таблицы:
```bash
PS E:\vagrant> arp -d 10.20.8.254
PS E:\vagrant> arp -a

Интерфейс: 10.0.2.222 --- 0x10
  адрес в Интернете      Физический адрес      Тип
  10.0.2.255            ff-ff-ff-ff-ff-ff     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический

Интерфейс: 10.20.8.7 --- 0x12
  адрес в Интернете      Физический адрес      Тип
  10.20.8.1             00-50-56-be-18-77     динамический
  10.20.8.77            00-50-56-88-a3-6d     динамический
  10.20.8.250           00-50-56-be-36-4c     динамический
  10.20.8.253           00-50-56-88-d3-a1     динамический
  10.20.8.255           ff-ff-ff-ff-ff-ff     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
  255.255.255.255       ff-ff-ff-ff-ff-ff     статический
```
удалился.
Теперь очистим таблицу arp полностью:
```bash
PS E:\vagrant> arp -d *
PS E:\vagrant> arp -a

Интерфейс: 10.0.2.222 --- 0x10
  адрес в Интернете      Физический адрес      Тип
  239.255.255.250       01-00-5e-7f-ff-fa     статический

Интерфейс: 10.20.8.7 --- 0x12
  адрес в Интернете      Физический адрес      Тип
  10.20.8.250           00-50-56-be-36-4c     динамический
  10.20.8.253           00-50-56-88-d3-a1     динамический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
```
Как мы видим, в таблице что-то есть. Думаю это из за того, что за долю секунды, прошедшую после удаления в таблицу попали адреса, с которыми идёт постоянное взаимодействие. Я же через службу терминалов на этом windows работаю. Как-то так. 

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
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
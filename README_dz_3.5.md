# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

Ответ: Изучил.

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

Ответ: Жёсткие ссылки на один и тот же объект (например файл) не могут иместь разные права доступа и владельца, так как они указывают на один и тот же объект.

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

Ответ:
Смотрим, какие диски есть в системе:
```bash
vagrant@vagrant:~$ sudo fdisk -l
Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x3f94c461

Device     Boot   Start       End   Sectors  Size Id Type
/dev/sda1  *       2048   1050623   1048576  512M  b W95 FAT32
/dev/sda2       1052670 134215679 133163010 63.5G  5 Extended
/dev/sda5       1052672 134215679 133163008 63.5G 8e Linux LVM


Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vgvagrant-root: 62.55 GiB, 67150807040 bytes, 131153920 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/vgvagrant-swap_1: 980 MiB, 1027604480 bytes, 2007040 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```
Начинаем разбивать диск /dev/sdb. Создаём разделы 2Гб и второй на том что осталось:
```bash
vagrant@vagrant:~$ sudo fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0x80f2eedf.

Command (m for help): m

Help:

  DOS (MBR)
   a   toggle a bootable flag
   b   edit nested BSD disklabel
   c   toggle the dos compatibility flag

  Generic
   d   delete a partition
   F   list free unpartitioned space
   l   list known partition types
   n   add a new partition
   p   print the partition table
   t   change a partition type
   v   verify the partition table
   i   print information about a partition

  Misc
   m   print this menu
   u   change display/entry units
   x   extra functionality (experts only)

  Script
   I   load disk layout from sfdisk script file
   O   dump disk layout to sfdisk script file

  Save & Exit
   w   write table to disk and exit
   q   quit without saving changes

  Create a new label
   g   create a new empty GPT partition table
   G   create a new empty SGI (IRIX) partition table
   o   create a new empty DOS partition table
   s   create a new empty Sun partition table


Command (m for help): v
Remaining 5242879 unallocated 512-byte sectors.

Command (m for help): i
No partition is defined yet!

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): i
Selected partition 1
         Device: /dev/sdb1
          Start: 2048
            End: 4196351
        Sectors: 4194304
      Cylinders: 1619
           Size: 2G
             Id: 83
           Type: Linux
    Start-C/H/S: 0/42/33
      End-C/H/S: 594/51/48

Command (m for help): v
Remaining 1046528 unallocated 512-byte sectors.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):

Created a new partition 2 of type 'Linux' and of size 511 MiB.

Command (m for help): i
Partition number (1,2, default 2): 2

         Device: /dev/sdb2
          Start: 4196352
            End: 5242879
        Sectors: 1046528
      Cylinders: 404
           Size: 511M
             Id: 83
           Type: Linux
    Start-C/H/S: 594/52/1
      End-C/H/S: 998/38/32

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
Готово.
```bash
vagrant@vagrant:~$  sudo fdisk -l /dev/sdb
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x80f2eedf

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5242879 1046528  511M 83 Linux
```
6. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.
Ответ: Копируем таблицу разделов с одного диска на другой:
```bash
vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb | sudo sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x80f2eedf

Old situation:

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0x80f2eedf.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0x80f2eedf

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
```
Проверяем, что получилось на втором диске:
```bash
vagrant@vagrant:~$ sudo fdisk -l /dev/sdc
Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x80f2eedf

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5242879 1046528  511M 83 Linux
```
Получилось.

8. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

Ответ:
Создаём  массив raid1
```bash
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
mdadm: size set to 2094080K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
vagrant@vagrant:~$
```
Проверяем:

```bash
vagrant@vagrant:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```



10. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

Ответ:
Теперь создаём raid0 из вторых разделов:
```bash
vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: chunk size defaults to 512K
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
vagrant@vagrant:~$ sudo fdisk -l /dev/md1
Disk /dev/md1: 1018 MiB, 1067450368 bytes, 2084864 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 524288 bytes / 1048576 bytes
```
Проверяем, что появился второй массив:
```bash
vagrant@vagrant:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
md1 : active raid0 sdc2[1] sdb2[0]
      1042432 blocks super 1.2 512k chunks

md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]

unused devices: <none>
```
Сохраняем конфигурацию рейдов:
```bash
vagrant@vagrant:~$ sudo mdadm --detail --scan | sudo tee /etc/mdadm/mdadm.conf
ARRAY /dev/md0 metadata=1.2 name=vagrant:0 UUID=aaf454e6:5a471391:e08bcb67:e83d5759
ARRAY /dev/md1 metadata=1.2 name=vagrant:1 UUID=fd07ae0d:209a0155:68e50407:0fd01f8c
```

12. Создайте 2 независимых PV на получившихся md-устройствах.

Ответ:
Создаём два phisical volume (физических тома):
```bash
vagrant@vagrant:~$ sudo pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
```
Проверяем:
```bash
vagrant@vagrant:~$ sudo pvscan
  PV /dev/sda5   VG vgvagrant       lvm2 [<63.50 GiB / 0    free]
  PV /dev/md0                       lvm2 [<2.00 GiB]
  PV /dev/md1                       lvm2 [1018.00 MiB]
  Total: 3 [<66.49 GiB] / in use: 1 [<63.50 GiB] / in no VG: 2 [2.99 GiB]
```
Видим наши и ещё системный.

13. Создайте общую volume-group на этих двух PV.

Ответ:
Создаём volume-group (группу томов):
```bash
vagrant@vagrant:~$ sudo vgcreate vol_grp1 /dev/md0 /dev/md1
  Volume group "vol_grp1" successfully created
```
Проверяем:
```bash
vagrant@vagrant:~$ sudo vgdisplay
  --- Volume group ---
  VG Name               vgvagrant
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                2
  Open LV               2
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.50 GiB
  PE Size               4.00 MiB
  Total PE              16255
  Alloc PE / Size       16255 / <63.50 GiB
  Free  PE / Size       0 / 0
  VG UUID               PaBfZ0-3I0c-iIdl-uXKt-JL4K-f4tT-kzfcyE

  --- Volume group ---
  VG Name               vol_grp1
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               <2.99 GiB
  PE Size               4.00 MiB
  Total PE              765
  Alloc PE / Size       0 / 0
  Free  PE / Size       765 / <2.99 GiB
  VG UUID               70P3No-E8sL-jn1E-eoyD-0Syx-9DJb-10MeHi
```
Видим, что помимо системной группы томов, появилась и наша. Размер, как и ожидалось 3Гб.

14. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

Ответ:
Создаём LV (логический том):

```bash
vagrant@vagrant:~$ sudo lvcreate -L 100M vol_grp1 /dev/md1
  Logical volume "lvol0" created.
```
Проверяем:
```bash
vagrant@vagrant:~$ sudo lvdisplay
  --- Logical volume ---
  LV Path                /dev/vgvagrant/root
  LV Name                root
  VG Name                vgvagrant
  LV UUID                ybvP3g-N4gJ-FMMr-WfRk-Ermg-cftw-In20VW
  LV Write Access        read/write
  LV Creation host, time vagrant, 2021-07-28 17:45:53 +0000
  LV Status              available
  # open                 1
  LV Size                <62.54 GiB
  Current LE             16010
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

  --- Logical volume ---
  LV Path                /dev/vgvagrant/swap_1
  LV Name                swap_1
  VG Name                vgvagrant
  LV UUID                GoQVTk-fU79-pbTZ-vX0W-9DbL-p7OI-XCSHPj
  LV Write Access        read/write
  LV Creation host, time vagrant, 2021-07-28 17:45:53 +0000
  LV Status              available
  # open                 2
  LV Size                980.00 MiB
  Current LE             245
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1

  --- Logical volume ---
  LV Path                /dev/vol_grp1/lvol0
  LV Name                lvol0
  VG Name                vol_grp1
  LV UUID                b1LC7P-kVS3-0W7t-6qn0-PMgP-gLGh-VPV3zG
  LV Write Access        read/write
  LV Creation host, time vagrant, 2021-11-30 07:56:16 +0000
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     4096
  Block device           253:2
```
Последний логический том - наш, только что созданный.

15. Создайте `mkfs.ext4` ФС на получившемся LV.

Ответ:
```bash
vagrant@vagrant:~$ sudo mkfs.ext4 /dev/vol_grp1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
```

16. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

Ответ:
```bash
vagrant@vagrant:~$ sudo mkdir /tmp/new
vagrant@vagrant:~$ sudo mount /dev/vol_grp1/lvol0 /tmp/new
vagrant@vagrant:~$ cd /tmp/new
vagrant@vagrant:/tmp/new$ ls
lost+found
vagrant@vagrant:/tmp/new$ df -h
Filesystem                  Size  Used Avail Use% Mounted on
udev                        464M     0  464M   0% /dev
tmpfs                        99M  700K   98M   1% /run
/dev/mapper/vgvagrant-root   62G  1.5G   57G   3% /
tmpfs                       491M     0  491M   0% /dev/shm
tmpfs                       5.0M     0  5.0M   0% /run/lock
tmpfs                       491M     0  491M   0% /sys/fs/cgroup
/dev/sda1                   511M  4.0K  511M   1% /boot/efi
tmpfs                        99M     0   99M   0% /run/user/1000
/dev/mapper/vol_grp1-lvol0   93M   72K   86M   1% /tmp/new
```
Видим, что всё смонтировалось и доступно.

17. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

Ответ:

```bash
vagrant@vagrant:/tmp/new$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gzwget https://mirror.yandex.ru/ubuntu/ls-lR.
gz
--2021-11-30 08:08:37--  https://mirror.yandex.ru/ubuntu/ls-lR.gzwget
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 404 Not Found
2021-11-30 08:08:37 ERROR 404: Not Found.

--2021-11-30 08:08:37--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Reusing existing connection to mirror.yandex.ru:443.
HTTP request sent, awaiting response... 200 OK
Length: 22574425 (22M) [application/octet-stream]
Saving to: 'ls-lR.gz'

ls-lR.gz                      100%[=================================================>]  21.53M  5.42MB/s    in 4.2s

2021-11-30 08:08:41 (5.09 MB/s) - 'ls-lR.gz' saved [22574425/22574425]

FINISHED --2021-11-30 08:08:41--
Total wall clock time: 4.8s
Downloaded: 1 files, 22M in 4.2s (5.09 MB/s)

vagrant@vagrant:/tmp/new$ ls -la
total 22072
drwxr-xr-x  3 root root     4096 Nov 30 08:08 .
drwxrwxrwt 11 root root     4096 Nov 30 08:02 ..
drwx------  2 root root    16384 Nov 30 07:59 lost+found
-rw-r--r--  1 root root 22574425 Nov 29 09:55 ls-lR.gz
```
готово

18. Прикрепите вывод `lsblk`.

Ответ:
```bash
vagrant@vagrant:/tmp/new$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
    └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
    └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new
```

19. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
Ответ:
```bash
vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/ls-lR.gz
vagrant@vagrant:/tmp/new$ echo $?
0
```

20. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

Ответ:

```bash
vagrant@vagrant:/tmp/new$ sudo pvmove /dev/md1 /dev/md0
  /dev/md1: Moved: 28.00%
  /dev/md1: Moved: 100.00%
vagrant@vagrant:/tmp/new$
vagrant@vagrant:/tmp/new$
vagrant@vagrant:/tmp/new$ lsblk
NAME                 MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda                    8:0    0   64G  0 disk
├─sda1                 8:1    0  512M  0 part  /boot/efi
├─sda2                 8:2    0    1K  0 part
└─sda5                 8:5    0 63.5G  0 part
  ├─vgvagrant-root   253:0    0 62.6G  0 lvm   /
  └─vgvagrant-swap_1 253:1    0  980M  0 lvm   [SWAP]
sdb                    8:16   0  2.5G  0 disk
├─sdb1                 8:17   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
│   └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new
└─sdb2                 8:18   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
sdc                    8:32   0  2.5G  0 disk
├─sdc1                 8:33   0    2G  0 part
│ └─md0                9:0    0    2G  0 raid1
│   └─vol_grp1-lvol0 253:2    0  100M  0 lvm   /tmp/new
└─sdc2                 8:34   0  511M  0 part
  └─md1                9:1    0 1018M  0 raid0
vagrant@vagrant:/tmp/new$
```
Как видно VG переехала на другой PV.

21. Сделайте `--fail` на устройство в вашем RAID1 md.

Ответ:
```bash
vagrant@vagrant:/tmp/new$ sudo mdadm --fail /dev/md0 /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md0
```

22. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

Ответ:

```bash
vagrant@vagrant:/tmp/new$ dmesg | tail
[   11.727988] 07:26:51.336608 main     OS Version: #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021
[   11.728119] 07:26:51.336727 main     Executable: /opt/VBoxGuestAdditions-6.1.24/sbin/VBoxService
               07:26:51.336730 main     Process ID: 937
               07:26:51.336730 main     Package type: LINUX_64BITS_GENERIC
[   11.731970] 07:26:51.340588 main     6.1.24 r145751 started. Verbose level = 0
[   11.733285] 07:26:51.341884 main     vbglR3GuestCtrlDetectPeekGetCancelSupport: Supported (#1)
[ 2301.324132] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts: (null)
[ 2301.324153] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
[ 3272.727080] md/raid1:md0: Disk failure on sdc1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
```

23. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```

Ответ:
```bash
vagrant@vagrant:/tmp/new$ gzip -t /tmp/new/ls-lR.gz
vagrant@vagrant:/tmp/new$ echo $?
0
```

24. Погасите тестовый хост, `vagrant destroy`.
Ответ: Выполнено.
 
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
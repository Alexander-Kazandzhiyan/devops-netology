
# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"


## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

### Ответ

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
Использование IaaC паттернов для предоставления окружения для запуска программных продуктов обеспечивает:
1) Скорость развёртывания инфраструктуры для запуска приложений, а значит увеличивает скорость запуска, тестирования, вывода в продакшн новых версий продукта и масштабирования. Это увеличивает скорость развития продукта и, как следствие, коммерческий успех. Смысл в том, что инфраструктура (нужное количество виртуальных серверов с нужными и уже правильно настроенными сервисами) благодаря паттернам IaaC разворачивается полностью автоматизировано и быстро.
2) Стабильность среды, устранение дрейфа конфигураций. При разработке, тестировании и запуске в продакшн очень важно, чтобы окружение было максимально идентичным, а вообще говоря, одинаковым. Тогда можно рассчитывать, что продукт поведёт себя в продакшне так-же, как и при тестировании. А это обязательное условие. Кроме того, если бы использовался традиционный подход к изготовлению и циклу развёртывания и эксплуатации среды окружения (серверы и сервисы для запуска продукта), то дрейф конфигураций, то есть постепенное изменение, настроек и даже версий какие-то сервисов в инфраструктуре разработки, тестирования и продашна мог бы приводить к непредсказуемым влияниям на работу продукта, а значит ставил бы под сомнение стабильность работы продукта в продакшне.

- Какой из принципов IaaC является основополагающим?
Главный принцип IaaC это Идемпотентность. Это свойство системы вести себя одинаково то есть давать один и тот же результат при многократном повторении одних и тех-же действий. Именно для этого и придуманы паттерны. Исключая человеческий фактор инфраструктура разворачивается всегда одна и та-же (заранее отлаженная и проверенная) и программный продукт будучи уже оттестированным на этой инфраструктуре должен вести себя так-же, как и при тестировании.

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

### Ответ
- Чем Ansible выгодно отличается от других систем управление конфигурациями?

Учитывая, что на момент ответа на вопрос я не работал ни с какой системой управления конфигурациями, в данный момент, кажется, что преимущества Ansible заключаются в следующих его особенностях:
  - Работает с инфраструктурой по SSH, то есть не требует установки дополнительных агентов на серверы и PKI инфраструктуры
  - Используют декларативный (то есть описывающий состояние которое мы хотим получить) формат конфигов в понятном формате yaml
  - Расширяемость путём подключения дополнительных ролей и модулей
  - Написан на Python. Язык простой в изучении и применении, знакомый большинству специалистов
  

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?
Метод Push - это когда некий управляющий узел отправляет задания на скачивание и установку конфигурации на все управляемые им серверы, а Pull - это когда серверы сами обращаются за конфигурацией. 
Опять же, учитывая отсутствие опыта, Мне кажется, что Push должен быть надёжнее. Если мы запускаем развёртывание инфраструктуры с центрального узла управления, то мы сразу же на нём получим результат, что и где пошло не так и вообще гоаоря будем сразу знать все ли серверы получили свои настройки. А в случае, использования Pull наверное возможны ситуации, когда какой-то сервер вообще не обратился за конфигурацией потому что на нём что-то пошло не так или расстроилось, а мы узнаем об этом не сразу. Ну короче говоря, интуитивно кажется, что Push надёжнее. Активировал - увидел результат и можно точно знать, что дело сделано.  

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

### Ответ
Приготовьтесь, сейчас будет много букв :)

Ура!, подумал я Vagrant и VirtualBox уже были установлены у меня под Windows. И даже уже имеется одна ВМ, развёрнутая ранее.
```bash
PS E:\vagrant> vagrant -v
Vagrant 2.2.19
PS E:\vagrant> vagrant box list
bento/ubuntu-20.04 (virtualbox, 202107.28.0)
```
Попробуем добавить ещё одну ВМ:

```bash
PS E:\vagrant> vagrant box add bento/ubuntu-20.04 --provider=virtualbox --force
==> box: Loading metadata for box 'bento/ubuntu-20.04'
    box: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> box: Adding box 'bento/ubuntu-20.04' (v202112.19.0) for provider: virtualbox
    box: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202112.19.0/providers/virtualbox.box
    box:
==> box: Successfully added box 'bento/ubuntu-20.04' (v202112.19.0) for 'virtualbox'!
PS E:\vagrant>
PS E:\vagrant>
PS E:\vagrant> vagrant box list
bento/ubuntu-20.04 (virtualbox, 202107.28.0)
bento/ubuntu-20.04 (virtualbox, 202112.19.0)
PS E:\vagrant>
```
Видим, что вторая ВМ добавилась. 

Но бросаем эту затею. Ведь в следующем задании надо будет запускать Ansible, а он, как выяснилось, официально отсутсвует под Windows. Есть какие-то костыльные решения, но нам такой путь не интересен.
Попытаемся установить Vagrant, VirtualBox и Ansible на Ubuntu Server. по секрету скажу, что Ubuntu Server тоже является ВМ под ESXi, но я сделал всё, чтоб на нём смог работать VirtualBox.

Вот данные по созданному этому Ubuntu серверу:
```bash
user1@devopserubuntu:~$ uname -a
Linux devopserubuntu 5.13.0-27-generic #29-Ubuntu SMP Wed Jan 12 17:36:47 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

user1@devopserubuntu:~$ cat /etc/*release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=21.10
DISTRIB_CODENAME=impish
DISTRIB_DESCRIPTION="Ubuntu 21.10"
PRETTY_NAME="Ubuntu 21.10"
NAME="Ubuntu"
VERSION_ID="21.10"
VERSION="21.10 (Impish Indri)"
VERSION_CODENAME=impish
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=impish
```

- Устанвливаем Virtualbox:
```bash
user1@devopserubuntu:~$ wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
OK

user1@devopserubuntu:~$ sudo apt-get update
Hit:1 http://de.archive.ubuntu.com/ubuntu impish InRelease
Hit:2 http://de.archive.ubuntu.com/ubuntu impish-updates InRelease
Hit:3 http://de.archive.ubuntu.com/ubuntu impish-backports InRelease
Hit:4 http://de.archive.ubuntu.com/ubuntu impish-security InRelease
Reading package lists... Done

user1@devopserubuntu:~$ sudo apt-get install virtualbox-6.1
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
virtualbox-6.1 is already the newest version (6.1.32-149290~Ubuntu~eoan).
You might want to run 'apt --fix-broken install' to correct these.
The following packages have unmet dependencies:
 virtualbox-6.1 : Depends: libgl1 but it is not going to be installed
                  Depends: libopus0 (>= 1.1) but it is not going to be installed
                  Depends: libqt5core5a (>= 5.12.2) but it is not going to be installed
                  Depends: libqt5gui5 (>= 5.4.0) but it is not going to be installed or
                           libqt5gui5-gles (>= 5.4.0) but it is not going to be installed
                  Depends: libqt5opengl5 (>= 5.0.2) but it is not going to be installed
                  Depends: libqt5printsupport5 (>= 5.0.2) but it is not going to be installed
                  Depends: libqt5widgets5 (>= 5.12.2) but it is not going to be installed
                  Depends: libqt5x11extras5 (>= 5.6.0) but it is not going to be installed
                  Depends: libsdl1.2debian (>= 1.2.11)
                  Depends: libvpx6 (>= 1.6.0) but it is not going to be installed
                  Depends: libxcursor1 (> 1.1.2) but it is not going to be installed
                  Depends: libxt6 but it is not going to be installed
                  Recommends: libasound2
                  Recommends: libpulse0 but it is not going to be installed
                  Recommends: libsdl-ttf2.0-0 but it is not going to be installed
                  Recommends: gcc but it is not going to be installed
                  Recommends: make or
                              build-essential but it is not going to be installed or
                              dpkg-dev but it is not going to be installed
                  Recommends: pdf-viewer
E: Unmet dependencies. Try 'apt --fix-broken install' with no packages (or specify a solution).
```
как видно есть неудовлетворённые зависимости. Их надо удовлетворить

```bash
user1@devopserubuntu:~$ sudo apt-get -f install
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Correcting dependencies... Done
The following additional packages will be installed:
  adwaita-icon-theme alsa-topology-conf alsa-ucm-conf at-spi2-core dbus-user-session dconf-gsettings-backend dconf-service fontconfig fontconfig-config fonts-dejavu-core gtk-update-icon-cache
  hicolor-icon-theme humanity-icon-theme libasound2 libasound2-data libasyncns0 libatk-bridge2.0-0 libatk1.0-0 libatk1.0-data libatspi2.0-0 libavahi-client3 libavahi-common-data libavahi-common3 libcaca0
  libcairo-gobject2 libcairo2 libcolord2 libcups2 libdatrie1 libdconf1 libdeflate0 libdouble-conversion3 libdrm-amdgpu1 libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 libegl-mesa0 libegl1 libepoxy0 libflac8
  libfontconfig1 libgbm1 libgdk-pixbuf-2.0-0 libgdk-pixbuf2.0-bin libgdk-pixbuf2.0-common libgl1 libgl1-mesa-dri libglapi-mesa libglvnd0 libglx-mesa0 libglx0 libgraphite2-3 libgtk-3-0 libgtk-3-bin
  libgtk-3-common libharfbuzz0b libice6 libinput-bin libinput10 libjbig0 libjpeg-turbo8 libjpeg8 liblcms2-2 libllvm12 libmd4c0 libmtdev1 libogg0 libopus0 libpango-1.0-0 libpangocairo-1.0-0
  libpangoft2-1.0-0 libpciaccess0 libpcre2-16-0 libpixman-1-0 libpulse0 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5opengl5 libqt5printsupport5 libqt5svg5 libqt5widgets5 libqt5x11extras5
  librsvg2-2 librsvg2-common libsdl1.2debian libsensors-config libsensors5 libsm6 libsndfile1 libthai-data libthai0 libtiff5 libvorbis0a libvorbisenc2 libvpx6 libvulkan1 libwacom-bin libwacom-common
  libwacom2 libwayland-client0 libwayland-cursor0 libwayland-egl1 libwayland-server0 libwebp6 libx11-xcb1 libxcb-dri2-0 libxcb-dri3-0 libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1
  libxcb-present0 libxcb-randr0 libxcb-render-util0 libxcb-render0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1 libxcb-xfixes0 libxcb-xinerama0 libxcb-xinput0 libxcb-xkb1 libxcomposite1 libxcursor1
  libxdamage1 libxfixes3 libxi6 libxinerama1 libxkbcommon-x11-0 libxkbcommon0 libxrandr2 libxrender1 libxshmfence1 libxt6 libxtst6 libxxf86vm1 mesa-vulkan-drivers qt5-gtk-platformtheme
  qttranslations5-l10n ubuntu-mono x11-common

.... Очень Много букв ........

Setting up libqt5widgets5:amd64 (5.15.2+dfsg-12ubuntu1.1) ...
Setting up librsvg2-2:amd64 (2.50.7+dfsg-1) ...
Setting up libqt5printsupport5:amd64 (5.15.2+dfsg-12ubuntu1.1) ...
Setting up librsvg2-common:amd64 (2.50.7+dfsg-1) ...
Setting up libqt5opengl5:amd64 (5.15.2+dfsg-12ubuntu1.1) ...
Setting up libgdk-pixbuf2.0-bin (2.42.6+dfsg-1build2) ...
Setting up libqt5x11extras5:amd64 (5.15.2-2) ...
Setting up libqt5svg5:amd64 (5.15.2-3) ...
Setting up virtualbox-6.1 (6.1.32-149290~Ubuntu~eoan) ...
Adding group 'vboxusers' (GID 118) ...
Done.

This system is currently not set up to build kernel modules.
Please install the gcc make perl packages from your distribution.
This system is currently not set up to build kernel modules.
Please install the gcc make perl packages from your distribution.

There were problems setting up VirtualBox.  To re-start the set-up process, run
  /sbin/vboxconfig
as root.  If your system is using EFI Secure Boot you may need to sign the
kernel modules (vboxdrv, vboxnetflt, vboxnetadp, vboxpci) before you can load
them. Please see your Linux systems documentation for more information.
Setting up adwaita-icon-theme (40.1.1-1ubuntu1) ...
update-alternatives: using /usr/share/icons/Adwaita/cursor.theme to provide /usr/share/icons/default/index.theme (x-cursor-theme) in auto mode
Setting up humanity-icon-theme (0.6.15) ...
Setting up ubuntu-mono (20.10-0ubuntu1) ...
Processing triggers for man-db (2.9.4-2) ...
Processing triggers for udev (248.3-1ubuntu8.2) ...
Processing triggers for libglib2.0-0:amd64 (2.68.4-1ubuntu1) ...
Setting up libgtk-3-0:amd64 (3.24.30-1ubuntu1) ...
Processing triggers for libc-bin (2.34-0ubuntu3) ...
Setting up libgtk-3-bin (3.24.30-1ubuntu1) ...
Setting up qt5-gtk-platformtheme:amd64 (5.15.2+dfsg-12ubuntu1.1) ...
Processing triggers for libgdk-pixbuf-2.0-0:amd64 (2.42.6+dfsg-1build2) ...
needrestart is being skipped since dpkg has failed
```
Как мы видим в конце была попытка установить virtualbox, но после установки при поытке его донастройки нам выдана проблема:

```bash
This system is currently not set up to build kernel modules.
Please install the gcc make perl packages from your distribution.
This system is currently not set up to build kernel modules.
Please install the gcc make perl packages from your distribution.

There were problems setting up VirtualBox.  To re-start the set-up process, run
  /sbin/vboxconfig
as root.  If your system is using EFI Secure Boot you may need to sign the
kernel modules (vboxdrv, vboxnetflt, vboxnetadp, vboxpci) before you can load
them. Please see your Linux systems documentation for more information.
```
То же самое получаем при ручной попытке его донастроить:

```bash
user1@devopserubuntu:~$ sudo /sbin/vboxconfig
vboxdrv.sh: Stopping VirtualBox services.
vboxdrv.sh: Starting VirtualBox services.
vboxdrv.sh: Building VirtualBox kernel modules.
This system is currently not set up to build kernel modules.
Please install the gcc make perl packages from your distribution.
This system is currently not set up to build kernel modules.
Please install the gcc make perl packages from your distribution.

There were problems setting up VirtualBox.  To re-start the set-up process, run
  /sbin/vboxconfig
as root.  If your system is using EFI Secure Boot you may need to sign the
kernel modules (vboxdrv, vboxnetflt, vboxnetadp, vboxpci) before you can load
them. Please see your Linux system's documentation for more information.
```
Судя по всему ему не хватает gcc  и модулей ядра для пересборки. Выполняем эти команды, получаем много букв, но в итоге всё поставилось:
```bash
user1@devopserubuntu:~$ sudo apt-get install --reinstall gcc
user1@devopserubuntu:~$ sudo apt-get install build-essential gcc make perl dkms
```

И вот теперь это сработало:
```bash
user1@devopserubuntu:~$ sudo /sbin/vboxconfig
vboxdrv.sh: Stopping VirtualBox services.
vboxdrv.sh: Starting VirtualBox services.
vboxdrv.sh: Building VirtualBox kernel modules.
```

Можно считать что virtualbox установлен.
```bash
user1@devopserubuntu:~$ vboxmanage -v
6.1.32r149290
```


- Устанавливаем Vagrant

```bash
user1@devopserubuntu:~$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
OK

user1@devopserubuntu:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Repository: 'deb [arch=amd64] https://apt.releases.hashicorp.com impish main'
Description:
Archive for codename: impish components: main
More info: https://apt.releases.hashicorp.com
Adding repository.
Press [ENTER] to continue or Ctrl-c to cancel.
Adding deb entry to /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-impish.list
Adding disabled deb-src entry to /etc/apt/sources.list.d/archive_uri-https_apt_releases_hashicorp_com-impish.list
Hit:1 http://de.archive.ubuntu.com/ubuntu impish InRelease
Get:2 http://de.archive.ubuntu.com/ubuntu impish-updates InRelease [110 kB]
Get:3 https://apt.releases.hashicorp.com impish InRelease [9,497 B]
Get:4 https://apt.releases.hashicorp.com impish/main amd64 Packages [42.5 kB]
Get:5 http://de.archive.ubuntu.com/ubuntu impish-backports InRelease [101 kB]
Get:6 http://de.archive.ubuntu.com/ubuntu impish-security InRelease [110 kB]
Fetched 373 kB in 1s (449 kB/s)
Reading package lists... Done
user1@devopserubuntu:~$ sudo apt-get update && sudo apt-get install vagrant
Hit:1 http://de.archive.ubuntu.com/ubuntu impish InRelease
Get:2 http://de.archive.ubuntu.com/ubuntu impish-updates InRelease [110 kB]
Hit:3 https://apt.releases.hashicorp.com impish InRelease
Get:4 http://de.archive.ubuntu.com/ubuntu impish-backports InRelease [101 kB]
Get:5 http://de.archive.ubuntu.com/ubuntu impish-security InRelease [110 kB]
Fetched 321 kB in 1s (379 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
  vagrant
0 upgraded, 1 newly installed, 0 to remove and 26 not upgraded.
Need to get 41.5 MB of archives.
After this operation, 117 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com impish/main amd64 vagrant amd64 2.2.19 [41.5 MB]
Fetched 41.5 MB in 10s (4,338 kB/s)
Selecting previously unselected package vagrant.
(Reading database ... 87703 files and directories currently installed.)
Preparing to unpack .../vagrant_2.2.19_amd64.deb ...
Unpacking vagrant (2.2.19) ...
Setting up vagrant (2.2.19) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.
```
- Устанавливаем Ansible:

```bash
user1@devopserubuntu:~$ sudo apt-get install ansible
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  ieee-data python3-argcomplete python3-dnspython python3-ecdsa python3-jmespath python3-kerberos python3-libcloud python3-lockfile python3-netaddr python3-ntlm-auth python3-packaging python3-pycryptodome
  python3-pyparsing python3-requests-kerberos python3-requests-ntlm python3-selinux python3-winrm python3-xmltodict
Suggested packages:
  cowsay sshpass python-lockfile-doc ipython3 python-netaddr-docs python-pyparsing-doc
The following NEW packages will be installed:
  ansible ieee-data python3-argcomplete python3-dnspython python3-ecdsa python3-jmespath python3-kerberos python3-libcloud python3-lockfile python3-netaddr python3-ntlm-auth python3-packaging
  python3-pycryptodome python3-pyparsing python3-requests-kerberos python3-requests-ntlm python3-selinux python3-winrm python3-xmltodict
0 upgraded, 19 newly installed, 0 to remove and 26 not upgraded.
Need to get 31.8 MB of archives.
After this operation, 276 MB of additional disk space will be used.
Do you want to continue? [Y/n] y
Get:1 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-pyparsing all 2.4.7-1 [61.4 kB]
Get:2 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-packaging all 20.9-2 [29.9 kB]
Get:3 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-pycryptodome amd64 3.9.7+dfsg1-1build3 [9,939 kB]
Get:4 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-dnspython all 2.0.0+really1.16.0-2ubuntu2 [96.9 kB]
Get:5 http://de.archive.ubuntu.com/ubuntu impish/main amd64 ieee-data all 20210605.1 [1,887 kB]
Get:6 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-netaddr all 0.8.0-1 [308 kB]
Get:7 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 ansible all 2.10.7+merged+base+2.10.8+dfsg-1 [17.5 MB]
Get:8 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-argcomplete all 1.8.1-1.5 [27.2 kB]
Get:9 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-ecdsa all 0.16.1-1 [82.9 kB]
Get:10 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-jmespath all 0.10.0-1 [21.7 kB]
Get:11 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-kerberos amd64 1.1.14-3.1build3 [22.3 kB]
Get:12 http://de.archive.ubuntu.com/ubuntu impish/main amd64 python3-lockfile all 1:0.12.2-2.2 [14.6 kB]
Get:13 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-libcloud all 3.2.0-2 [1,554 kB]
Get:14 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-ntlm-auth all 1.4.0-1 [20.4 kB]
Get:15 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-requests-kerberos all 0.12.0-2 [11.9 kB]
Get:16 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-requests-ntlm all 1.1.0-1.1 [6,160 B]
Get:17 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-selinux amd64 3.1-3build2 [155 kB]
Get:18 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-xmltodict all 0.12.0-2 [12.6 kB]
Get:19 http://de.archive.ubuntu.com/ubuntu impish/universe amd64 python3-winrm all 0.3.0-2 [21.7 kB]
Fetched 31.8 MB in 7s (4,697 kB/s)
Selecting previously unselected package python3-pyparsing.
(Reading database ... 94021 files and directories currently installed.)
Preparing to unpack .../00-python3-pyparsing_2.4.7-1_all.deb ...
Unpacking python3-pyparsing (2.4.7-1) ...
... Много букв ....
Setting up python3-winrm (0.3.0-2) ...
Setting up ansible (2.10.7+merged+base+2.10.8+dfsg-1) ...
Processing triggers for man-db (2.9.4-2) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.
```

Итак всё установлено наконец. Проверяем версии:

```bash
user1@devopserubuntu:~$ vboxmanage -v
6.1.32r149290
user1@devopserubuntu:~$ vagrant --version
Vagrant 2.2.19
user1@devopserubuntu:~$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/user1/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.9.7 (default, Sep 10 2021, 14:59:43) [GCC 11.2.0]
user1@devopserubuntu:~$
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```

### Ответ

Проверяем с, что список ВМ (или может быть точнее - шаблонов ОС)  под управлением vagrant пуст и добаляем Ubuntu:
```bash
user1@devopserubuntu:~$ vagrant box list
There are no installed boxes! Use `vagrant box add` to add some.

user1@devopserubuntu:~$ vagrant box add bento/ubuntu-20.04 --provider=virtualbox --force
==> box: Loading metadata for box 'bento/ubuntu-20.04'
    box: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> box: Adding box 'bento/ubuntu-20.04' (v202112.19.0) for provider: virtualbox
    box: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202112.19.0/providers/virtualbox.box
==> box: Successfully added box 'bento/ubuntu-20.04' (v202112.19.0) for 'virtualbox'!
user1@devopserubuntu:~$
```
Установилась:
```bash
user1@devopserubuntu:~$ vagrant box list
bento/ubuntu-20.04 (virtualbox, 202112.19.0)
```

Для запуска этой ВМ создадим `Vagrantfile` следующего содержания (внесены изменения: ip и путь к папке .ansible):
```bash
user1@devopserubuntu:~$ cat Vagrantfile
# -*- mode: ruby -*-

ISO = "bento/ubuntu-20.04"
NET = "192.168.56."
DOMAIN = ".netology"
HOST_PREFIX = "server"
INVENTORY_PATH = "/home/user1/.ansible/inventory"

servers = [
  {
    :hostname => HOST_PREFIX + "1" + DOMAIN,
    :ip => NET + "11",
    :ssh_host => "20011",
    :ssh_vm => "22",
    :ram => 1024,
    :core => 1
  }
]

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: false
  servers.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.box = ISO
      node.vm.hostname = machine[:hostname]
      node.vm.network "private_network", ip: machine[:ip]
      node.vm.network :forwarded_port, guest: machine[:ssh_vm], host: machine[:ssh_host]
      node.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", machine[:ram]]
        vb.customize ["modifyvm", :id, "--cpus", machine[:core]]
        vb.name = machine[:hostname]
      end
      node.vm.provision "ansible" do |setup|
        setup.inventory_path = INVENTORY_PATH
        setup.playbook = "/home/user1/.ansible/provision.yml"
        setup.become = true
        setup.extra_vars = { ansible_user: 'vagrant' }
      end
    end
  end
end
```
кроме того создаём в папке `/home/user1/.ansible` два файла `inventory` и `provision.yml`:
```bash
user1@devopserubuntu:~/.ansible$ cat inventory
[nodes:children]
manager

[manager]
server1.netology ansible_host=127.0.0.1 ansible_port=20011 ansible_user=vagrant
```
и плейбук для провижна нашей ВМ:
```bash
user1@devopserubuntu:~/.ansible$ cat provision.yml
---

  - hosts: nodes
    become: yes
    become_user: root
    remote_user: vagrant

    tasks:
      - name: Create directory for ssh-keys
        file: state=directory mode=0700 dest=/root/.ssh/

      - name: Adding rsa-key in /root/.ssh/authorized_keys
        copy: src=~/.ssh/id_rsa.pub dest=/root/.ssh/authorized_keys owner=root mode=0600
        ignore_errors: yes

      - name: Checking DNS
        command: host -t A google.com

      - name: Installing tools
        apt: >
          package={{ item }}
          state=present
          update_cache=yes
        with_items:
          - git
          - curl

      - name: Installing docker
        shell: curl -fsSL get.docker.com -o get-docker.sh && chmod +x get-docker.sh && ./get-docker.sh

      - name: Add the current user to docker group
        user: name=vagrant append=yes groups=docker
user1@devopserubuntu:~/.ansible$
```
Пробуем запустить ВМ. С первого раа не срабатывал provisioning ансибла, так как в Vagrantfile был не правильные пути. Но когда пути исправил ВМ стартовала, но уже провижн не хотел на ней делаться автоматом. требовалось `vagrant provision`. Поэтому ту ВМ я удалил `vagrant destroy` (при этом box Ubuntu из вагранта не удаляется) и запустил её заново.
Видим как она запускалась и теперь на ней сразу произошёл провижн ансиблом:
```bash
user1@devopserubuntu:~$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology:
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology:
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if its present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/user1
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: If you are using a module and expect the file to exist on the remote, see the remote_src option
fatal: [server1.netology]: FAILED! => {"changed": false, "msg": "Could not find or access '~/.ssh/id_rsa.pub' on the Ansible Controller.\nIf you are using a module and expect the file to exist on the remote, see the remote_src option"}
...ignoring

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
[DEPRECATION WARNING]: Invoking "apt" only once while using a loop via
squash_actions is deprecated. Instead of using a loop to supply multiple items
and specifying `package: "{{ item }}"`, please use `package: ['git', 'curl']`
and remove the loop. This feature will be removed from ansible-base in version
2.11. Deprecation warnings can be disabled by setting
deprecation_warnings=False in ansible.cfg.
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
[WARNING]: Consider using the get_url or uri module rather than running 'curl'.
If you need to use command because get_url or uri is insufficient you can add
'warn: false' to this command task or set 'command_warnings=False' in
ansible.cfg to get rid of this message.
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=1
```
Видим, что есть некие косячки, но в целом всё сработало. 
```bash
user1@devopserubuntu:~$ vagrant status
Current machine states:

server1.netology          running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
```

ВМ запущена. Зайдём в ВМ и проверим как там дела:
```bash
user1@devopserubuntu:~$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 21 Jan 2022 07:43:18 AM UTC

  System load:  0.0                Users logged in:          0
  Usage of /:   13.4% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    109


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Jan 21 07:35:59 2022 from 10.0.2.2
```

Выполним проверки настроек:
```bash
vagrant@server1:~$ cat /etc/*release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS"
NAME="Ubuntu"
VERSION="20.04.3 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.3 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal

vagrant@server1:~$ ip a | grep inet | grep 192
    inet 192.168.56.11/24 brd 192.168.56.255 scope global eth1

vagrant@server1:~$  hostname -f

vagrant@server1:~$ free
              total        used        free      shared  buff/cache   available
Mem:        1004800      172404      132436         956      699960      680536
Swap:       2009084        2060     2007024
```
Похоже всё правильно. 

Проверим состояние докера, который должен был развернуться на ней:
```bash
vagrant@server1:~$ docker --version
Docker version 20.10.12, build e91ed57

vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
Всё отлично `docker` установился и даже работает!

# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

Ответ: По разному поискал. Но судя по всему вот эта команда смены директории:  `chdir("/tmp")`
    
```bash
      vagrant@vagrant:~$ strace -f /bin/bash -c 'cd /tmp' 2>&1 | grep tmp
      execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffcb94c77d8 /* 24 vars */) = 0
      stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
      chdir("/tmp")                           = 0
   ```

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

Ответ: Команда file использует базу данных magic для попытки определить тип содержимого, исследуемого файла. Для этого она пытается открыть и magic в пользовательском профиле, затем в папке /etc (/etc/magic)  но если там не находит то смотрит в `/usr/share/misc/magic.mgc`.
системный вызов: `openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3`

3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

Ответ: Итак, запускаем приложение с постоянным выводом в файл:
```bash
vagrant@vagrant:~$ ping 127.0.0.1 >> ping.log
```
теперь в другом терминале смотрим, что появился файл:
```bash
vagrant@vagrant:~$ ls -la ping.log
-rw-rw-r-- 1 vagrant vagrant 678 Nov 26 14:56 ping.log
vagrant@vagrant:~$
````
теперь посмотрим pid процесса ping:
```bash
vagrant@vagrant:~$ ps -aux | grep ping
vagrant    40166  0.0  0.0   9692   864 pts/0    S+   14:30   0:00 ping 127.0.0.1
vagrant    40184  0.0  0.0   8900   672 pts/3    S+   14:34   0:00 grep --color=auto ping
````
теперь смотрим какие файлы открыты процессом:
```bash
vagrant@vagrant:~$ sudo lsof -l -p 40166
COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
ping    40166     1000  cwd    DIR  253,0     4096 131074 /home/vagrant
ping    40166     1000  rtd    DIR  253,0     4096      2 /
ping    40166     1000  txt    REG  253,0    72776 524524 /usr/bin/ping
ping    40166     1000  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive
ping    40166     1000  mem    REG  253,0   137584 527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0
ping    40166     1000  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
ping    40166     1000  mem    REG  253,0   101320 527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so
ping    40166     1000  mem    REG  253,0  1168056 527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5
ping    40166     1000  mem    REG  253,0    31120 527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32
ping    40166     1000  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
ping    40166     1000    0u   CHR  136,0      0t0      3 /dev/pts/0
ping    40166     1000    1w   REG  253,0     6195 131103 /home/vagrant/ping.log
ping    40166     1000    2u   CHR  136,0      0t0      3 /dev/pts/0
ping    40166     1000    3u  icmp             0t0 577248 00000000:0001->00000000:0000
ping    40166     1000    4u  sock    0,9      0t0 577249 protocol: PINGv6
````
Запоминаем, что файлу ping.log соответствует файловый дискриптор 1 процесса 40166.

Просто посмотрим что пишется в файл:

```bash
vagrant@vagrant:~$ tail ping.log
64 bytes from 127.0.0.1: icmp_seq=591 ttl=64 time=0.055 ms
64 bytes from 127.0.0.1: icmp_seq=592 ttl=64 time=0.068 ms
64 bytes from 127.0.0.1: icmp_seq=593 ttl=64 time=0.061 ms
64 bytes from 127.0.0.1: icmp_seq=594 ttl=64 time=0.048 ms
64 bytes from 127.0.0.1: icmp_seq=595 ttl=64 time=0.050 ms
64 bytes from 127.0.0.1: icmp_seq=596 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=597 ttl=64 time=0.047 ms
64 bytes from 127.0.0.1: icmp_seq=598 ttl=64 time=0.135 ms
64 bytes from 127.0.0.1: icmp_seq=599 ttl=64 time=0.033 ms
64 bytes from 127.0.0.1: icmp_seq=600 ttl=64 time=0.058 ms
vagrant@vagrant:~$
````
Также попоорбуем открыть его через дискриптор:
```bash
vagrant@vagrant:~$ sudo tail /proc/40166/fd/1
64 bytes from 127.0.0.1: icmp_seq=277 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=278 ttl=64 time=0.048 ms
64 bytes from 127.0.0.1: icmp_seq=279 ttl=64 time=0.045 ms
64 bytes from 127.0.0.1: icmp_seq=280 ttl=64 time=0.170 ms
64 bytes from 127.0.0.1: icmp_seq=281 ttl=64 time=0.033 ms
64 bytes from 127.0.0.1: icmp_seq=282 ttl=64 time=0.037 ms
64 bytes from 127.0.0.1: icmp_seq=283 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=284 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=285 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=286 ttl=64 time=0.050 ms
```

Теперь удалим файл и проверим, что просмотреть его по имени уже не возможно:
```bash
vagrant@vagrant:~$ sudo rm -f ping.log
vagrant@vagrant:~$ sudo lsof -l -p 40166
COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
ping    40166     1000  cwd    DIR  253,0     4096 131074 /home/vagrant
ping    40166     1000  rtd    DIR  253,0     4096      2 /
ping    40166     1000  txt    REG  253,0    72776 524524 /usr/bin/ping
ping    40166     1000  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive
ping    40166     1000  mem    REG  253,0   137584 527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0
ping    40166     1000  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
ping    40166     1000  mem    REG  253,0   101320 527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so
ping    40166     1000  mem    REG  253,0  1168056 527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5
ping    40166     1000  mem    REG  253,0    31120 527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32
ping    40166     1000  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
ping    40166     1000    0u   CHR  136,0      0t0      3 /dev/pts/0
ping    40166     1000    1w   REG  253,0    19647 131103 /home/vagrant/ping.log (deleted)
ping    40166     1000    2u   CHR  136,0      0t0      3 /dev/pts/0
ping    40166     1000    3u  icmp             0t0 577248 00000000:0001->00000000:0000
ping    40166     1000    4u  sock    0,9      0t0 577249 protocol: PINGv6

vagrant@vagrant:~$ tail ping.log
tail: cannot open 'ping.log' for reading: No such file or directory
```
Однако через дискриптор видно , что файл растёт:
```bash
vagrant@vagrant:~$ sudo tail /proc/40166/fd/1
64 bytes from 127.0.0.1: icmp_seq=352 ttl=64 time=0.043 ms
64 bytes from 127.0.0.1: icmp_seq=353 ttl=64 time=0.135 ms
64 bytes from 127.0.0.1: icmp_seq=354 ttl=64 time=0.048 ms
64 bytes from 127.0.0.1: icmp_seq=355 ttl=64 time=0.047 ms
64 bytes from 127.0.0.1: icmp_seq=356 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=357 ttl=64 time=0.052 ms
64 bytes from 127.0.0.1: icmp_seq=358 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=359 ttl=64 time=0.058 ms
64 bytes from 127.0.0.1: icmp_seq=360 ttl=64 time=0.050 ms
64 bytes from 127.0.0.1: icmp_seq=361 ttl=64 time=0.050 ms
```
Для обнуления содержимого отправляем туда пустую строку:
```bash
vagrant@vagrant:~$ echo "" | sudo tee /proc/40166/fd/1
```
Смотрим на размер этого несуществующего файла ping.log. и видим, что он обнулился. По сравнению с предыдущим размером сильно меньше. Просто туда уже нападало немножко.
```bash
vagrant@vagrant:~$ sudo lsof -l -p 40166
COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
ping    40166     1000  cwd    DIR  253,0     4096 131074 /home/vagrant
ping    40166     1000  rtd    DIR  253,0     4096      2 /
ping    40166     1000  txt    REG  253,0    72776 524524 /usr/bin/ping
ping    40166     1000  mem    REG  253,0  5699248 535133 /usr/lib/locale/locale-archive
ping    40166     1000  mem    REG  253,0   137584 527268 /usr/lib/x86_64-linux-gnu/libgpg-error.so.0.28.0
ping    40166     1000  mem    REG  253,0  2029224 527432 /usr/lib/x86_64-linux-gnu/libc-2.31.so
ping    40166     1000  mem    REG  253,0   101320 527451 /usr/lib/x86_64-linux-gnu/libresolv-2.31.so
ping    40166     1000  mem    REG  253,0  1168056 527252 /usr/lib/x86_64-linux-gnu/libgcrypt.so.20.2.5
ping    40166     1000  mem    REG  253,0    31120 527208 /usr/lib/x86_64-linux-gnu/libcap.so.2.32
ping    40166     1000  mem    REG  253,0   191472 527389 /usr/lib/x86_64-linux-gnu/ld-2.31.so
ping    40166     1000    0u   CHR  136,0      0t0      3 /dev/pts/0
ping    40166     1000    1w   REG  253,0      355 131103 /home/vagrant/ping.log (deleted)
ping    40166     1000    2u   CHR  136,0      0t0      3 /dev/pts/0
ping    40166     1000    3u  icmp             0t0 577248 00000000:0001->00000000:0000
ping    40166     1000    4u  sock    0,9      0t0 577249 protocol: PINGv6
```
Задача выполнена, мы обнулили удалённый файл.

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Ответ: Так как процесс зомби - это завершившийся процесс, чей код возврата не получен родителем, то значит он уже освободил все ресурсы и висит просто строчкой в списке процессов.

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

Ответ: В Ubuntu под vagrant у меня вообще не получилось запустить opensnoop. Требуется пересборка ядра:

```bash
vagrant@vagrant:~$ opensnoop-bpfcc
modprobe: ERROR: could not insert 'kheaders': Operation not permitted
Unable to find kernel headers. Try rebuilding kernel with CONFIG_IKHEADERS=m (module)
chdir(/lib/modules/5.4.0-80-generic/build): No such file or directory
Traceback (most recent call last):
  File "/usr/sbin/opensnoop-bpfcc", line 180, in <module>
    b = BPF(text=bpf_text)
  File "/usr/lib/python3/dist-packages/bcc/__init__.py", line 347, in __init__
    raise Exception("Failed to compile BPF module %s" % (src_file or "<text>"))
Exception: Failed to compile BPF module <text>
vagrant@vagrant:~$
```
Поэтому я попытался сделать это на Alma Linux. А там ситуация такая. После запуска выдаёт сначала всякие варнинги, но потом делает вид, что работает. Но при этом если просто ждать и ничего не делать то не показывает ничего, пока в пользовательском терминале не начинается активность. То есть системные вызовы от самой системы не показывает, а реагирует только на активность пользователя.

Поэтому я привожу то, что появилось в результате выполнения команды от пользователя. Например `cat /etc/passwd` :
```bash
[root@DevOpser devops-netology]# /usr/share/bcc/tools/opensnoop
In file included from <built-in>:2:
In file included from /virtual/include/bcc/bpf.h:12:
In file included from include/linux/types.h:6:
In file included from include/uapi/linux/types.h:14:
In file included from include/uapi/linux/posix_types.h:5:
In file included from include/linux/stddef.h:5:
In file included from include/uapi/linux/stddef.h:2:
In file included from include/linux/compiler_types.h:74:
include/linux/compiler-clang.h:25:9: warning: '__no_sanitize_address' macro redefined [-Wmacro-redefined]
#define __no_sanitize_address
        ^
include/linux/compiler-gcc.h:213:9: note: previous definition is here
#define __no_sanitize_address __attribute__((no_sanitize_address))
        ^
1 warning generated.
In file included from <built-in>:2:
In file included from /virtual/include/bcc/bpf.h:12:
In file included from include/linux/types.h:6:
In file included from include/uapi/linux/types.h:14:
In file included from include/uapi/linux/posix_types.h:5:
In file included from include/linux/stddef.h:5:
In file included from include/uapi/linux/stddef.h:2:
In file included from include/linux/compiler_types.h:74:
include/linux/compiler-clang.h:25:9: warning: '__no_sanitize_address' macro redefined [-Wmacro-redefined]
#define __no_sanitize_address
        ^
include/linux/compiler-gcc.h:213:9: note: previous definition is here
#define __no_sanitize_address __attribute__((no_sanitize_address))
        ^
1 warning generated.
PID    COMM               FD ERR PATH
7325   bash                6   0 /
7325   bash                6   0 /etc/
36579  cat                 3   0 /etc/ld.so.cache
36579  cat                 3   0 /lib64/libc.so.6
36579  cat                 3   0 /usr/lib/locale/locale-archive
36579  cat                 3   0 /etc/passwd
```
Ничего более интересного предложить не могу, так как этот сторонний софт нормально не работает. Прошу зачесть мне это задание.

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

Ответ: При выполнении `uname -a` используется системный вызов uname({......}).  
Цитата из `man 2 uname` : 

```
Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version,
domainname}.
```

7. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
```bash
root@netology1:~# test -d /tmp/some_dir; echo Hi
Hi
root@netology1:~# test -d /tmp/some_dir && echo Hi
root@netology1:~#
```

Есть ли смысл использовать в bash `&&`, если применить `set -e`?

Ответ: Если между командами стоит ; , то вторая команда выполняется в любом случае, а если && то вторая команда запустится если первая завершится успешно, то есть вернёт код ошибки = 0;
в приведённом примере видимо отсутствовала директория /tmp/some_dir , поэтому echo не выполнялась.
На сколько я понимаю при использовании `set -e` bash прервёт исполнение после первой же команды с кодом ошибки <>0 , но так как у нас с помощью && делается составная команда, то остановка не произойдёт на одной из её частей. Будет иметь значение общий возврат составной команды. Так что есть смысл использовать.

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

Ответ: Да, такой набор ключей bash хорошо использовать в сценариях, тогда ни одна ошибка не останется не замеченной.

-e -прерывает выполнение сценария после первой-же ошибки  любой команды
-u -прерывает работу в случае обращения к неопределённой переменной
-x -все выполненные команды выводятся на терминал, что удобно для отладки
-o pipefail - делает так, что код завершения последовательности (пайп | ) команд , будет не код завершения последней команды, а код завершения команды, выдавшей код ошибки <>0 .

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

Ответ: 

```bash
vagrant@vagrant:~$ ps -Ao stat | grep R | wc -l
2
vagrant@vagrant:~$ ps -Ao stat | grep I | wc -l
55
vagrant@vagrant:~$ ps -Ao stat | grep S | wc -l
78
```

из `man ps` мы знаем, что:
```
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display
       to describe the state of a process:

               D    uninterruptible sleep (usually IO)    Непрерываемый сон
               I    Idle kernel thread          Бездействие
               R    running or runnable (on run queue)   Исполняющийся
               S    interruptible sleep (waiting for an event to complete)  Прерываемый сон
               T    stopped by job control signal    Остановленный 
               t    stopped by debugger during the tracing   Остановленный в режиме трассировки
               W    paging (not valid since the 2.6.xx kernel)    
               X    dead (should never be seen)   Врят-ли встретишь :) Мертвяк
               Z    defunct ("zombie") process, terminated but not reaped by its parent  Зомби
```
Получается, что в основном все процессы находятс в состоянии Прерываемого сна, то есть ждут какое-нибудь событие для завершения.

Дополнительные строчные бкувы и символы означают:

```
<    high-priority (not nice to other users) Высокий приоретет
N    low-priority (nice to other users) Низкий приоретет
L    has pages locked into memory (for real-time and custom IO)
s    is a session leader     Главный процесс в своей сессии
l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)  Многопоточный
+    is in the foreground process group  Не фоновый
```

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
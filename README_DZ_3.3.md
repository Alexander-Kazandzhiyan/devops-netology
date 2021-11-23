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

Ответ: Если мы запустили приложение с strace то смотрим листинг, ищем, место где открывался файл opennat и смотрим, номер файлового дискриптора. Когда файл был удалён. то дискриптор-то у приложения остался и оно по нему и пишет. Мы должны сделать `echo > файл.дикр` . Содержимое файла обнулится.

4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Ответ: Так как процесс зомби - это завершившийся процесс, чей код возврата не получен родителем, то значит он уже освободил все ресурсы и висит просто строчкой в списке процессов.

5. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

Ответ: Никакие не показывает пока я не начинаю хоть что-то делать в другом терминале. Тогда начинаются данные. Например `cat /etc/passwd` (правда что-то не то с самим opensnoop, но наверное это не важно.):
```
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
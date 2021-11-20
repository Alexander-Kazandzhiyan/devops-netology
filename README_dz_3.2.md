# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

Ответ: cd  - встроенная команда Shell. Я считаю, что это одна из основных комманд, без которых в системе делать нечего, поэтому её встроили, а не сделали отдельным приложением. Кроме того, если бы она была отдельным приложением и располагалась в некой папке, то как её запускать если в эту папку надо перейти с помощью этой самой команды? Это как инструкция по сборке видеомагнитофона, прилагающаяся на видеокассете к деталям видеомагнитофона. 

Проверяем:

     ```bash
    vagrant@vagrant:~$ type -a cd
    cd is a shell builtin
    ```
   
2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

Ответ: 
Команда подсчитывает количество вхождений подстроки в файле:
```bash
[root@DevOpser devops-netology]# grep "что" README_dz_2.4.md | wc -l                            
5
```
Альтернативой может служить:
```bash
[root@DevOpser devops-netology]# grep -с "что" README_dz_2.4.md                            
5
```

3. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

Ответ: systemd

4. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

Ответ:
Проверяем в обоих сессиях номер терминала. В той , где pts0 выполняем команду:

```bash
[root@DevOpser devops-netology]# who am i
root     pts/0        2021-11-17 08:31 (10.20.8.7)
[root@DevOpser devops-netology]# ls 2> /dev/pts/1
```

если запустить эту же команду, но добавить к ls какие-нибудь неправильные ключи то ошибка выводится на другом терминале. То есть работает.

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

Ответ: Я даже удивился. Думал, что раз такой вопрос, то наверное будет какой-то косяк, но это работает:

```bash
[root@DevOpser git]# cat < README_dz_2.4.md > test
```
в файле test появилось содержимое файла README_dz_2.4.md

6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

Ответ: Да, получится. 

7. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

Ответ: Мы создали файловый дискриптор 5, направленный на стандартный вывод. Поэтому, когда мы пытаемся сделать запись в этот фд, то данные выводятся на стандартный вывод.

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

Ответ: Я понял задачу так. Сделать передачу через Пайп только stderr, но при этом наблюдать, что выдалось в stdout.
В целом получилось.

Вызываем команду для вывода содержимого существующей и не существующей папки:
```Bash

vagrant@vagrant:~$ ls -la dir-exist dir-not
ls: cannot access 'dir-not': No such file or directory
dir-exist:
total 8
drwxrwxr-x 2 vagrant vagrant 4096 Nov 18 22:05 .
drwxr-xr-x 6 vagrant vagrant 4096 Nov 19 08:45 ..
```
Видим, что она вывела ошибку, а затем содержимое существующей папки.  Теперь мы понимаем, что должно передаваться в stderror, а что в stdout.

Теперь попробуем передать в пайп вывод этой команды и вывести строки с буквой N 
```Bash
    vagrant@vagrant:~$ ls -la dir-exist dir-not | grep N
    ls: cannot access 'dir-not': No such file or directory
    drwxrwxr-x 2 vagrant vagrant 4096 Nov 18 22:05 .
    drwxr-xr-x 6 vagrant vagrant 4096 Nov 18 22:03 ..
    -rw-rw-r-- 1 vagrant vagrant    0 Nov 18 22:05 file-exist
```

Видим, что в пайп ушёл весь вывод и stdout и stderr. То есть в пайп отправить только stderr пока не представляется возможным.

Теперь сделаем, чтоб stderr выдавался на текущий терминал, а stdout на другой терминал.
   
```bash
    vagrant@vagrant:~$  bash 5>&1 2>&5 1>/dev/pts/1
```
    
Выполняем команду:

```bash
    vagrant@vagrant:~$ ls -la dir-exist dir-not | grep N
    ls: cannot access 'dir-not': No such file or directory
```
А на втором терминале отобразилось только это:

```bash
    drwxrwxr-x 2 vagrant vagrant 4096 Nov 18 22:05 .
    drwxr-xr-x 6 vagrant vagrant 4096 Nov 19 08:45 ..
    -rw-rw-r-- 1 vagrant vagrant    0 Nov 18 22:05 file-exist
```

Коментарий: Я плохо понял задание. Кроме того в свмом вопросе явнвя ошибка: "Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа" - это ложь. Легко можно доказать.
Вот доказательство. На вход команды grep попал от команды ls не только stduot, но и stderr в котором тоже нашлась буква N.
```bash
    vagrant@vagrant:~$ ls -la dir-exist dir-not | grep N
    ls: cannot access 'dir-not': No such file or directory
    drwxrwxr-x 2 vagrant vagrant 4096 Nov 18 22:05 .
    drwxr-xr-x 6 vagrant vagrant 4096 Nov 19 08:45 ..
    -rw-rw-r-- 1 vagrant vagrant    0 Nov 18 22:05 file-exist
````

9. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?

Ответ: Эта команда выводит переменные окружения. Аналогичный вывод можно получить введя команду env. Надо всё-же отметить, что в выводе из "виртуального файла" мы получаем несколько дополнительных переменных (PWD=/home/vagrant ;
    LESSCLOSE=/usr/bin/lesspipe %s %s ;   LESSOPEN=| /usr/bin/lesspipe %s), но это видимо либо из-за того, что env выводит только "правильные" переменные, либо связано с особенностями вывода с помощью cat.

10. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

Ответ: 
Усли вызвать на просмотр виртуальный файл `cat /proc/<PID>/cmdline` то мы увидим какой командной строкой вызывался процесс с указанным PID с указанием ключей.
Виртуальный файл `cat /proc/<PID>/exe` является символической ссылкой на конкретный запускаемый файл, который породил процесс с указанным PID.

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

Ответ:

```bash
[root@DevOpser git]# cat /proc/cpuinfo | grep sse
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss syscall nx rdtscp lm constant_tsc arch_perfmon nopl xtopology tsc_reliable nonstop_tsc cpuid pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm cpuid_fault pti ssbd ibrs ibpb stibp fsgsbase tsc_adjust smep arat md_clear flush_l1d arch_capabilities
```
Судя по всему 4_2, это наверное версия 4.2

12. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

     ```bash
     vagrant@netology1:~$ ssh localhost 'tty'
     not a tty
     ```

     Почитайте, почему так происходит, и как изменить поведение.

Ответ: так происходит потому, что ssh соединение делается без создания терминала, просто для удалённого выполнения команды. А чтобы создался терминал, нужно использовать ключ `-t`.

   ```bash
        vagrant@vagrant:~$ ssh localhost 'tty'
        vagrant@localhost's password:
        not a tty
        vagrant@vagrant:~$
        vagrant@vagrant:~$ ssh -t localhost 'tty'
        vagrant@localhost's password:
        /dev/pts/1
        Connection to localhost closed.
   ```

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.

Ответ: В целом получилось. Но далеко не сразу.

   ```bash    
    vagrant@vagrant:~$ echo 0 > /proc/sys/kernel/yama/ptrace_scope
    echo 0 > /proc/sys/kernel/yama/ptrace_scope
    bash: /proc/sys/kernel/yama/ptrace_scope: Permission denied
    vagrant@vagrant:~$ echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    0
    vagrant@vagrant:~$
    vagrant@vagrant:~$ top
    
    top - 08:03:34 up 1 day, 10:50,  3 users,  load average: 0.00, 0.00, 0.00
    Tasks: 127 total,   1 running, 126 sleeping,   0 stopped,   0 zombie
    %Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    MiB Mem :   1987.1 total,   1575.2 free,    136.1 used,    275.8 buff/cache
    MiB Swap:    980.0 total,    980.0 free,      0.0 used.   1693.8 avail Mem
    
        PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
       2641 vagrant   20   0   11868   3880   3304 R   0.3   0.2   0:00.02 top
          1 root      20   0  167348  11452   8484 S   0.0   0.6   0:04.75 systemd
          2 root      20   0       0      0      0 S   0.0   0.0   0:00.02 kthreadd
    
    ^z
    [1]+  Stopped                 top
    vagrant@vagrant:~$
    vagrant@vagrant:~$ ps -aux | grep top
    vagrant     2641  0.0  0.1  11868  3880 pts/0    T    08:03   0:00 top
    vagrant     2644  0.0  0.0   8900   672 pts/0    R+   08:04   0:00 grep --color=auto top
    vagrant@vagrant:~$
   ```

В другом терминале:

   ```bash
    screen
    vagrant@vagrant:~$ who am i
    vagrant  pts/2        2021-11-20 08:02 (:pts/1:S.0)
    vagrant@vagrant:~$
   ```

Т.е. мы в терминале Скрина. Теперь получаем доступ к процессу:

   ```bash
    vagrant@vagrant:~$ reptyr 2641
    
    top - 08:07:05 up 1 day, 10:54,  3 users,  load average: 0.00, 0.00, 0.00
    Tasks: 129 total,   1 running, 127 sleeping,   0 stopped,   1 zombie
    %Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
    MiB Mem :   1987.1 total,   1574.6 free,    136.6 used,    275.9 buff/cache
    MiB Swap:    980.0 total,    980.0 free,      0.0 used.   1693.3 avail Mem
    
        PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
       2646 vagrant   20   0    2592   1904   1804 S   4.9   0.1   0:00.17 reptyr
          1 root      20   0  167348  11452   8484 S   0.0   0.6   0:04.75 systemd
          2 root      20   0       0      0      0 S   0.0   0.0   0:00.02 kthreadd
      3 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 rcu_gp

   ```


14. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.

Ответ: Действительно второй вариант с tee работает. Команда tee копирует стандартный ввод в стандартный вывод и в файлы. Работает такой вариант потому, что команда tee запущена с правами рута, поэтому она может писать в файл в рутовой папке. А команде echo не нужно sudo так как она выполняется под нашим юзером и просто выводит строку в стандартный ввод команды tee.


 
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
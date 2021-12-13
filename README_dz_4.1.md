# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательные задания

1. Есть скрипт:
	```bash
	a=1
	b=2
	c=a+b
	d=$a+$b
	e=$(($a+$b))
	```
	* Какие значения переменным c,d,e будут присвоены?
	* Почему?

Ответ: Видоизменим скрипт, добавив эхо-печать.

```bash
#!/usr/bin/env bash
a=1
b=2
echo "a= " $a
echo "b= " $b

c=a+b
echo "c=a+b= " $c

d=$a+$b
echo "d=\$a+\$b= " $d

e=$(($a+$b))
echo "e=\$((\$a+\$b))= " $e
```
Результат выполнения:
```bash
[root@DevOpser temp]# sh dz_4.1_script-1.sh 
a=  1
b=  2
c=a+b=  a+b
d=$a+$b=  1+2
e=$(($a+$b))=  3
```
Переменным a и b присваиваются значения символьных строк "1" и "2". Переменной с присваивается значение - строка, состоящая из букв a и b и символа + между ними. Переменной d присваивается значение сложения значений строковых переменных a и b. Переменной e приваивается математическая сумма значений переменных, приведённых к целочисленному типу. 

2. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
    ```bash
    while ((1==1)
    do
    curl https://localhost:4757
    if (($? != 0))
    then
    date >> curl.log
    fi
    done
    ```
Ответ: Скрипт был мной модифицирован:
```bash
#!/usr/bin/env bash

while ((1 == 1))
do
        curl http://10.20.8.77:9100 1>>/dev/null 2>>/dev/null
        if (($? != 0))
        then
            echo `date` Service not working now... waiting >> curl.log
            sleep 2
        else 
            echo `date` Service is working now! Stop monitoring. >> curl.log
            exit
        fi
done
```

Пояснения:

Проверять будем локально доступный веб-интерфейс node_exporter, но он слушает не на localhost, а на нормальном интерфейсе этой машинки. 
Вывод команды curl направлен в null, а также вывод ошибок тоже направлен в null, чтоб на экран не сыпались всякие глупости :)

Писать сообщения с датой будем пока в файл лога так, чтобы было понятно, что происходило. Затем, для экономии места на диске можно `>> curl.log` заменить на `> curl.log`. Тогда в логе всегда будет только одна последняя строка. Видимо в этом был смысл задания. Но так как в этом случае лог будет не наглядный, то пока оставлю так.

Пример Вывода Скрипта: Привожу лог до окончания работы скрипта в момент запуска тестируемого сервиса:

```bash
cat curl.log
Tue Dec 14 00:04:49 MSK 2021 Service not working now... waiting
Tue Dec 14 00:04:51 MSK 2021 Service not working now... waiting
Tue Dec 14 00:04:53 MSK 2021 Service not working now... waiting
Tue Dec 14 00:04:55 MSK 2021 Service not working now... waiting
Tue Dec 14 00:04:57 MSK 2021 Service not working now... waiting
Tue Dec 14 00:04:59 MSK 2021 Service not working now... waiting
Tue Dec 14 00:05:01 MSK 2021 Service not working now... waiting
Tue Dec 14 00:05:03 MSK 2021 Service is working now! Stop monitoring.
```

3. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.

Ответ: Был создан скрипт
```bash
[root@DevOpser temp]# cat dz_4.1_script-3.sh 
#!/usr/bin/env bash

# задаём список (массив) узлов
Hosts_list=("10.20.8.77" "194.190.8.200" "mail.ru")

# Тест выполняем 5 раз
for i in {1..5}
do
    echo Test \#$i >> testweb.log
# Выполняем проверку для каждого хоста
    for Host in ${Hosts_list[@]}
    do
# формируем ссылку
        link=http://$Host:80
# Пытаемся открыть ссылку, отправляя вывод и ошибки в null
        curl $link 1>>/dev/null 2>>/dev/null
# Проверяем код возврата
        if (($? == 0))
        then
            echo Host $Host is reachable >> testweb.log
        else 
            echo Host $Host is Unreachable >> testweb.log
        fi
        sleep 1
    done
    sleep 1
done
```
Запускаем и через какое-то время гасим апач на эой же самой машинке (10.20.8.77). В логе видно, что хост стал не достижим.
```bash
[root@DevOpser temp]# cat testweb.log
Test #1
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #2
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #3
Host 10.20.8.77 is Unreachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #4
Host 10.20.8.77 is Unreachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #5
Host 10.20.8.77 is Unreachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
```

4. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается

Ответ: Видоизменим скрипт:
```bash
[root@DevOpser temp]# cat dz_4.1_script-4.sh 
#!/usr/bin/env bash
Hosts_list=("10.20.8.77" "194.190.8.200" "mail.ru")
i=0

while ((1 == 1))
let "i+=1"
do
    echo Test \#$i >> testweb.log

    for Host in ${Hosts_list[@]}
    do
        link=http://$Host:80
        curl $link 1>>/dev/null 2>>/dev/null

        if (($? == 0))
        then
            echo Host $Host is reachable >> testweb.log
        else 
            echo Host $Host is Unreachable >> testweb.log
            echo Host $Host is Unreachable >> testweb_errors.log
            exit
        fi
        sleep 1
    done
    sleep 1
done
```
Запускаем скрипт и через некоторое время гасим апач на 10.20.8.77. 

testweb.log
```bash
[root@DevOpser temp]# # cat testweb.log
Test #1
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #2
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #3
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #4
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #5
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #6
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #7
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #8
Host 10.20.8.77 is reachable
Host 194.190.8.200 is reachable
Host mail.ru is reachable
Test #9
Host 10.20.8.77 is Unreachable
```

testweb_errors.log
```bash
[root@DevOpser temp]# cat testweb_errors.log 
Host 10.20.8.77 is Unreachable
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Мы хотим, чтобы у нас были красивые сообщения для коммитов в репозиторий. Для этого нужно написать локальный хук для git, который будет проверять, что сообщение в коммите содержит код текущего задания в квадратных скобках и количество символов в сообщении не превышает 30. Пример сообщения: \[04-script-01-bash\] сломал хук.


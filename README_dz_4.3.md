### Как сдавать задания

Вы уже изучили блок «Системы управления версиями», и начиная с этого занятия все ваши работы будут приниматься ссылками на .md-файлы, размещённые в вашем публичном репозитории.

Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-03-yaml/README.md). Заполните недостающие части документа решением задач (заменяйте `???`, ОСТАЛЬНОЕ В ШАБЛОНЕ НЕ ТРОГАЙТЕ чтобы не сломать форматирование текста, подсветку синтаксиса и прочее, иначе можно отправиться на доработку) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желани.

# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"


## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Ответ: Не хватает запятой между элементами массива и 3-х двойных кавычек. Добавляем:

```json
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
    }
```

## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

Ответ: для интереса список сервисов будем хранить ф файле yaml:

```yaml
[root@DevOpser temp]# cat web-services.yaml 
---
# Веб-сервисы для обработки скриптом
- drive.google.com
- mail.google.com
- google.com
...
```


### Ваш скрипт:
Комментарий: Надеюсь, я правильно понял задание. Что надо размещать данные по сервисам и их адресам в результирующих файлах не скидывая туда просто Словарь, содержащий результаты, а делать построчный вывод. Каждый сервис на своей строке. (Хотя кажется, что это нарушение формата json) Поэтому, пришлось поколдовать при выводе. Чтобы сделать текст программы более структурированным я попробовал сделать две функции.

```python
#!/usr/bin/env python3

import socket
import datetime
import time
import yaml
import json

# Создаём функцию, которая записывает в json файл значения { "имя сервиса" : "его IP"} по одному в строке
def write_host_ip_oneonline_to_json(host_ip_dict):
    with open("Current_webservices_resolving.json", 'w') as jsfile:
        for hostname in host_ip_dict:
            host_ip_1 = {}
            host_ip_1[hostname] = host_ip_dict[hostname]
            jsfile.write(json.dumps(host_ip_1)+'\n')

# Создаём функцию, которая записывает в yaml файл значения      - имя сервиса: его IP        по одному в строке
def write_host_ip_oneonline_to_yaml(host_ip_dict):
    # создаём список, в который будем помещать элементы словаря, чтобы при выводе его в yaml у нас появились дефисы
    host_ip_list=[]
    with open("Current_webservices_resolving.yaml", 'w') as ymfile:
        for hostname in host_ip_dict:
            host_ip_1 = {}
            host_ip_1[hostname] = host_ip_dict[hostname]
            host_ip_list.append(host_ip_1)
        ymfile.write(yaml.dump(host_ip_list, default_flow_style=False, explicit_start=True, explicit_end=True))


#Считываем список веб-сервисов. Для интереса, будем хранить его в файле yaml
with open('/temp/web-services.yaml', 'r') as config_file:
    hostnames = yaml.safe_load(config_file)

# Создаём основной словарь для хранения данных об узле такого вида {Имя_Узла:[старый_ip, текущий_ip]}
db_host_ip = {}

print("Имена Веб-сервисов, считанных из файла конфига :")
for host in hostnames:
    print (host)

print("\nЗаполняем структуру словаря хранения узлов ...")
for host in hostnames:
    db_host_ip[host] = ""

print(db_host_ip)

# далее в программе hostname - это будет переменная, содержащая значение ключа словаря db_host_ip (а в ключе у нас имена веб-сервисов)

print("\nНачальные адреса определены:")
for hostname in db_host_ip:
    db_host_ip[hostname] = socket.gethostbyname(hostname)

print(db_host_ip)

# передаём словарь host_ip в функции записи файлы JSON и YAML  по одному хосту в строке
write_host_ip_oneonline_to_json(db_host_ip)
write_host_ip_oneonline_to_yaml(db_host_ip)

print("\nНачинаем отслеживание изменений в резолвинге ДНС адресов сервисов:")

while (True):
    for hostname in db_host_ip:
# для каждого хоста из словоря проеряем текущий ip адрес
        current_ip = socket.gethostbyname(hostname)
        if (db_host_ip[hostname] != current_ip):
# если текущий ip на данный момент не равен старому ip, бывшему при прошлой проверке, то выводим сообщение и обновляем значение адреса в словаре 
            now = datetime.datetime.now()
            print(str(now)," [ERROR] ",hostname," IP mismatch: ",db_host_ip[hostname]," ",current_ip)
            db_host_ip[hostname] = current_ip

            write_host_ip_oneonline_to_json(db_host_ip)
    time.sleep(3)
```

### Вывод скрипта при запуске при тестировании:
```bash
[root@DevOpser temp]# ./dz_4.3_script-2.1.sh
Имена Веб-сервисов, считанных из файла конфига :
drive.google.com
mail.google.com
google.com

Заполняем структуру словаря хранения узлов ...
{'drive.google.com': '', 'mail.google.com': '', 'google.com': ''}

Начальные адреса определены:
{'drive.google.com': '142.250.186.142', 'mail.google.com': '142.250.185.197', 'google.com': '142.250.186.46'}

Начинаем отслеживание изменений в резолвинге ДНС адресов сервисов:
2021-12-19 14:40:38.363430  [ERROR]  google.com  IP mismatch:  142.250.186.46   142.250.185.174
2021-12-19 14:40:41.531035  [ERROR]  google.com  IP mismatch:  142.250.185.174   142.250.186.46
2021-12-19 14:47:00.797765  [ERROR]  google.com  IP mismatch:  142.250.186.46   142.250.185.174
2021-12-19 14:47:03.967364  [ERROR]  google.com  IP mismatch:  142.250.185.174   142.250.186.46
2021-12-19 14:47:13.457698  [ERROR]  google.com  IP mismatch:  142.250.186.46   142.250.185.174
2021-12-19 14:47:16.613793  [ERROR]  google.com  IP mismatch:  142.250.185.174   142.250.186.46
2021-12-19 14:47:45.056789  [ERROR]  google.com  IP mismatch:  142.250.186.46   142.250.74.206
2021-12-19 14:47:54.562302  [ERROR]  google.com  IP mismatch:  142.250.74.206   142.250.186.46
2021-12-19 14:48:07.222377  [ERROR]  google.com  IP mismatch:  142.250.186.46   142.250.74.206
2021-12-19 14:48:38.857981  [ERROR]  google.com  IP mismatch:  142.250.74.206   142.250.186.46
2021-12-19 14:48:42.026190  [ERROR]  google.com  IP mismatch:  142.250.186.46   142.250.74.206
2021-12-19 14:59:11.110688  [ERROR]  google.com  IP mismatch:  142.250.74.206   142.250.185.174
2021-12-19 14:59:17.445803  [ERROR]  google.com  IP mismatch:  142.250.185.174   142.250.74.206
2021-12-19 15:00:42.786098  [ERROR]  google.com  IP mismatch:  142.250.185.174   142.250.74.206
2021-12-19 15:00:58.581657  [ERROR]  google.com  IP mismatch:  142.250.74.206   142.250.185.174
2021-12-19 15:01:04.898875  [ERROR]  google.com  IP mismatch:  142.250.185.174   142.250.74.206
2021-12-19 15:01:11.166043  [ERROR]  mail.google.com  IP mismatch:  142.250.185.197   142.250.185.165
2021-12-19 15:01:14.327590  [ERROR]  mail.google.com  IP mismatch:  142.250.185.165   142.250.185.197
2021-12-19 15:01:17.537652  [ERROR]  google.com  IP mismatch:  142.250.74.206   142.250.185.174
2021-12-19 15:01:20.693671  [ERROR]  google.com  IP mismatch:  142.250.185.174   142.250.74.206
```

### json-файл(ы), который(е) записал ваш скрипт:
`[root@DevOpser temp]# cat Current_webservices_resolving.json`
```json
{"drive.google.com": "142.250.186.142"}
{"mail.google.com": "142.250.185.197"}
{"google.com": "142.250.74.206"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
`[root@DevOpser temp]# cat Current_webservices_resolving.yaml`
```yaml
---
- drive.google.com: 142.250.186.142
- mail.google.com: 142.250.185.197
- google.com: 142.250.186.46
...
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
???
```

### Пример работы скрипта:
???
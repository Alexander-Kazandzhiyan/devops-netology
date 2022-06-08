# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  


1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.   
1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя? 
    
## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   

---
## Выполнение
## Задача 1. 
Давайте потренируемся читать исходный код AWS провайдера, который можно склонировать от сюда: 
[https://github.com/hashicorp/terraform-provider-aws.git](https://github.com/hashicorp/terraform-provider-aws.git).
Просто найдите нужные ресурсы в исходном коде и ответы на вопросы станут понятны.  

1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.

Склонировал себе репозиторий:
```bash
user1@devopserubuntu:~/git-terraform-aws-provider$ git clone https://github.com/hashicorp/terraform-provider-aws.git
Cloning into 'terraform-provider-aws'...
remote: Enumerating objects: 375537, done.
remote: Counting objects: 100% (53/53), done.
remote: Compressing objects: 100% (36/36), done.
remote: Total 375537 (delta 26), reused 39 (delta 17), pack-reused 375484
Receiving objects: 100% (375537/375537), 362.28 MiB | 2.82 MiB/s, done.
Resolving deltas: 100% (267627/267627), done.
Updating files: 100% (9406/9406), done.
```
В файле `/home/user1/git-terraform-aws-provider/terraform-provider-aws/internal/provider/provider.go`, как и ожидалось после прослушивания лекции, нашлись описания всех возможных ресурсов и дата-сорсов.

Вот ссылка на объявление перечня ресурсов:
https://github.com/hashicorp/terraform-provider-aws/blob/19d5b4c0d336170d1969a315c443aefd040521ca/internal/provider/provider.go#L901
А вот с этой строки начинаеся перечень источников данных:
https://github.com/hashicorp/terraform-provider-aws/blob/19d5b4c0d336170d1969a315c443aefd040521ca/internal/provider/provider.go#L422


2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.
    * Какая максимальная длина имени? 
    * Какому регулярному выражению должно подчиняться имя?

Поищем, где описан такой ресурс:
```bash
user1@devopserubuntu:~/git-terraform-aws-provider/terraform-provider-aws/internal/provider$ cat provider.go | grep aws_sqs_queue
                        "aws_sqs_queue": sqs.DataSourceQueue(),
                        "aws_sqs_queue":        sqs.ResourceQueue(),
                        "aws_sqs_queue_policy": sqs.ResourceQueuePolicy(),
```
Видим `sqs.ResourceQueue()`. Теперь надо найти его описание.
Судя по всему оно находится в папке https://github.com/hashicorp/terraform-provider-aws/tree/19d5b4c0d336170d1969a315c443aefd040521ca/internal/service/sqs
Действительно в этой папке находится описание (объявление) `ResourceQueue`. В файле `queue.go` мы видим описание параметра `name`.
```bash
"name": {
                        Type:          schema.TypeString,
                        Optional:      true,
                        Computed:      true,
                        ForceNew:      true,
                        ConflictsWith: []string{"name_prefix"},
                },
```
Вот тут указано, что `name` конфликтует с параметром `name_prefix`.
https://github.com/hashicorp/terraform-provider-aws/blob/19d5b4c0d336170d1969a315c443aefd040521ca/internal/service/sqs/queue.go#L87

На максимальную длинну имени накладывается ограничение так-же, как и на его состав. Это делается регулярными выражениями:
```bash
                var re *regexp.Regexp

                if fifoQueue {
                        re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,75}\.fifo$`)
                } else {
                        re = regexp.MustCompile(`^[a-zA-Z0-9_-]{1,80}$`)
                }

                if !re.MatchString(name) {
                        return fmt.Errorf("invalid queue name: %s", name)
                }
```
вот тут это место в коде:
https://github.com/hashicorp/terraform-provider-aws/blob/a01c30d32eb999157faaf73856b0ae0553b98bc9/internal/service/sqs/queue.go#L424

Этот кусок кода определяет есть ли в имени `name` ошибка, то есть не соответствие формату. А именно: Имя должно состоять из латинских букв и цифр и знаков подчёркивание и тире и содержать либо до 80 символов либо 75 символов + `.fifo` на конце.

---
1. Установите средство виртуализации Oracle VirtualBox.

Ответ: Выполнено. 
Но уже в самом конце после выполнения всех пунктов, начиная с 8. Делал все задания на ВМ Alma Linux на ESXi, так как VBox не хотел работать без VT-X на моём виртуальном Windows Server. Позже эту проблему удалось победить и он заработал.

2. Установите средство автоматизации Hashicorp Vagrant.

Ответ: Выполнено.

3. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.

Ответ: Использую SecereCRT

4. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:
- Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните vagrant init. Замените содержимое Vagrantfile по умолчанию следующим:
 Vagrant.configure("2") do |config|
     config.vm.box = "bento/ubuntu-20.04"
 end
- Выполнение в этой директории vagrant up установит провайдер VirtualBox для Vagrant, скачает необходимый образ и запустит виртуальную машину.
- vagrant suspend выключит виртуальную машину с сохранением ее состояния (т.е., при следующем vagrant up будут запущены все процессы внутри, которые работали на момент вызова suspend), vagrant halt выключит виртуальную машину штатным образом.

Ответ: Выполнено

5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

Ответ: VCPU:2 RAM: 1Gb hdd:64Gb

6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

Ответ: Увеличиваем CPU / RAM:

    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
            config.vm.provider "virtualbox" do |v|
                v.memory = 2048
                v.cpus = 4
            end
        end

Получилось.

7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.
Ответ: Получилось зайти внутрь ВМ.

`

    PS E:\vagrant> vagrant ssh
    Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-80-generic x86_64)
    
      Documentation:  https://help.ubuntu.com
      Management:     https://landscape.canonical.com
      Support:        https://ubuntu.com/advantage
    
      System information as of Mon 15 Nov 2021 06:45:51 AM UTC
    
      System load:  0.13              Processes:             139
      Usage of /:   2.4% of 61.31GB   Users logged in:       0
      Memory usage: 7%                IPv4 address for eth0: 10.0.2.15
      Swap usage:   0%
    
    
    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento
    vagrant@vagrant: $ uname -a
    Linux vagrant 5.4.0-80-generic #90-Ubuntu SMP Fri Jul 9 22:49:44 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
    vagrant@vagrant: $`
    
8. Ознакомиться с разделами man bash, почитать о настройках самого bash:
1) какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?
2) что делает директива ignoreboth в bash?

Ответ:
1) Размер списка истории команд (history), задаётся переменной окружения HISTSIZE. Это описано на строке 656 man (AlmaLinux)
2) ignoreboth - это одно из возможных значений для параметра HISTCONTROL для настройки History (истории команд), которое одновременно заменяет 2 настройки:
 ignorespace - не записывать в историю строки начинающиеся с пробела
 ignoredups - не записывать в историю команды (строки), которые в истории уже есть.
Придумано для упрощения настроек.

9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?

Ответ:  Интересно, изначально я дал такой ответ:

в {} помещают список комманд, которые должны выполняться последовательно не зависимо от того, как завершается любая из них. Никакие результаты не передаются из одной команды в другую. При этом в отличии от списка заключённого в () запуск команд осуществляется в текущем сеансе Shell, а не в подсеансе.
Это описано на строке 211 man (AlmaLinux)

Но при выполнении п. 10 обнаружилось ещё одно использование фигурных скобок. Они используются для подстановки последовательности значений. Command {start..end..inc} в результате команде будут передано множество значений от нач до конечного с инкрементом.  
Это описано на строке 831 man (AlmaLinux)

10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

Ответ:
 100000 файлов создаём командой
 `touch file{000001..100000..1}`
 в команду touch передаётся сформированный список имён файлов, полученный при раскрытии скобок с перечислением.
 
300000 файлов таким образом создать не удаётся так как стока аргументов получается слишком длинной и превышает системные ограничения: 

` touch file{000001..300000..1} 
-bash: /usr/bin/touch: Argument list too long `

11. В man bash поищите по /\[\[. Что делает конструкция `[[ -d /tmp ]]`

Ответ: `[[ -d /tmp ]]` - это конструкция для проверки условия, что существует папка /tmp . Принимает значение Правда/Ложь

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:
`
   

    bash is /tmp/new_path_directory/bash          
    bash is /usr/local/bin/bash                 
    bash is /bin/bash

`
(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

Ответ: 
Так как были косячки в процессе скриншоты выкладывать не буду.
Комманды:

    # cd /tmp
    # mkdir new_path_directory
    # cp /bin/bash /tmp/new_path_directory
    # cp /bin/bash /usr/local/bin
    # PATH="/tmp/new_path_directory:"$PATH
    # type -a bash      
    bash is /tmp/new_path_directory/bash
    bash is /usr/local/bin/bash
    bash is /bin/bash
    bash is /usr/bin/bash

13. Чем отличается планирование команд с помощью batch и at?

Ответ: На сколько я понял из man, at выполняет задание в указанное время не смотря ни на что, а batch выполняет задание, когда нагрузка LA в системе  опускается ниже 1,5 или величины указанной в atd


### Описание

В рамках тестового задания созданы шаблоны для ```packer```, на основе которых формируются образы четырех виртуальных машин:
  - **vbox1-ubuntu-clean**: Базовый образ **Ubuntu 22.04** (OS из официального iso + обновления) 
  - **vbox2-ubuntu-agent**: Базовый образ + Teamcity Agent + docker & docker-compose & ansible (строится из предыдущего)
  - **vbox3-win2022-clean**: Базовый образ **Windows Server 2022** + Visual Studio Build Tools
  - **vbox4-win2022-agent**: Базовый образ + Teamcity Agent (строится из предыдущего) 

Используемый гипервизор -- **Virtualbox**.

#### VM vbox2-ubuntu-agent

Внутри финальной VM **vbox2-ubuntu-agent** автоматически установлено следующее ПО:
 - Ubuntu 22.04 с последними обновлениями
 - docker и docker-compose
 - ansible
 - Prometheus node exporter
 - TeamCity build agent (заускается внутри docker-контейнера)

Сетевые настройки VM:
 - тип сети: **NAT**
 - проброс порта **29100** на внутренний порт **9100** (для доступа к Prometheus node exporter)
 - проброс порта **2222** на внутреннй порт **22** (для доступ к VM по SSH)

#### VM vbox4-win2022-agent

Внутри финальной VM **vbox4-win2022-agent** автоматически установлено следующее ПО:
 - Windows Server 2022
 - Visual Studio Build Tools (с минимальным количеством workloads)
 - Java Runtime Environment
 - Prometheus node exporter
 - TeamCity build agent (установлен из ZIP-архива, запускается как служба)
 
Сетевые настройки VM:
 - тип сети: **NAT**
 - проброс порта **39182** на внутренний порт **9182** (для доступа к Prometheus node exporter)


#### TeamCity build agents

На обеих финальных VM запускается TeamCity build agent, который подключается к TeamCity Server (radogor.teamcity.com).

#### Prometheus

На обеих фианльных VM запускаются Prometheus node exporters, доступные по следующим адресам:
 - для VM Ubuntu: http://HOST_IP:29100/metrics
 - для VM Win2022: http://HOST_IP:39182/metrics


#### Список автоматически установленного ПО

В процессе создания финальных образов создаются списки автоматически установленного ПО. По окончанию создания образлв формируются файлы со списоком ПО:
 - ./builds/autoinstalled-software-ubuntu.csv
 - ./builds/autoinstalled-software-win2022.csv

### Использование

Для создания образов и запуска виртуальных машин можно использовать скрипты:
  - ```build-all.sh``` (создаются все четыре образа VM в формате OVF)
  - ```run.sh``` (запускаются две финальные VM с установленными TeamCity build agents)
  - ```build-and-run.sh``` (создаются все четыре образа VM в формате OVF и запускаются две финальные VM с установленными TeamCity build agents)

### Про пароли

Администратоивные логины и пароли хранятся в файле ```secret.pkrvars.hcl``` и при запуске packer подключаются в явном виде, например, так:
```
packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-ovf.vbox4-win2022-agent .
```
При реальном использовании файл ```secret.pkrvars.hcl``` не должен находится в git-репозитории и оставлен здесь намеренно в целях проверки тестового задания.

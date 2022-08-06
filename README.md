### Описание

В рамках тестового задания созданы шаблоны для ```packer```, на основе которых формируются образы четырех виртуальных машин:
  - **vbox1-ubuntu-clean**: Базовый образ **Ubuntu 22.04** (OS из официального iso + обновления) 
  - **vbox2-ubuntu-agent**: Базовый образ + Teamcity Agent + docker & docker-compose & ansible (строится из предыдущего)
  - **vbox3-win2022-clean**: Базовый образ **Windows Server 2022** + Visual Studio Build Tools 
  - **vbox4-win2022-agent**: Базовый образ + Teamcity Agent (строится из предыдущего) 

Используемый гипервизор -- **Virtualbox**.

#### VM vbox

### Использование

Для создания образов и запуска виртуальных машин можно использовать скрипты:
  - ```build-all.sh``` (создаются все четыре образа VM в формате OVF)
  - ```run.sh``` (запускаются две финальные VM с установленными TeamCity build agents)
  - ```build-and-run.sh``` (создаются все четыре образа VM в формате OVF и запускаются две финальные VM с установленными TeamCity build agents)

В файлы build/autoinstalled-software-*.csv записыватся список версий автоматически установленных программ

На обеих VM установлены Prometheus node exporters, ноступные по следующим адресам:
 - для VM Ubuntu: http://HOST_IP:29100/metrics
 - для VM Win2022: http://HOST_IP:39182/metrics
 

 

```packer validate -var-file="secret.pkrvars.hcl" .```

```packer fmt -var-file="secret.pkrvars.hcl" .```

```vboxmanage import vbox1-ubuntu-clean.ovf```

```vboxmanage import --vsys 0 --vmname vbox2-ubuntu-agent-docker-ansible vbox1-ubuntu-clean.ovf```

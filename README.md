# homework2

В рамках тестового задания созданы шаблоны для packer, на основе которых формируются образы четырех виртуальных машин:
  - Базовый образ Ubuntu 22.04 (OS из официального iso + обновления) 
  - Базовый образ + Teamcity Agent + docker & docker-compose & ansible (строится из предыдущего)
  - Базовый образ Windows Server 2022 + Visual Studio Build Tools 
  - Базовый образ + Teamcity Agent (строится из предыдущего) 

Используемый гипервизор -- Virtualbox.

Для создания образов и запуска виртуальных машин можно использовать скрипты:
  build-all.sh (создаются все четыре образа VM в формате OVF)
  run.sh (запускаются две финальные VM с установленными TeamCity build agents)
  build-and-run.sh (создаются все четыре образа VM в формате OVF и запускаются две финальные VM с установленными TeamCity build agents)

В файлы build/autoinstalled-software-*.csv записыватся список версий автоматически установленных программ

```packer validate -var-file="secret.pkrvars.hcl" .```

```packer fmt -var-file="secret.pkrvars.hcl" .```

```vboxmanage import vbox1-ubuntu-clean.ovf```

```vboxmanage import --vsys 0 --vmname vbox2-ubuntu-agent-docker-ansible vbox1-ubuntu-clean.ovf```

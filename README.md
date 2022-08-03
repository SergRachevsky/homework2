# homework2

```packer validate -var-file="secret.pkrvars.hcl" .```

```packer fmt -var-file="secret.pkrvars.hcl" .```

```vboxmanage import vbox1-ubuntu-clean.ovf```

```vboxmanage import --vsys 0 --vmname vbox2-ubuntu-agent-docker-ansible vbox1-ubuntu-clean.ovf```

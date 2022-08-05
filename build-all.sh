packer validate -var-file="secret.pkrvars.hcl" .

packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-iso.vbox1-ubuntu-clean .

packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-ovf.vbox2-ubuntu-agent-docker-ansible .

packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-iso.vbox3-win2022-clean .

packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-ovf.vbox4-win2022-agent .
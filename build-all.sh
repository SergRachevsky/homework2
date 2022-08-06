#!/usr/bin/bash

packer validate -var-file="secret.pkrvars.hcl" .

SECONDS=0
packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-iso.vbox1-ubuntu-clean .
ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo vbox1: $ELAPSED >> build-all.log


SECONDS=0
packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-ovf.vbox2-ubuntu-agent-docker-ansible .
ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo vbox2: $ELAPSED >> build-all.log

SECONDS=0
packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-iso.vbox3-win2022-clean .
ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo vbox3: $ELAPSED >> build-all.log

SECONDS=0
packer build -var-file="secret.pkrvars.hcl" -only=virtualbox-ovf.vbox4-win2022-agent .
ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
echo vbox4: $ELAPSED >> build-all.log

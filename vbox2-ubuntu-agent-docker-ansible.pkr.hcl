source "virtualbox-ovf" "vbox2-ubuntu-agent-docker-ansible" {
  source_path = "output-vbox1-ubuntu-clean/vbox1-ubuntu-clean.ovf"

  communicator = "ssh"

  vm_name = "vbox2-ubuntu-agent-docker-ansible"
  output_filename = "vbox2-ubuntu-agent-docker-ansible"

  ssh_timeout         = var.ssh_timeout
  ssh_username        = var.ssh_username
  ssh_password        = var.ssh_password

  shutdown_command    = "echo '${var.ssh_password}' | sudo -E -S poweroff"

  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--rtcuseutc", "off"]
  ]

  keep_registered       = true
}

build {
  sources = ["sources.virtualbox-ovf.vbox2-ubuntu-agent-docker-ansible"]
  
  provisioner "shell" {
    scripts = [
      "scripts/install-common.sh",
      "scripts/install-ansible.sh",
      "scripts/install-docker.sh"
    ]
  }
}
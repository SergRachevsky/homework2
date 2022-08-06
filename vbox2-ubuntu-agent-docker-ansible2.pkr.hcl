source "virtualbox-ovf" "vbox2-ubuntu-agent-docker-ansible2" {
  source_path = "${var.output_dir}/${var.stage2_name}/${var.stage2_name}.ovf"

  communicator = "ssh"

  vm_name          = "vbox2-ubuntu-agent-docker-ansible2"
  output_directory = "${var.output_dir}/vbox2-ubuntu-agent-docker-ansible2"

  ssh_timeout  = var.ssh_timeout
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password

  shutdown_command = "echo '${var.ssh_password}' | sudo -E -S poweroff"

  keep_registered = true
  skip_export     = false
}

build {
  sources = ["sources.virtualbox-ovf.vbox2-ubuntu-agent-docker-ansible2"]

  provisioner "shell" {
    pause_before = "200s"
    scripts = [
      "files/ubuntu/make-software-list.sh",
    ]
  }

  provisioner "file" {
    direction   = "download"
    source      = "/var/tmp/autoinstalled-software.csv"
    destination = "${var.output_dir}/installed-software-vbox2-ubuntu.csv"
  }


}
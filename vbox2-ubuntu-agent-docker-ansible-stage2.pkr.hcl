source "virtualbox-ovf" "vbox2-ubuntu-agent-docker-ansible-stage2" {
  source_path = "${var.output_dir}/${var.stage2_name}/${var.stage2_name}.ovf"

  communicator = "ssh"

  vm_name = var.stage3_name
  output_directory = "${var.output_dir}/${var.stage3_name}"

  ssh_timeout  = var.ssh_timeout
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password

  shutdown_command = "echo '${var.ssh_password}' | sudo -E -S poweroff"

  keep_registered = true
  skip_export     = true
}

build {
  sources = ["sources.virtualbox-ovf.${var.stage2_name}"]
  
  // provisioner "shell" {
  //   inline = [
  //     "sudo mkdir -p /opt/teamcity-agents/agent-1/conf/",
  //     "sudo chmod -R 777 /opt/teamcity-agents"
  //   ]
  // }

  provisioner "shell" {
    inline = [
      "cd /opt/teamcity-agents",
      "docker-compose up -d",
    ]
  }

}
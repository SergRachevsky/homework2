source "virtualbox-ovf" "vbox2-ubuntu-agent-docker-ansible" {
  source_path = "${var.output_dir}/${var.stage1_name}/${var.stage1_name}.ovf"

  communicator = "ssh"

  vm_name          = var.stage2_name
  output_directory = "${var.output_dir}/${var.stage2_name}"

  ssh_timeout  = var.ssh_timeout
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password

  shutdown_command = "echo '${var.ssh_password}' | sudo -E -S poweroff"

  keep_registered = true
  skip_export     = false
}

build {
  sources = ["sources.virtualbox-ovf.${var.stage2_name}"]

  provisioner "shell" {
    inline = [
      "cloud-init status --wait",
      "sudo mkdir -p /opt/teamcity-agents/agent-1/conf",
      "sudo chmod -R 777 /opt/teamcity-agents"
    ]
  }

  provisioner "file" {
    source      = "files/buildAgent.properties"
    destination = "/opt/teamcity-agents/agent-1/conf/buildAgent.properties"
  }

  provisioner "file" {
    source      = "files/docker-compose.yml"
    destination = "/opt/teamcity-agents/docker-compose.yml"
  }

  provisioner "shell" {
    scripts = [
      "files/install-common.sh",
      "files/install-ansible.sh",
      "files/install-docker.sh",
      "files/install-prometheus.sh",
    ]
  }

  // provisioner "shell" {
  //   inline = [
  //     "cd /opt/teamcity-agents; docker-compose up -d",
  //   ]
  // }
}
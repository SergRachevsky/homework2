source "virtualbox-ovf" "vbox2-ubuntu-agent" {
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
      "echo *** Creating directory for TCA agent configuration...",
      "cloud-init status --wait",
      "sudo mkdir -p /opt/teamcity-agents/agent/conf",
      "sudo chmod -R a+rw /opt/teamcity-agents"
    ]
  }

  provisioner "file" {
    source      = "files/ubuntu/buildAgent.properties"
    destination = "/opt/teamcity-agents/agent/conf/buildAgent.properties"
  }

  provisioner "file" {
    source      = "files/ubuntu/docker-compose.yml"
    destination = "/opt/teamcity-agents/docker-compose.yml"
  }

  provisioner "shell" {
    scripts = [
      "files/ubuntu/install-common.sh",
      "files/ubuntu/install-ansible.sh",
      "files/ubuntu/install-docker.sh",
      "files/ubuntu/install-prometheus.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo *** Adding user to 'docker' group...",
      "sudo usermod -aG docker ${var.ssh_username}",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo *** Rebooting...",
      "sudo reboot",
    ]
    expect_disconnect = true
  }

  provisioner "shell" {
    pause_before = "15s"
    inline = [
      "cd /opt/teamcity-agents",
      "echo *** Pulling 'jetbrains/teamcity-agent' docker image...",
      "docker pull jetbrains/teamcity-agent",
      "echo *** Starting container with 'jetbrains/teamcity-agent'...",
      "docker-compose up -d",
    ]
  }

  provisioner "shell" {
    pause_before = "20s"
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
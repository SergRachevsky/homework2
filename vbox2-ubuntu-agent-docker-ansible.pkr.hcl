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
    source      = "files/ubuntu/buildAgent.properties"
    destination = "/opt/teamcity-agents/agent-1/conf/buildAgent.properties"
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
      // "files/start-compose.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "cd /opt/teamcity-agents",
      "sudo usermod -aG docker ${var.ssh_username}",
      "echo Pulling 'jetbrains/teamcity-agent' docker image",
      "echo ${var.ssh_password} | sudo -S -u ${var.ssh_username} docker pull jetbrains/teamcity-agent",
      "echo Starting container with 'jetbrains/teamcity-agent'",
      "echo ${var.ssh_password} | sudo -S -u ${var.ssh_username} docker-compose up -d",
    ]
  }

  provisioner "file" {
    direction   = "download"
    source      = "/var/tmp/autoinstalled-software.csv"
    destination = "${var.output_dir}/installed-software-vbox2-ubuntu.csv"
  }


}
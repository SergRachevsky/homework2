packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "vbox1-ubuntu-clean" {
  iso_url      = "https://mirror.library.ucy.ac.cy/linux/ubuntu/releases/jammy/ubuntu-22.04-live-server-amd64.iso"
  iso_checksum = "sha256:84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"

  boot_command = [
    "c",
    "<wait>linux /casper/vmlinuz ip=dhcp autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' --- <enter>",
    "<wait>initrd /casper/initrd <enter>",
    "<wait>boot <enter>",
  ]

  http_directory = "http"

  boot_wait    = "10s"
  communicator = "ssh"

  vm_name       = "vbox1-ubuntu-clean"
  guest_os_type = "Ubuntu_64"
  cpus          = "4"
  memory        = "2048"
  disk_size     = "5000"

  post_shutdown_delay = "0s"
  shutdown_command    = "echo 'ubuntu' | sudo -E -S poweroff"
  shutdown_timeout    = var.shutdown_timeout
  ssh_timeout         = var.ssh_timeout
  ssh_username        = "ubuntu"
  ssh_password        = "ubuntu"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--rtcuseutc", "off"]
  ]

}

build {
  sources = ["sources.virtualbox-iso.vbox1-ubuntu-clean"]
}

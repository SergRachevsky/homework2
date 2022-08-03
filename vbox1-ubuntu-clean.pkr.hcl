
source "virtualbox-iso" "vbox1-ubuntu-clean" {
  iso_url      = "https://mirror.library.ucy.ac.cy/linux/ubuntu/releases/jammy/ubuntu-22.04-live-server-amd64.iso"
  iso_checksum = "sha256:84aeaf7823c8c61baa0ae862d0a06b03409394800000b3235854a6b38eb4856f"

  boot_command = [
    "c",
    "<wait>linux /casper/vmlinuz ip=dhcp autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'<enter>",
    "<wait>initrd /casper/initrd <enter>",
    "<wait>boot <enter>",
  ]

  http_directory = "http"

  boot_wait    = "8s"
  communicator = "ssh"

  vm_name          = var.stage1_name
  output_directory = "${var.output_dir}/${var.stage1_name}"
  guest_os_type    = "Ubuntu_64"
  cpus             = "4"
  memory           = "2048"
  disk_size        = "20000"

  shutdown_command = "echo '${var.ssh_password}' | sudo -E -S poweroff"
  shutdown_timeout = var.shutdown_timeout
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password

  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--rtcuseutc", "off"],
    ["modifyvm", "{{ .Name }}", "--natpf1", "guest_ssh,tcp,,2222,,22"]
  ]

  keep_registered = true
  skip_export     = false

}

build {
  sources = ["sources.virtualbox-iso.${var.stage1_name}"]

  provisioner "shell" {
    inline = [
      "cloud-init status --wait",
      "sudo apt update && sudo apt upgrade -y"
    ]
  }
}

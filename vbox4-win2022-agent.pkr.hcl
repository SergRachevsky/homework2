source "virtualbox-ovf" "vbox4-win2022-agent" {

  source_path = "${var.output_dir}/${var.stage3_name}/${var.stage3_name}.ovf"

  communicator = "winrm"

  vm_name          = var.stage4_name
  output_directory = "${var.output_dir}/${var.stage4_name}"

  guest_additions_mode = "disable"

  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
  winrm_timeout  = var.winrm_timeout

  shutdown_command = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""

  keep_registered = true
  skip_export     = false
}


build {
  sources = [
    "source.virtualbox-ovf.${var.stage4_name}",
  ]

  provisioner "powershell" {
    scripts = [
      "files/win2022/install-prometheus.ps1",
    ]
  }

  provisioner "windows-shell" {
    inline = [
      "mkdir c:\\buildAgent\\conf",
    ]
  }

  provisioner "file" {
    source      = "files/win2022/buildAgent.properties"
    destination = "c:\\buildAgent\\conf\\buildAgent.properties"
  }

  provisioner "powershell" {
    scripts = [
      "files/win2022/install-agent.ps1",
    ]
  }

  provisioner "powershell" {
    scripts = [
      "files/win2022/make-software-list.ps1",
    ]
  }

  provisioner "file" {
    direction   = "download"
    source      = "c:/windows/temp/autoinstalled-software.csv"
    destination = "${var.output_dir}/installed-software-vbox4-win2022.csv"
  }


}


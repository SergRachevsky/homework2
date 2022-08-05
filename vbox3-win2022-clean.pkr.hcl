source "virtualbox-iso" "vbox3-win2022-clean" {

  vm_name          = var.stage3_name
  output_directory = "${var.output_dir}/${var.stage3_name}"

  cpus      = 6
  memory    = 4096
  disk_size = 25000

  floppy_files = [
    "files/win2022/Autounattend.xml",
    "files/win2022/disable-winrm.ps1",
    "files/win2022/enable-winrm.ps1",
    "files/win2022/win-updates.ps1",
    "files/win2022/microsoft-updates.bat",
  ]

  guest_additions_interface = "sata"
  guest_additions_mode      = "attach"
  guest_os_type             = "Windows2019_64"
  hard_drive_interface      = "sata"
  iso_url                   = "https://software-download.microsoft.com/download/sg/20348.169.210806-2348.fe_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"
  iso_checksum              = "sha256:4f1457c4fe14ce48c9b2324924f33ca4f0470475e6da851b39ccbf98f44e7852"
  iso_interface             = "sata"

  shutdown_command = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  vboxmanage = [
    ["storagectl", "{{ .Name }}", "--name", "IDE Controller", "--remove"],
    ["modifyvm", "{{ .Name }}", "--vrde", "off"],
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vboxsvga"],
    ["modifyvm", "{{ .Name }}", "--vram", "128"],
    ["modifyvm", "{{ .Name }}", "--accelerate3d", "on"],
    ["modifyvm", "{{ .Name }}", "--usb", "on"],
    ["modifyvm", "{{ .Name }}", "--mouse", "usbtablet"],
    ["modifyvm", "{{ .Name }}", "--audio", "none"],
    ["modifyvm", "{{ .Name }}", "--nictype1", "82540EM"],
    ["modifyvm", "{{ .Name }}", "--nictype2", "82540EM"],
    ["modifyvm", "{{ .Name }}", "--nictype3", "82540EM"],
    ["modifyvm", "{{ .Name }}", "--nictype4", "82540EM"],
    ["modifyvm", "{{ .Name }}", "--natpf1", "guest_prometheus,tcp,,39182,,9182"],

  ]
  communicator   = "winrm"
  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
  winrm_timeout  = var.winrm_timeout

  keep_registered = true
  skip_export     = false

}


build {
  sources = [
    "source.virtualbox-iso.${var.stage3_name}",
  ]

  provisioner "powershell" {
    scripts = [
      "files/win2022/install-guest-additions.ps1",
      "files/win2022/install-far.ps1",
      "files/win2022/install-buildtools.ps1",
    ]
  }


}


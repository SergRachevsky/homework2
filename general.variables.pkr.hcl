
variable "ssh_timeout" {
  type    = string
  default = "20m"
}
variable "shutdown_timeout" {
  type    = string
  default = "5m"
}

variable "locale" {
  type    = string
  default = "en_CA.UTF-8"
}

variable "keyboard" {
  type    = string
  default = "us"
}

variable "language" {
  type    = string
  default = "en"
}

variable "ssh_username" {
  type    = string
  default = ""
}
variable "ssh_password" {
  type    = string
  default = ""
}

variable "ssh_password_crypted" {
  type    = string
  default = ""
}

variable "stage1_name" {
  type    = string
  default = "vbox1-ubuntu-clean"
}

variable "stage2_name" {
  type    = string
  default = "vbox2-ubuntu-agent-docker-ansible"
}

variable "output_dir" {
  type    = string
  default = "builds"
}

variable "DO_PAT" {
  description = "DigitalOcean API Key"
}

variable "PVT_KEY" {
  description = "The full path to the SSH private key for DO Instances"
  default = "C:/Users/mcteer/.ssh/id_rsa_do"
}

variable "SSH_FP" {
  default = "21:8c:9e:60:76:c5:ee:fe:e1:96:77:ff:2b:85:0b:e3"
}

variable "IMAGE" {
  default = "centos-8-x64"
}

variable "INST_TYPE" {
  default = "s-1vcpu-1gb"
}

variable "REGION" {
  default = "sfo3"
}

variable "HOST_NAMES" {
  type = list(string)
  default = ["vault1", "vault2", "vault3", "vault4", "vault5"]
}

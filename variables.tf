variable "DO_PAT" {
  description = "DigitalOcean API Key"
}

variable "PVT_KEY" {
  description = "The full path to the SSH private key for DO Instances"
  default = "/Users/mcteer/.ssh/id_rsa_do"
}

variable "SSH_FP" {
  default = "18:7b:12:c5:0e:f9:94:91:a4:f7:0f:c3:5e:55:3a:e6"
}

variable "IMAGE" {
  default = "centos-8-x64"
}

variable "INST_TYPE" {
  default = "1gb"
}

variable "REGION" {
  default = "sfo2"
}

variable "HOST_NAMES" {
  type = list(string)
  default = ["vault1", "vault2", "vault3", "vault4", "vault5"]
}

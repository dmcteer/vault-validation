terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~>2.7.0"
    }
  }
}

provider "digitalocean" {
  token = var.DO_PAT
}

resource "digitalocean_droplet" "vault" {
  count = "1"
  image = var.IMAGE
  name = element(var.HOST_NAMES, count.index)
  region = var.REGION
  size = var.INST_TYPE
  private_networking = true
  ssh_keys = [
    var.SSH_FP
  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.PVT_KEY)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "yum install -y https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el7.noarch.rpm",
      "yum install -y salt-minion",
      "mkdir -p /srv/salt",
      "systemctl enable salt-minion.service",
      "systemctl restart salt-minion"
    ]
  }

  provisioner "file" {
    source = "saltstack/pillar"
    destination = "/srv"
  }

  provisioner "file" {
    source = "saltstack/salt/vault"
    destination = "/srv/salt"
  }

  provisioner "file" {
    source = "saltstack/salt/files"
    destination = "/srv/salt"
  }

  provisioner "file" {
    source = "saltstack/salt/top.sls"
    destination = "/srv/salt/top.sls"
  }

  provisioner "remote-exec" {
    inline = [
      "salt-call --local state.apply vault",
      "systemctl start vault"
    ]
  }
}

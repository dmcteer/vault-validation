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
  ssh_keys = [var.SSH_FP]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.PVT_KEY)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "yum install -y https://repo.saltstack.com/py3/redhat/salt-py3-repo-latest.el8.noarch.rpm",
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

resource "digitalocean_domain" "int" {
  name = "int.fiosrach.com"
}

resource "digitalocean_domain" "ext" {
  name = "ext.fiosrach.com"
}

resource "digitalocean_record" "vault" {
  domain = digitalocean_domain.int.name
  type = "A"
  name = "vault"
  value = digitalocean_droplet.vault[0].ipv4_address_private
}

resource "digitalocean_record" "benchmark" {
  domain = digitalocean_domain.ext.name
  type = "A"
  name = "bench"
  value = digitalocean_droplet.benchmark.ipv4_address
}

resource "null_resource" "vault_init" {

  connection {
    host = digitalocean_droplet.vault[0].ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.PVT_KEY)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "vault operator init -key-shares=1 -key-threshold=1 | grep -E 'Unseal|Root' > /root/keys.txt",
      "sed -n -e 's/^Unseal.*1: //p' /root/keys.txt | xargs vault operator unseal",
      "sed -n -e 's/^Initial.*: /export VAULT_TOKEN=/p' /root/keys.txt >> /etc/profile.d/vault.sh"
    ]
  }

  provisioner "file" {
    source = "loadtest-policy.hcl"
    destination = "/etc/vault.d/loadtest-policy.hcl"
  }
}

resource "time_sleep" "wait" {
  depends_on = [
    digitalocean_droplet.vault,
    null_resource.vault_init
  ]

  create_duration = "10s"
}

resource "null_resource" "vault_config" {

  connection {
    host = digitalocean_droplet.vault[0].ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.PVT_KEY)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sed -n -e 's/^Initial.*: //p' /root/keys.txt | xargs vault login",
      "vault secrets disable secret",
      "vault secrets enable -path=secret/ -version=1 kv",
      "vault policy write loadtest /etc/vault.d/loadtest-policy.hcl",
      "vault auth enable userpass",
      "vault write auth/userpass/users/loadtester password=benchmark policies=loadtest"
    ]
  }

  depends_on = [
    time_sleep.wait
  ]
}

resource "digitalocean_droplet" "benchmark" {
  image = var.IMAGE
  name = "bench"
  region = var.REGION
  size = var.INST_TYPE
  private_networking = true
  ssh_keys = [var.SSH_FP]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.PVT_KEY)
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "yum install -y epel-release",
      "yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo",
      "yum install -y git luajit vault python3",
      "git clone https://github.com/hashicorp/vault-guides.git",
      "echo export BENCH_PATH='/root/vault-guides/operations/benchmarking/wrk-core-vault-operations' > /etc/profile.d/vault.sh",
      "echo export VAULT_ADDR='http://vault.int.fiosrach.com:8200' >> /etc/profile.d/vault.sh"
    ]
  }

  provisioner "file" {
    source = "bench.py"
    destination = "/root/bench.py"
  }

  provisioner "file" {
    source = "wrk"
    destination = "/usr/local/bin/wrk"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /usr/local/bin/wrk"
    ]
  }
}

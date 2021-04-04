/usr/local/bin/:
  archive.extracted:
    - source: https://releases.hashicorp.com/vault/1.7.0/vault_1.7.0_linux_amd64.zip
    - skip_verify: True
    - enforce_toplevel: False
    - overwrite: True

vault:
  user.present: []

/etc/vault.d:
  file.directory:
    - user: root
    - group: root
    - file_mode: 766

/var/vault:
  file.directory:
    - user: vault
    - group: vault
    - file_mode: 766

/etc/vault.d/vault.hcl:
  file.managed:
    - source: salt://files/vault/server.hcl
    - template: jinja

/etc/systemd/system/vault.service:
  file.managed:
    - source: salt://files/vault/vault.service

/etc/profile.d/vault.sh:
  file.managed:
    - source: salt://files/vault/vault_profile.sh
    - template: jinja

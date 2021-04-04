/usr/local/bin/:
  archive.extracted:
    - source: https://releases.hashicorp.com/consul/1.5.3/consul_1.5.3_linux_amd64.zip
    - skip_verify: True
    - enforce_toplevel: False

consul:
  user.present: []

/etc/consul:
  file.directory:
    - user: root
    - group: root
    - file_mode: 766

/var/consul.d:
  file.directory:
    - user: consul
    - group: consul
    - file_mode: 766

/etc/consul.d/consul.hcl:
  file.managed:
    - source: salt://files/consul/consul.hcl

/etc/consul.d/consul.hcl:
  file.managed:
    {% if grains['host'].startswith('consul') %}
    - source: salt://files/consul/server.hcl
    {% endif %}
    - template: jinja

/etc/systemd/system/consul.service:
  file.managed:
    - source: salt://files/consul/consul.service

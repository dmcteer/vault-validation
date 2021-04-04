{
  "server": true,
  "node_name": "{{ grains['host'] }}",
  "datacenter": "dc1",
  "data_dir": "/var/consul",
  "bind_addr": "0.0.0.0",
  "client_addr": "0.0.0.0",
  "advertise_addr": "{{ grains['fqdn_ip4'][0] }}",
  "bootstrap_expect": 5,
  "retry_join": ["192.168.86.43", "192.168.86.52", "192.168.86.53", "192.168.86.54", "192.168.86.55"],
  "ui": true,
  "log_level": "DEBUG",
  "enable_syslog": true,
  "acl_enforce_version_8": false
}

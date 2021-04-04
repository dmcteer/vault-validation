listener "tcp" {
  address          = "0.0.0.0:8200"
  cluster_address  = "{{ grains['ip4_interfaces']['eth1'][0] }}:8201"
  tls_disable      = "true"
}

storage "raft" {
  path    = "/var/vault/"
  node_id = "{{ grains['host'] }}"
}

api_addr = "http://{{ grains['ip4_interfaces']['eth1'][0] }}:8200"
cluster_addr = "https://{{ grains['ip4_interfaces']['eth1'][0] }}:8201"
ui = true

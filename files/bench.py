import os
import requests

login_data = {"password": "benchmark"}
base_url = "http://vault.int.fiosrach.com:8200/v1/"
vault_url = base_url + "auth/userpass/login/loadtester"
response = requests.post(vault_url, json=login_data)
vault_token = (response.json()["auth"]["client_token"])

os.system("export VAULT_TOKEN=" + vault_token)
bench_command = "nohup wrk -t6 -c16 -d20s -H 'X-Vault-Token: " + vault_token + "' -s vault-guides/operations/benchmarking/wrk-core-vault-operations/write-random-secrets.lua http://vault.int.fiosrach.com:8200 -- 10000 > bench.log"
os.system(bench_command)
os.system("cat /root/bench.log")

# WSO2 Prometheus monitoring with Grafana
          
## How to run

#### Change ansible inventory

First of all you need to configure your inventory, which is located in [`hosts`](hosts) file. Here you set up your target hosts by changing value of `ansible_host` variable.

It have seperate node to install prometheus server,grafana and alert manager. It is defined as `prom-master`. It is under `[prometheus]` group. Then you have to define exporters. They will be installed node-exporters. 

```
prom-master ansible_host=host_addr ansible_user=ubuntu
prom-node1  ansible_host=host_addr ansible_user=ubuntu
prom-node2  ansible_host=host_addr ansible_user=ubuntu

[prometheus]
prom-master

[alertmanager]
prom-master

[grafana]
prom-master

[exporters]
prom-node1
prom-node2
```

#### Set passwords

Currently it sets password for grafana. To change password edit file located at [`group_vars/grafana/vault`](group_vars/grafana/vault) with following content:

```
vault_grafana_password: <<INSERT_YOUR_GRAFANA_PASSWORD>>
```

To generate password you can use `ansible-vault stringToEncrypt`. Then it will be asked password to encrypt the string and after you confirmed you can paste it to the file. Remember the password you entered. 

#### Run ansible playbook

You can run script `deploy.sh` located at [`here`](deploy.sh). It needs to provide ansible vault password to decrypt the grafana password you set.
You can set it as environment variable `export ANSIBLE_VAULT_PASSWORD=vault_password`. After setting the vault password you can run `deploy.sh`

```bash
#!/bin/bash

export ANSIBLE_FORCE_COLOR=true

ansible-galaxy install -r roles/requirements.yml

echo "Creating Vault-file: /tmp/vault"
/bin/cat <<EOM >/tmp/vault
${ANSIBLE_VAULT_PASSWORD}
EOM

ansible-playbook --vault-id /tmp/vault site.yml -vv
EXIT_CODE=$?

shred /tmp/vault

exit $EXIT_CODE
```

### Default ports for grafana/prometheus/node_exporter

- node_exporter_http - 9100
- prometheus_http - 9090
- alertmanager_http - 9093
- grafana_http - 3000

### Add new dashboards
 Copy dashboard
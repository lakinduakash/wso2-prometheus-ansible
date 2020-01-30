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

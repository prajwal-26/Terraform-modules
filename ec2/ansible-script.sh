
#!/bin/env bash

set -e

cd .

terraform init

terraform apply -auto-approve

echo "generate the inventory"

terraform output -json > ../ansible/terraform-outputs.json

echo "terraform-outputs.json created......."

echo "[ec2_servers]" > ../ansible/inventory.ini
jq -r '.ec2_details.value.pubic_ip' ../ansible/terraform-outputs.json \
  | awk '{print $1" ansible_user=ubuntu ansible_ssh_private_key_file=/home/prajwal/Downloads/test.pem"}' \
  >> ../ansible/inventory.ini

echo "inventory file created"

ansible-playbook -i ../ansible/inventory.ini ../ansible/ec2-configurations.yaml

echo "configurations Done successfully."





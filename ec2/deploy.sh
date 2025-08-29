#!/bin/bash
set -e

echo " Starting full IaC WebApp deployment..."

#  Terraform Provisioning
echo " Initializing Terraform..."
terraform init

echo " Applying Terraform configuration..."
terraform apply -auto-approve
echo " Terraform applied successfully"

# Generate Terraform Outputs
echo " Exporting Terraform outputs..."
terraform output -json > ../ansible/terraform-outputs.json

# Extract Public and Private IPs
PUBLIC_IP=$(jq -r '.ec2_details.value.public_pubic_ip' ../ansible/terraform-outputs.json)
PRIVATE_IP=$(jq -r '.ec2_details.value.private_instance_private_ip' ../ansible/terraform-outputs.json)

echo "✅ Public IP: $PUBLIC_IP"
echo "✅ Private IP: $PRIVATE_IP"


#  Create Ansible Inventory
echo " Creating Ansible inventory..."
cat > ../ansible/inventory.ini <<EOL
[public]
$PUBLIC_IP ansible_user=ubuntu ansible_ssh_private_key_file=/home/prajwal/Downloads/test.pem

[private]
$PRIVATE_IP ansible_user=ubuntu ansible_ssh_private_key_file=/home/prajwal/Downloads/test.pem ansible_ssh_common_args='-o ProxyJump=ubuntu@$PUBLIC_IP'
EOL
echo "Ansible inventory created with bastion for private server"

#  Copy App Files to Private Server
echo " Copying web app files to private server..."
scp -i /home/prajwal/Downloads/test.pem -r ../deploy-code/* ubuntu@$PUBLIC_IP:/home/ubuntu/
ssh -i /home/prajwal/Downloads/test.pem ubuntu@$PUBLIC_IP "scp -r /home/ubuntu/* ubuntu@$PRIVATE_IP:/home/ubuntu/"

# Run Ansible Playbooks
echo "🔹Running Ansible playbook for private server..."
ansible-playbook -i ../ansible/inventory.ini ../ansible/webapplication.yaml

echo " Running Ansible playbook for public Nginx server..."
ansible-playbook -i ../ansible/inventory.ini ../ansible/public_nginx.yaml --extra-vars "private_ip=$PRIVATE_IP"

#  PM2 Setup on Private Server

echo " Setting up PM2 on private server..."
ssh -i /home/prajwal/Downloads/test.pem ubuntu@$PRIVATE_IP <<'EOF'
    npm install
    npm install pm2 -g
    pm2 start app.js --name app
    pm2 save
    pm2 startup systemd
EOF

echo "Deployment completed successfully!"
echo "Access your web app via the public server: http://$PUBLIC_IP"

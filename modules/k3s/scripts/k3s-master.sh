#!/bin/bash
set -e

# Update system
yum update -y

# Install k3s server
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable=traefik" K3S_TOKEN="${k3s_token}" sh -

# Wait for k3s to be ready
sleep 30

# Set up kubectl for ec2-user
mkdir -p /home/ec2-user/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ec2-user/.kube/config
chown ec2-user:ec2-user /home/ec2-user/.kube/config
chmod 600 /home/ec2-user/.kube/config

# Create kubectl alias for ec2-user
echo 'alias kubectl="k3s kubectl"' >> /home/ec2-user/.bashrc
echo 'export KUBECONFIG=/home/ec2-user/.kube/config' >> /home/ec2-user/.bashrc

# Apply the alias immediately
source /home/ec2-user/.bashrc

# Enable and start k3s
systemctl enable k3s
systemctl start k3s

# Log installation completion
echo "K3s master installation completed at $(date)" >> /var/log/k3s-install.log
#!/bin/bash
set -e

# Update system
yum update -y

# Wait for master to be ready
sleep 60

# Install k3s agent
curl -sfL https://get.k3s.io | K3S_URL="https://${k3s_master_ip}:6443" K3S_TOKEN="${k3s_token}" sh -

# Enable and start k3s-agent
systemctl enable k3s-agent
systemctl start k3s-agent

# Log installation completion
echo "K3s worker installation completed at $(date)" >> /var/log/k3s-install.log
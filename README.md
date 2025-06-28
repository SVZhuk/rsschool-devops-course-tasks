# K3s Kubernetes Cluster on AWS

This project deploys a K3s Kubernetes cluster on AWS using Terraform, consisting of a bastion host and a 2-node K3s cluster.

## Architecture

- **Bastion Host**: Public subnet for secure access
- **K3s Master Node**: Private subnet (AZ1)
- **K3s Worker Node**: Private subnet (AZ2)
- **NAT Instance**: For outbound internet access from private subnets

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0
- SSH client

## Deployment

### 1. Initialize and Deploy Infrastructure

```bash
# Initialize Terraform
./manage-infra.sh init

# Deploy infrastructure
./manage-infra.sh up
```

### 2. Access the Cluster

After deployment, use the bastion host to access the K3s cluster:

```bash
# SSH to bastion host with agent forwarding 
ssh -A -i .ssh/bastion-key.pem ec2-user@<BASTION_PUBLIC_IP>

# From bastion, SSH to K3s master (no key needed with agent forwarding)
ssh ec2-user@<K3S_MASTER_PRIVATE_IP>

# Check cluster nodes
kubectl get nodes

# Check all resources
kubectl get all --all-namespaces
```

### 3. Deploy Sample Workload

```bash
# Deploy nginx pod
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml

# Verify deployment
kubectl get pods
```

## SSH Access Methods

### Method 1: SSH Agent Forwarding
```bash
# SSH to bastion with agent forwarding
ssh -A -i .ssh/bastion-key.pem ec2-user@<BASTION_IP>

# From bastion, access K3s nodes directly
ssh ec2-user@<K3S_MASTER_IP>
ssh ec2-user@<K3S_WORKER_IP>
```

## K3s Configuration

- **Master Node**: Runs K3s server with API server on port 6443
- **Worker Node**: Runs K3s agent, connects to master
- **Networking**: Flannel CNI (default)
- **Ingress**: Traefik disabled (can be enabled if needed)

## Security Groups

- **Bastion**: SSH (22) from your IP
- **K3s Nodes**: 
  - SSH (22) from bastion
  - K3s API (6443) between nodes
  - Flannel VXLAN (8472/UDP) between nodes
  - Kubelet metrics (10250) between nodes
  - NodePort range (30000-32767) between nodes

## Verification Commands

```bash
# Check cluster status
kubectl get nodes -o wide

# Check system pods
kubectl get pods -n kube-system

# Check all resources
kubectl get all --all-namespaces

# Check cluster info
kubectl cluster-info
```

## Troubleshooting

### K3s Service Status
```bash
# On master node
sudo systemctl status k3s

# On worker node
sudo systemctl status k3s-agent
```

### K3s Logs
```bash
# Master logs
sudo journalctl -u k3s -f

# Worker logs
sudo journalctl -u k3s-agent -f
```

### Network Connectivity
```bash
# Test connectivity between nodes
ping <other-node-ip>

# Check K3s API server
curl -k https://<master-ip>:6443
```

## Cleanup

```bash
# Destroy infrastructure
./manage-infra.sh down
```

## Files Structure

```
├── modules/
│   ├── k3s/
│   │   ├── main.tf          # K3s nodes definition
│   │   ├── variables.tf     # K3s module variables
│   │   ├── outputs.tf       # K3s module outputs
│   │   └── scripts/
│   │       ├── k3s-master.sh # Master node setup script
│   │       └── k3s-worker.sh # Worker node setup script
│   ├── vpc/                 # VPC and networking
│   ├── security/            # Security groups
│   └── instances/           # EC2 instances and bastion
├── main.tf                  # Root module
├── variables.tf             # Root variables
├── outputs.tf               # Root outputs
└── README.md               # This file
```

## Notes

- All instances use t2.micro (AWS Free Tier eligible)
- K3s token is configurable via variables
- Private key is stored in `.ssh/bastion-key.pem`
- Cluster uses private IPs for internal communication
- Internet access via NAT instance for package downloads
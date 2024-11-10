#!/bin/bash

# 1. Update system packages
sudo apt-get update

# 2. Install Docker
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock

# 3. Install required dependencies for Kubernetes
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
sudo mkdir -p -m 755 /etc/apt/keyrings

# 4. Add Kubernetes repository and GPG key
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# 5. Update package list
sudo apt update

# 6. Install Kubernetes components
sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1

# 7. Initialize Kubernetes master node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# 8. Configure kubectl for the master node
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 9. Deploy Calico network
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# 10. Deploy NGINX ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml


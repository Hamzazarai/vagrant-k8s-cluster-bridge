#!/bin/bash
set -e

MASTER_IP="192.168.1.10"

echo "===== Initializing Kubernetes master ====="
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=10.244.0.0/16

echo "===== Setting up kubectl for vagrant user ====="
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "===== Waiting for kube-apiserver to be ready ====="
# Retry loop jusqu'à ce que kube-apiserver soit opérationnel
until kubectl get nodes >/dev/null 2>&1; do
  echo "Waiting for kube-apiserver..."
  sleep 5
done

echo "===== Applying Flannel CNI ====="
# Utiliser --validate=false pour éviter les erreurs liées au openapi
kubectl apply --validate=false -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

echo "===== Generating join command for workers ====="
JOIN_CMD=$(kubeadm token create --print-join-command)
echo $JOIN_CMD
echo "===== Copy the above command to run on your worker nodes ====="

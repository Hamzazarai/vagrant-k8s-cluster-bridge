#!/bin/bash
set -e

MASTER_IP="192.168.1.10"

# Initialisation du master
sudo kubeadm init --apiserver-advertise-address=$MASTER_IP --pod-network-cidr=10.244.0.0/16

# Configurer kubectl pour l'utilisateur vagrant
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Installer Flannel comme CNI
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml

# Afficher la commande join
echo "===== Run this command on worker nodes ====="
kubeadm token create --print-join-command

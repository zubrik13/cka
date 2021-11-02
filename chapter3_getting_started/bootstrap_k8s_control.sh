#!/bin/bash

### ref https://medium.com/platformer-blog/building-a-kubernetes-1-20-cluster-with-kubeadm-4b745eb5c697

## containerd
# enable containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

# checks
sudo modprobe overlay
sudo modprobe br_netfilter

# set system-level settings
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ipt6ables = 1
EOF

# load settings
sudo sysctl --system

# install packages
sudo apt update && sudo apt install -y containerd

# create folder to store containerd conf
sudo mkdir -p /etc/containerd

# create and store default conf for containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# restart containerd
sudo systemctl restart containerd

# check status
sudo systemctl status containerd

## k8s
# disable swap
sudo swapoff -a

# persist change after restart
sudo sed -i "/ swap /s/^\(.*\)$/#\1/g" /etc/fstab

# install dependancies
sudo apt update && sudo apt install -y apt-transport-https curl

# download  GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# add k8s to repo list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# update package list
sudo apt update

# install k8s
sudo apt install -y kubelet=1.22.0-00 kubeadm=1.22.0-00 kubectl=1.22.0-00

# turn off automatic updates
sudo apt-mark hold kubelet kubeadm kubectl

## initialize cluster -> control plane only!
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.22.0

# set kubectl access
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# test access
kubectl version
kubectl get nodes

## install calico plug-in -> control plane only!
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# check status of calico
kubectl get pods -n kube-system

## join worker nodes
kubeadm token create --print-join-command

# checks cluster
kubectl get nodes
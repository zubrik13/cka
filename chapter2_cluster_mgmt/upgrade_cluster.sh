#!/bin/bash

# Upgrade kubeadm:
sudo apt-get update && sudo apt-get install -y --allow-change-held-packages kubeadm=1.22.2-00

kubeadm version

# Drain the control plane node:
kubectl drain k8s-control --ignore-daemonsets

# Plan the upgrade:
sudo kubeadm upgrade plan v1.22.2

# Upgrade the control plane components:
sudo kubeadm upgrade apply v1.22.2

# Upgrade kubelet and kubectl on the control plane node:
sudo apt-get update && sudo apt-get install -y --allow-change-held-packages kubelet=1.22.2-00 kubectl=1.22.2-00

# Restart kubelet:
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# Uncordon the control plane node:
kubectl uncordon k8s-control

# Verify the control plane is working:
kubectl get nodes
#!/bin/bash

# check auth mode
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep authorization

# describe role
k describe role kube-proxy -n kube-system

# create role
kubectl create role developer --verb=create --verb=list --verb=delete --resource=pods
kubectl create role developer --verb=create --verb=list --verb=delete --resource=pods \
--dry-run=client -o yaml > role.yaml

# create role-binding
k create rolebinding dev-user-binding --role=developer --user=dev-user --namespace=default
k create rolebinding dev-user-binding --role=developer --user=dev-user --namespace=default \
-o yaml --dry-run=client > role-binding.yaml

# check user permissions
 k auth can-i watch nodes --as michelle
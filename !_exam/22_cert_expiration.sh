#!/bin/bash

# run on master node
find /etc/kubernetes/pki | grep apiserver

openssl x509  -noout -text -in /etc/kubernetes/pki/apiserver.crt | grep Validity -A2

kubeadm certs check-expiration | grep apiserver

kubeadm certs renew apiserver
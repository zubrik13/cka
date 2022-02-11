#!/bin/bash

# check CN of certificate
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep CN

# check validity
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout | grep Not

# ETCD has its own CA. The right CA must be used for the ETCD-CA file 
# in /etc/kubernetes/manifests/kube-apiserver.yaml

# convert csr to base 64
cat akshay.csr | base64

# check list of CSR
k get csr

# approve CSR
k certificate approve aksay.csr

# check CSR content
kubectl get csr aksay -o yaml

# reject CSR
k certificate deny aksay.csr

# delete CSR
k delete csr aksay
#!/bin/bash

# Create a static pod manifest file:
sudo vi /etc/kubernetes/manifests/beebox-diagnostic.yml

# Add the following into the file:
apiVersion: v1
kind: Pod
metadata:
  name: beebox-diagnostic
spec:
  containers:
  - name: beebox-diagnostic
    image: acgorg/beebox-diagnostic:1
    ports:
    - containerPort: 80
Save and exit the file by pressing Escape followed by :wq.

Start Up the Static Pod
# Restart kubelet to start the static pod:
sudo systemctl restart kubelet

# In a new terminal session, log in to the Control Plane Node server:
ssh cloud_user@<PUBLIC_IP_ADDRESS>

# Check the status of your static Pod:
kubectl get pods

# Attempt to delete the static Pod using the k8s API:
kubectl delete pod beebox-diagnostic-k8s-worker1

# Check the status of the Pod:
kubectl get pods
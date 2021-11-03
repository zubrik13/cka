#!/bin/bash

# Install Kubernetes Metrics Server:
kubectl apply -f https://raw.githubusercontent.com/ACloudGuru-Resources/content-cka-resources/master/metrics-server-components.yaml

# Verify Metrics Server is responsive:
kubectl get --raw /apis/metrics.k8s.io/

# It may take a few minutes for Metrics Server to become responsive to requests.
# Locate the CPU-Using Pod and Write Its Name to a File
# In the beebox-mobile namespace, determine which pod with the label app=auth is using the most CPU:
kubectl top pod -n beebox-mobile --sort-by cpu --selector app=auth

# If you get an error message saying metrics are not available, wait a few minutes and then run the command again.
# Write the name of the pod to a file:
echo auth-proc > /home/cloud_user/cpu-pod-name.txt
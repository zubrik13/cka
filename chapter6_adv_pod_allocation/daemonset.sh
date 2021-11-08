#!/bin/bash

# Create a DaemonSet descriptor:
vi daemonset.yml

# Add the following to the file:
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: beebox-cleanup
spec:
  selector:
    matchLabels:
      app: beebox-cleanup
  template:
    metadata:
      labels:
        app: beebox-cleanup
    spec:
      containers:
      - name: busybox
        image: busybox:1.27
        command: ['sh', '-c', 'while true; do rm -rf /beebox-temp/*; sleep 60; done']
        volumeMounts:
        - name: beebox-tmp
          mountPath: /beebox-temp
      volumes:
      - name: beebox-tmp
        hostPath:
          path: /etc/beebox/tmp

# Save and exit the file by pressing Escape followed by :wq.
# Create the DaemonSet in the Cluster
# Create the DaemonSet in the cluster:
kubectl apply -f daemonset.yml

# Get a list of pods, and verify a DaemonSet pod is running on each worker node:
kubectl get pods -o wide

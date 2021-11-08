#!/bin/bash

Configure the auth-gateway Pod to Only Run on k8s-worker2
# Attach a label to k8s-worker2.
kubectl label nodes k8s-worker2 external-auth-services=true

# Open auth-gateway.yml:
vi auth-gateway.yml

# Add a nodeSelector to the auth-gateway pod descriptor:
...

spec:
  nodeSelector:
    external-auth-services: "true"

  ...

#Save and exit the file by pressing Escape followed by :wq.
# Delete and re-create the pod:
kubectl delete pod auth-gateway -n beebox-auth
kubectl create -f auth-gateway.yml
Verify the pod is scheduled on the k8s-worker2 node:
kubectl get pod auth-gateway -n beebox-auth -o wide

# Configure the auth-data Deployment's Replica Pods to Only Run on k8s-worker2
# Open auth-data.yml:
vi auth-data.yml

# Add a nodeSelector to the pod template in the deployment spec (it will be the second spec in the file):
...
spec:

  ...

  template:

    ...

    spec:
      nodeSelector:
        external-auth-services: "true"

      ...
# Save and exit the file by pressing Escape followed by :wq.
# Update the deployment:
kubectl apply -f auth-data.yml

# Verify the deployment's replicas are all running on k8s-worker2:
kubectl get pods -n beebox-auth -o wide
#!/bin/bash

# Get a list of persistent volumes sorted by capacity:

kubectl get pv
kubectl get pv -o yaml
kubectl get pv --sort-by=.spec.capacity.storage

# Save the list to a file:
kubectl get pv --sort-by=.spec.capacity.storage > /home/cloud_user/pv_list.txt

# List the contents of the file to verify it saved:
cat pv_list.txt

# Run a Command Inside the quark Pod's Container to Obtain a Key Value
# Get the contents of a file from inside the quark pod's container:
kubectl exec quark -n beebox-mobile -- cat /etc/key/key.txt

# Save it to a file:
kubectl exec quark -n beebox-mobile -- cat /etc/key/key.txt > /home/cloud_user/key.txt
List the contents of the file to verify it saved:
cat key.txt
Create a Deployment Using a Spec File
Create a deployment using the deployment spec found in home/cloud_user/deployment.yml:
kubectl apply -f /home/cloud_user/deployment.yml
kubectl get deployments -n beebox-mobile
kubectl get pods -n beebox-mobile

# Delete beebox-auth-svc:
kubectl delete service beebox-auth-svc -n beebox-mobile
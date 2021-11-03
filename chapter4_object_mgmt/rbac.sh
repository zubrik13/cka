#!/bin/bash

# Create a Role for the dev User
#Test access by attempting to list pods as the dev user:
kubectl get pods -n beebox-mobile --kubeconfig dev-k8s-config

# We'll get an error message.

# Create a role spec file:
vi pod-reader-role.yml

# Add the following to the file:
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: beebox-mobile
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "watch", "list"]

# Save and exit the file by pressing Escape followed by :wq.

# Create the role:
kubectl apply -f pod-reader-role.yml

# Bind the Role to the dev User and Verify Your Setup Works
# Create the RoleBinding spec file:
vi pod-reader-rolebinding.yml

# Add the following to the file:
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader
  namespace: beebox-mobile
subjects:
- kind: User
  name: dev
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io

# Save and exit the file by pressing Escape followed by :wq.

# Create the RoleBinding:
kubectl apply -f pod-reader-rolebinding.yml

# Test access again to verify you can successfully list pods:
kubectl get pods -n beebox-mobile --kubeconfig dev-k8s-config

# This time, we should see a list of pods (there's just one).

# Verify the dev user can read pod logs:
kubectl logs beebox-auth -n beebox-mobile --kubeconfig dev-k8s-config

# We'll get an Auth processing... message.

# Verify the dev user cannot make changes by attempting to delete a pod:
kubectl delete pod beebox-auth -n beebox-mobile --kubeconfig dev-k8s-config

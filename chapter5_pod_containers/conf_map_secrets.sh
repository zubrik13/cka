#!/bin/bash

## Generate an htpasswd File and Store It as a Secret
# Generate an htpasswd file:
htpasswd -c .htpasswd user

# Create a password you can easily remember (we'll need it again later).
# View the file's contents:
cat .htpasswd

# Create a Secret containing the htpasswd data:
kubectl create secret generic nginx-htpasswd --from-file .htpasswd

# Check file content
kubectl edit secrets nginx-htpasswd

# Delete the .htpasswd file:
rm .htpasswd

# Create the Nginx Pod
# Create pod.yml:
vi pod.yml

# Set vi to 'paste' mode by hitting :, and then typing set paste (ENTER). Then switch back to INSERT mode by hitting i.
#Enter the following to create the pod and mount the Nginx config and htpasswd Secret data:

apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.19.1
    ports:
    - containerPort: 80
    volumeMounts:
    - name: config-volume
      mountPath: /etc/nginx
    - name: htpasswd-volume
      mountPath: /etc/nginx/conf
  volumes:
  - name: config-volume
    configMap:
      name: nginx-config
  - name: htpasswd-volume
    secret:
      secretName: nginx-htpasswd

# Save and exit the file by pressing Escape followed by :wq.
# View the existing ConfigMap:
kubectl get cm

# Get more info about nginx-config:
kubectl describe cm nginx-config

# Create the pod:
kubectl apply -f pod.yml

# Check the status of your pod and get its IP address:
kubectl get pods -o wide

# Its IP address will be listed once it has a Running status. We'll use this in the final two commands.
# Within the existing busybox pod, without using credentials, verify everything is working:
kubectl exec busybox -- curl <NGINX_POD_IP>

# We'll see HTML for the 401 Authorization Required page — but this is a good thing, as it means our setup is working as expected.

# Run the same command again using credentials (including the password you created at the beginning of the lab) to verify everything is working:
kubectl exec busybox -- curl -u user:<PASSWORD> <NGINX_POD_IP>

# This time, we'll see the Welcome to nginx! page HTML.
#!/bin/bash

##POD
#Create an NGINX Pod
kubectl run nginx --image=nginx

#Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)
kubectl run nginx --image=nginx --dry-run=client -o yaml


##Deployment
#Create a deployment
kubectl create deployment --image=nginx nginx

#Generate Deployment YAML file (-o yaml). Don't create it(--dry-run)
kubectl create deployment --image=nginx nginx --dry-run=client -o yaml

#Generate Deployment with 4 Replicas
kubectl create deployment nginx --image=nginx --replicas=4

#You can also scale a deployment using the kubectl scale command.
kubectl scale deployment nginx --replicas=4

#Another way to do this is to save the YAML definition to a file and modify
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > nginx-deployment.yaml


##Service
#Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml
#(This will automatically use the pod's labels as selectors)

#Or
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml (This will not use the pods labels as selectors, instead it will assume selectors as app=redis. You cannot pass in selectors as an option. So it does not work very well if your pod has a different label set. So generate the file and modify the selectors before creating the service)

#Create a Service named nginx of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:
kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml
#(This will automatically use the pod's labels as selectors, but you cannot specify the node port. You have to generate a definition file and then add the node port in manually before creating the service with the pod.)

#Or
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml
#(This will not use the pods labels as selectors)

# Exec into a pod
kubectl exec app -n elastic-stack -it -- /bin/sh

## Networking

# check ports
netstat -nplt | grep kube-scheduler

# install CNI with custom ip table
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.50.0.0/16"

# check CoreDNS config
kubectl -n kube-system describe deployments.apps coredns \
| grep -A2 Args \
| grep Corefile

# create Ingress
kubectl create ingress ingress-test --rule="wear.my-online-store.com/wear*=wear-service:80"

# expose deployment
kubectl expose deployment ingress-controller \
--type=NodePort --port=80 --name=ingress --dry-run=client \
-o yaml > ingress.yaml

## JSON PATH
kubectl get nodes -o=jsonpath='{.items[*].metadata.name}' \
> /opt/outputs/node_names.txt

kubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.osImage}' \
> /opt/outputs/nodes_os.txt

kubectl config view --kubeconfig=my-kube-config \
-o jsonpath="{.users[*].name}" > /opt/outputs/users.txt

# sort 
kubectl get pv --sort-by=.spec.capacity.storage \
> /opt/outputs/storage-capacity-sorted.txt

kubectl get pv --sort-by=.spec.capacity.storage \
-o=custom-columns=NAME:.metadata.name,CAPACITY:.spec.capacity.storage \
> /opt/outputs/pv-and-capacity-sorted.txt

kubectl config view --kubeconfig=my-kube-config \
-o jsonpath="{.contexts[?(@.context.user=='aws-user')].name}" \
> /opt/outputs/aws-context-name

# custom deploy
kubectl get deploy -n admin2406 --sort-by=.metadata.name \
-o=custom-columns=DEPLOYMENT:.metadata.name,\
CONTAINER_IMAGE:.spec.template.spec.containers[*].image,\
READY_REPLICAS:.spec.replicas,\
NAMESPACE:.metadata.namespace\
> /opt/admin2406_data
#!/bin/bash

kubectl run my-static-pod \
--image=nginx:1.16-alpine \
--requests cpu=10m,memory=20Mi \
-o yaml --dry-run=client > my-static-pod.yaml


k expose pod my-static-pod-cluster3-master1 \
--name static-pod-service \
--type=NodePort \
--port 80

k get svc,ep -l run=my-static-pod
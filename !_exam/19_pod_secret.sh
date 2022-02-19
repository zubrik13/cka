#!/bin/bash

k -n secret run secret-pod \
--image=busybox:1.31.1 $do \
-- sh -c "sleep 5d" > 19.yaml

k -n secret create secret generic secret2 \
--from-literal=user=user1 \
--from-literal=pass=1234

# checks
k -n secret exec secret-pod -- env | grep APP
k -n secret exec secret-pod -- find /tmp/secret1
k -n secret exec secret-pod -- cat /tmp/secret1/halt

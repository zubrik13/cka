#!/bin/bash

k run tmp-api-contact \
  --image=curlimages/curl:7.65.3 $do \
  --command > 6.yaml -- sh -c 'sleep 1d'

TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

curl -k https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}"

CACERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

curl --cacert ${CACERT} https://kubernetes.default/api/v1/secrets -H "Authorization: Bearer ${TOKEN}"

k auth can-i get secret --as system:serviceaccount:project-hamster:secret-reader
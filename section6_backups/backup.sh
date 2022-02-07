#!/bin/bash

etcdctl snapshot save /opt/snapshot-pre-boot.db \
--endpoints=https://127.0.0.1:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key

etcdctl snapshot restore /opt/snapshot-pre-boot.db \
--data-dir=/var/lib/etcd-from-backup

# update the /etc/kubernetes/manifests/etcd.yaml:
# We have now restored the etcd snapshot to a new path on the controlplane 
# - /var/lib/etcd-from-backup, so, the only change to be made in the YAML file, 
# is to change the hostPath for the volume called etcd-data 
# from old directory (/var/lib/etcd) to the new directory /var/lib/etcd-from-backup.

#  volumes:
#  - hostPath:
#      path: /var/lib/etcd-from-backup
#      type: DirectoryOrCreate
#    name: etcd-data


#!/bin/bash

# check secret
k create secret docker-registry private-reg-cred \
--docker-server=myprivateregistry.com:5000 \
--docker-username=dock_user \
--docker-password=dock_password \
--docker-email=dock_user@myprivateregistry.com
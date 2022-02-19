#!/bin/bash

k run tigers-reunite -n project-tiger \
--image httpd:2.4.41-alpine \
--labels pod=container,container=pod

crictl ps | grep tigers-reunite
crictl logs 3d7a87532b2a4
crictl inspect 3d7a87532b2a4 | grep runtimeType
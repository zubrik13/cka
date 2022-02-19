#!/bin/bash

k -n project-c13 describe pod | less -p Requests

k -n project-c13 describe pod | egrep "^(Name:|    Requests:)" -A1

k -n project-c13 get pod \
  -o jsonpath="{range .items[*]} {.metadata.name}{.spec.containers[*].resources}{'\n'}"
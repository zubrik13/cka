#!/bin/bash

k api-resources --namespaced -o name > /opt/course/16/resources.txt

k -n project-c14 get role --no-headers | wc -l

# project-c14 with 300 resources
#!/bin/bash

k -n project-snake get pod -L app

k -n project-snake exec backend-0 -- curl -s 10.44.0.25:1111
#!/bin/bash

# Start using the busybox Pod in the web namespace to perform an nslookup on the web-frontend Service by entering:
kubectl exec -n web busybox -- nslookup web-frontend

# Redirect the output to save the results in a text file by using:
kubectl exec -n web busybox -- nslookup web-frontend >> ~/dns_same_namespace_results.txt

# Look up the same Service using the fully qualified domain name by entering:
kubectl exec -n web busybox -- nslookup web-frontend.web.svc.cluster.local

# Redirect the output to save the results of the second nslookup in a text file by using:
kubectl exec -n web busybox -- nslookup web-frontend.web.svc.cluster.local >> ~/dns_same_namespace_results.txt

# Check that everything looks okay in the text file by using:
cat ~/dns_same_namespace_results.txt

#Use clear to clear the text file output.

# Perform an Nslookup For a Service in a Different Namespace
# Use the busybox Pod in the web namespace to perform an nslookup on the user-db Service in the data namespace, while only utilizing the short Service name, by entering:
kubectl exec -n web busybox -- nslookup user-db

# This first request is supposed to result in an error message, so don't be alarmed if you see that we can't resolve user-db.

# Save the results of this nslookup in a text file by using:
kubectl exec -n web busybox -- nslookup user-db >> ~/dns_different_namespace_results.txt

# Perform the same lookup using the fully qualified domain name by entering:
kubectl exec -n web busybox -- nslookup user-db.data.svc.cluster.local

# Save the results in a text file by using:
kubectl exec -n web busybox -- nslookup user-db.data.svc.cluster.local >> ~/dns_different_namespace_results.txt

# Check the output in the text file by using:
cat ~/dns_different_namespace_results.txt
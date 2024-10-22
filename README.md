# devops-challenge 2024.10

For plan, decision and future work see [plan-and-future-work.md](./plan-and-future-work.md)

Techstack: terraform, gke, elasticsearch

Tools: terraform, kubectl, gcloud

1. Make sure you have permissions enough to manage gcp resources: network, compute, ...
2. Edit [./common/gcp_project_name.auto.tfvars ](./common/gcp_project_name.auto.tfvars) `gcp_project_name` to your gcp project
3. (For new project): enable kubernetes engine\
   ![](data:image/png;base64,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)

4. Provion GKE (terraform apply)
   First create the network
   ```bash
   cd 005/gcp-network
   terraform apply # yes
   ```

   Then create the gke cluster
   ```bash
   cd 020-gke-singapore
   terraform apply # yes
   ```

   Get kubeconfig and use it as default with
   ```bash
   # change cluster name or location if needed
   gcloud container clusters get-credentials zero --location=asia-southeast1-a
   ```

5. Prepare elasticsearch certs (I will commit my ssl certs as for demo purpose, in production It shouldn't be here)
   ```bash
   mkdir -p ssl
   ```

   ```bash
   org_name=tuana9a
   country=VN
   state=HN
   ca_key=./ssl/ca.key
   ca_crt=./ssl/ca.crt
   expire_days=${expire_days:-3650}

   openssl genrsa -out $ca_key 2048
   openssl req -new -subj "/C=$country/ST=$state/O=$org_name/CN=$org_name" -x509 -sha256 -days $expire_days -key $ca_key -out $ca_crt
   ls -l ./ssl/
   ```
   
   using one cert for all or cert per node :V

   ```bash
   org_name=tuana9a
   country=VN
   state=HN
   ca_key=./ssl/ca.key
   ca_crt=./ssl/ca.crt
   expire_days=${expire_days:-3650}
   server_key=./ssl/server.key
   server_csr=./ssl/server.csr
   server_crt=./ssl/server.crt

   # $pod-name.$headless-service-name.$namespace.svc.cluster.local
   SAN="DNS:es-0.es-headless.default.svc.cluster.local"
   SAN="$SAN,DNS:es-1.es-headless.default.svc.cluster.local"
   SAN="$SAN,DNS:es-2.es-headless.default.svc.cluster.local"

   openssl genrsa -out $server_key 2048
   openssl req -new -sha256 -subj "/C=$country/ST=$state/O=$org_name/CN=$org_name" -key $server_key -out $server_csr
   openssl x509 -req -sha256 -days $expire_days -in $server_csr -CA $ca_crt -CAkey $ca_key -out $server_crt -extfile <(printf "subjectAltName=$SAN") -CAcreateserial

   ls -l ./ssl
   ```

   create kube secret for later use

   ```bash
   kubectl delete secret es-certs
   kubectl create secret generic es-certs \
   --from-file=ca.crt=./ssl/ca.crt \
   --from-file=server.crt=./ssl/server.crt \
   --from-file=server.key=./ssl/server.key
   ```

6. Prepare initial password
   ```bash
   kubectl delete secret es-bootstrap-password
   ES_PASSWORD=pA55w0rd # remember to store it for later use
   kubectl create secret generic es-bootstrap-password --from-literal=password=pA55w0rd
   ```

7. Kubectl apply
   ```bash
   kubectl apply -f 040-elasticsearch
   ```
   wait for few minutes should be under 10m

8. Test with debug pod
   ```bash
   kubectl apply -f 100-debug.yaml
   kubectl -n default exec -it es-debug -- /bin/sh
   apk add openssl curl
   openssl x509 -in /data/server.crt -text -noout
   # should see the fqdn of the elasticsearch like:
   # DNS:es-0.es-headless.default.svc.cluster.local, DNS:es-1.es-headless.default.svc.cluster.local, DNS:es-2.es-headless.default.svc.cluster.local
   ES_USER=elastic
   ES_PASSWORD=pA55w0rd
   curl --insecure -u $ES_USER:$ES_PASSWORD https://es-0.es-headless.default.svc.cluster.local:9200/_cluster/health/?pretty
   # should be 3 healthy nodes
   {
      "cluster_name" : "es",
      "status" : "green",
      "timed_out" : false,
      "number_of_nodes" : 3,
      "number_of_data_nodes" : 3,
      "active_primary_shards" : 0,
      "active_shards" : 0,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 0,
      "delayed_unassigned_shards" : 0,
      "number_of_pending_tasks" : 0,
      "number_of_in_flight_fetch" : 0,
      "task_max_waiting_in_queue_millis" : 0,
      "active_shards_percent_as_number" : 100.0
   }
   ```

# ES member management

Add, remove new elastic memeber should share those common steps:
- Re gen server cert from ca
- Update the es-config-template to match the wanted number of replicas
- change the replicas number and kubectl apply

# Tips and scripts

Just a collection of notes and convenient command while working with elastic search

```bash
kubectl delete pvc es-data-es-{0..2}
```

# plan and future work

Objectives:
- Deploy a highly available authenticated elasticsearch cluster.
- Must not use managed services.
- Describe the solution concisely (e.g. choice of tech stack, actual solution).
- Share how much time was spent.

Output: Github repo link

Need detail a bit, is the ES deploy in virtual machine or k8s, need network setup in the code? ...
look for someone who will use GKE, the first cluster anyway will not have any admin charges afaik. so it can satisfy the $300 budget
someone who balances cost, performance and security

# plan

I have experience with GKE so I will use GKE, for elasticsearch I'm not working with it that much, so I choose write my own manifests to better understand the elasticsearch from scratch, future work I believe can be just using elasticsearch operator or ECK as it will automate most of those stuffs. I will try to work with it if having enough time or on request.

Cloud region: singapore as it's near my location, assume I was the client, so it's will be for the performance.

Techstack: terraform, gcp, gke, elasticsearch

- [x] Provision networks: vpc, subnet, nat gateway (30m) (day1)
- [x] GKE cluster: control plane singapore, worker node in singapore (15m code + 15m provisioning) (day1)
- [x] plain manifests to setup elasticsearch cluster with 3 nodes
  - [x] prepare elasticseach certs (1h) (day2)
  - [x] provision the es cluster (4h) (day2) (having some trouble with GKE default storage class doesn't support ReadWriteMany which break my initial idea with managing certs via volume)
  - [x] create a debug pod (5m) (day2)

# future work

- [ ] GKE cluster: control plane in singapore, worker nodes in other region: japan, australia, thailand
  - [ ] ? storage class may need to support ReadWriteMany
  - [ ] Pod distribution per node
  - [ ] Pod disruption budget
- [ ] More automated cert management: Cert volume per pod, init container will check if cert is existed, if not using ca.cert + ca.key + node.name to create and issue itself
- [ ] ? More automated member management: when changing the replicas count: auto create server cert, or update es config to add, remove member
- [ ] Elasticsearch backup and restore
- [ ] terraform remote state with gcs
- [ ] Vault secrets
- [ ] ArgoCD to watch for CD, reconcile, watch for changes
- [ ] Elastichsearch operator
- [ ] ECK: https://elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-elasticsearch.html

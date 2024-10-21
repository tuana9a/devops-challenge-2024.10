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

I have experience with GKE so I will use GKE, for elasticsearch I choose write my own manifests to better understand the elasticsearch from scratch, future work can be just using elasticsearch operator as it will automate most of those stuffs

Cloud region: singapore as it's near my location, assume I was the client, so it's will be for the performance.

Techstack: terraform, gcp, gke, elasticsearch

- [x] Provision networks: vpc, subnet, nat gateway (30m)
- [x] GKE cluster: control plane singapore, worker node in singapore (15m code + 15m provisioning)
- [ ] plain manifest to setup elasticsearch cluster with 3 nodes
  - [ ] prepare elasticseach certs
  - [ ] provision the es cluster
  - [ ] create a debug pod to 

# future work

- [ ] terraform remote state with gcs
- [ ] GKE cluster: control plane in singapore, worker nodes in other region: japan, australia, thailand
- [ ] Vault secrets
- [ ] ArgoCD to watch for CD, reconcile, watch for changes
- [ ] Elastichsearch operator

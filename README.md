# devops challenge 2024.10

# Objectives:

- Deploy a highly available authenticated elasticsearch cluster. Traffic between elasticsearch should be encrypted
- Must not use managed services.
- Describe the solution concisely (e.g. choice of tech stack, actual solution).
- Share how much time was spent.
- Use GKE, satisfy the $300 budget, balances cost, performance and security

Output: Github repo link

# plan

I have experience with GKE so I will use GKE with worker in private subnet and control plane public accessible, for elasticsearch I'm not working with it that much, so I choose to write my own manifests to better understand the elasticsearch from scratch, future work I believe can be just using elasticsearch operator or ECK as it will automate most of those stuffs. I will try to work with it if having enough time or on request.

- [x] terraform: `020-gke-singapore`
- [x] kube manifests: `040-elasticsearch`
- [x] Cloud region: singapore as it's near my location, assume I was the client, so it's will be for the performance.
- [x] Provision networks:
  - [x] vpc: singapore
  - [x] subnetwork: singapore
  - [x] nat gateway: for worker in private network can access public internet
- [x] Provision GKE
  - [ ] ~~Regional control plane (Better HA)~~ (failed because of exceeding quota for free trial account)
  - [x] Zonal control plane: in singapore
  - [x] Worker node (node pool) in 3 zones in private network (no public ip)
  - [X] Autoscale: enabled
- [x] Write plain manifests to setup elasticsearch cluster with 3 nodes spreaded in 3 zones
  - [x] Elasticsearch ssl: client to es server using https
  - [x] Elasticsearch ssl: cross member authentication and encryption
  - [x] Statefulset Elasticsearch
  - [x] HA: Pod distribution per node, per zone https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/
- [x] Debug pod: for playing with elasticsearch cluster

# future work

- [ ] ~~GKE cluster: control plane in singapore, worker nodes in other region: japan, australia, thailand~~ -> Not possible afaik: It can be in different zones but worker and control plane must be in the same region, 
- [ ] Pod disruption budget: control the number of maximum unavailable pods
- [ ] Elasticsearch operator (ECK)
  - [ ] ECK: Deploy https://elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-elasticsearch.html
  - [ ] ECK: pod distribution https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-advanced-node-scheduling.html#k8s_a_single_elasticsearch_node_per_kubernetes_host_default
- [ ] Monitoring, alert, health check
- [ ] ? More automated member management: when changing the replicas count auto update es config to add, remove members
- [ ] Elasticsearch backup and restore
- [ ] terraform remote state with gcs
- [ ] using Vault secrets to store secret
- [ ] ArgoCD for CD: reconcile, watch for changes

# How to

This project use symlink from linux (using ln command), so pls clone it into a unix machine.

cli tools:
- `terraform`
- `kubectl`
- `gcloud`

1. Create or using existing gcp project, make sure you have permissions to manage gcp resources: network, compute, ...
2. Edit [./common/gcp_project_name.auto.tfvars ](./common/gcp_project_name.auto.tfvars) `gcp_project_name` to your gcp project
3. (For new project): enable kubernetes engine\
   ![](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAToAAAChCAMAAABgSoNaAAABL1BMVEX29vYbc+j////39/f6+vo9hevt7e3n5+fW1tZxkc8PceoAbeu2tLA0Z9bx8fEAAAClpaUeieTJyckAguMoeek6g+vb3+obW9TT0swAaOfg4OAVZMDS0tIadtTo6OjCwsLk7/yZmZnO4vllZWWMjIwqYtViYmJycnKIndeBgYHw9/2urq5YWFhkZGSUlJTp6OEzX54AYeYAW+UAfOKgvPNWjexJSUmCgoI5OTkAV7zc5foAbdKMs+Wzyvbt8/3I2PgsLCxOTk5snO6UtfIcHBxWoeqfs+lJdNm30PiDqvBfl+56o+8UFBQnJyc1NTVpquxCmOilyvNXfdthg9xkdpcAUuQ/cbJ8tO6gx/IzkeeWs98AULqnv+RPkNuGp9oAZ9Audsl7l+EATNGfr9mkq7qfxvveAAAT6ElEQVR4nO2dC2Oa2LbHyWIHGLVAiU4vDBVRAoMQ59oxaukoUftQ03Rm2nvOPM+Z6dz7/T/DXRvUkPgIcpom7fBPIq/tBn6utddisyXM/3yRK5uY/y7kyiZEd5Ark3J0m1RJoxzdBpUP0yhHt0EfBl3h70h2f3TL0JGoRK2crsErL2eKxQO1ULy6UaV/qlqIZlbFtqqo3seP5hJdpVyuXOGFbdwGdJVBJ1YCZlCrN0+vnF3hNFigUAfNWlCul5Nb1ZqKf4R02s2IHZItDoZbj7E4gElcW3Ed8A7it6wVusoMmudJdvPp9JzSo39JdAtyk9WaYjhoqwcFBIDGUSzibLHYPg3VyNaKA9x4ehiUC4VykRqZelAst4eIjjxp1ypNtVguIud2gfyjUCyjSePbVWqCCSQqQFMtF2hlYVimFl/EfUSmXyyGhYVJX3eFW9cK3SkczuHwkl2lc37QQU6V88H5PIGufLrQJTooFA7n88Kk2ZwXw2ZQmJNh8zAs1GodPEVqVwU1KI+H9UBtqmqzHQYBRdesHDYPmoVhvVaukUkIQTkMarNJfTgL6sEgmF6yK0yG53XAytRALY5Pzw8ng8JscD6YVTqDQqDOBlGhOR7TvHIH6Coz9KnaOGl20+lpZ9aZzebT8SU6tJBY4erUilAs4KnPm2qlOZk+6QyahyochoPOBLD8MGrXgoPmQXswAVWF+bRdBkQ3DIJxu9kezwaz07BdHD4Z19tt0gmfnAf/CCdP4LIZLJTHZQDq5EE9LATBAdp8rdw8rI3D8TQ8DWcDPJbCGLDMxzS7FboKdAaQCBqVWeUw7Ewm8+l5Et1B4Ums9qqKYn3QbhebleGTAul0nsymUHgyRHTDMTqQWkOHLCI6pDbpkHYbZhM1cthau1hQm+VgHMzmoXowbM+m7fZw0FHPw3Z43k6gU2sQjkM0czV40m4Hg0q9MwmeBFhqoobhrN4Z06MrziFQDz6iLtu60+lgWks47Gza6Yyng/m0Eyatbg6xmgmrqA3rMFbDYDg5aIakMmvW4bBeboZDbABPm7NxfRKUB8GsWR6eT6DQHA+o1dEKVDgNzpuzynBOHRttNuwMInSzK+iGECBnarxhOMHDqQWdoI3oxsNgXC8E4Xl0dMX5x43DSTurlKf1BLvDUxpiK5XTK2GioC6UqEQ9nWOYUE8r2HbPD4qzw4NhsVIonFKfLpQ7g7l6Xlbnk3KhPJjNC4eDMZpJYYZVFmbq+eT0sHg+w8XCweQcayocjovjw+IkEcFPJ5V4SS2iCRdpdKBxRD3v0FCkLqPDR85gruZ1FFNiaTVJlxJHrwjlvNmcxbPxRjSYwnJroRAFx+XWQhQY6bZ4a+L3SvWbd18+vMt871pKfDWzW2m/C7GCei9T2A+t/Bo2s3J0mZUS3T9zdOsqp1GOLrOYf2JakCuLmJZSypVJjKkJuTKJkRkuVyYxMmFyZVOOLrNydJl1BR17Z4fxKSqBjmWGObs9dImOJaeD3Hv30AodkusAy+Z2l1qX6Oaz4Zdffpn7bGot0bGhOkeddnKfTauV1ZHwkAAhObnUugwTJCyLubfuoURyQqZ5hN1HyZQ499a9lF+IZVaOLrNydJmVo8ssmbC5MokxOT5XJuUOm105uszK0WVWji6zcnSZlaPLrBxdZuXoMitHl1k5uszK0WVWji6zcnSZlaPLrBxdZuXoMitHl1k5uszK0WVWji6zcnSZlaPLrBxdZuXoMitHl1k5uszK0WXWfUD3iX5Z447QscDiX7xvVuC3slunGj086eqa9XdHNdOCZOPmD6OM6MSr2vftbFViCSeVop2D7207CJYTrp04kV6/lp7DlTXadTjwBmuGN6+lNyYh0m2Ny8+ALmJF4FKE2Zcey0uEkSz6VhbALgGhMwQXAVismgAdFE4IKBeAu8LFeGsEqsrzWITaLS1BWG35jkURhuhSFxiQjKrwWob7g07kxCS2FT5cn74SRAf9BoDjEU2CxkiSDEIa0msBzkaS0e1LDoApSZ4iSReALw7gVixD0TF0Z68b0hsOPEnyLZA42X9OP4deXIQBR0ZLBEkgIPv3Bp0oshu4xWLSmx6isy/QcGwZKLoGGBL0TqB0AVJLNCSNkQRFQo8W9T6IEgI1SmeIkNqi1LN6iih5MDJFSYGRC1JVlkReEuU+CBLBNpSRRBdJSjrL9a17gk7caHCXYtNaHqLrooUs0NkeAUk7a1g9Cadg9AHOdKtvWZKhvEGqltXvaZJj0AafSLInCyLantVCbwYzQodGKom2j+/Ado94I2SIa1AOcy/aOpHbbnEry0sHj7Z1hsQjNOCX6C5anlfCKYnR9eySV+Iputc4owMaVTeyOhEbRrRHiu4MSAKd72IFHMtAl0Iz0GHpp3kf0InijeCoUnktomOhdwGOi+0VnDjUGZ0GMCZtoGJ0JYmAKSrPoYoISoLlIGRMVYjEsSwrUnQWdWV7hY5rdQFaWLeG7wTTRocl9Gu+d48uhcktDe/myig6FvquJqHjQgPNxAMRX1foLhRwJclGRhKUMFZoYl+S5ChMUMXoaJjo9ig6jDgST2xJcglDLPwMMPthInR377Ait7uVS4qkYUfbrSilgOiXpcmJiCkKTTmiPIPOAUvXEyLiTLSVWaTEi8zEwMTGJDSdoZkvS1MYLEGX6A4WGfcdp8QilxpcSnZLxecVXzRcO8fLlZu2ooj/+vlZ0qY+7hVdKnT7kduP3X8i4LVbs6mblQrdnuQ+Hrs77ThIg25vcmnYbfTOT0op0O0RIS7F7M5RsNW/4mosv3YNf+91M7qU+dx17czvWLHv9OlHgmEx+gNPxpdPi96N6PYNESvtcllieqArVbvBiQ2bZxqOacic7XxaD5W6Ed0ud53+EG7fyO5gB66mm5qtCU5PqfpySfQNz9bN+9BlnV43He0Od63/cPTw6EVt6/YdLktaBiPLPmH9hghdSwNE1zVN/bNCt9Vdh98fPaQ6+qm5pcSOKMtWz2Sk5TieceKaum/Zhiy7lvI5odtqdN8dxeSQ3cOf9zc7llE0AoJAiCYAbxgN/Ixw6UOf3a3qBnRbjG76kII7evEwMr2jXzY3ebuSO5awcTLHsmzVdao4+6mldrvRbTY62sghsO+H9W+HtRcxxI1NXsqeT7x8/8SoRdqNblN4jRu5ox/qAOG3SKz+y9G2Ju+GvPgT1w3o1p3wZ9rIHf0ypQsROoAfqfseHf24wew+1mnchXaiW/fXaUxpERjqMTpo/hQ3efWMHvtpaie6tZ7h+rdJ3yQ/LRlCLfLib6+3eJ+1x+5EV71uRXUE9CJYLFA/vQyu9R8Q6nV0H6vz6U602+o2oDtqLlEtUuJlcK0draOD6kc7kY+vXejWm7oVutr3y4x45cAb0X3OjV1WdC/Sodt/JM+no53omG3oas0rDlsb7ouOjW9vsdFFxbVD2O9yjN1xW+dKTdGuthTccoz0d/tR7UK3fut1iS589nsiTPz6W7AN3ZYQy2qGTkeHiJohskyJsPF9L/p8LoZ4hIkf1cXGa5KT+LTjNdEYPVbj4ss5uia6Cl4u0ZrYRHHOEOIrP4YAz7PL68CYZFxo+RP/igbB33gNMHRA21XiO9GtXUtconuGSVycnIR/Pn26Hd3mEEtaXksWWZHTXU7UHNDoCWlE5HjC8j4gUlYTCS6JGkN4jjC4hBNRIwxdy8RFfZHVQOGxMNFEFleUPJ4QXIreQQjfQKvW8Dw0Wo9mGQxWgLtRWpqGE7rEapQI3Qsu4A5Yjh4GT3gRV7hQdXhcy7GMLzp8tJcPgO7x42ffN4HA8IunX321Hd2W/k5imq5iQ0Mwe3zXcs2WTUhPdryGr9lmF6AvX5hd3j3RLsyG0PO5kdkX3IY2cg2inTiKbWJhX+kLjmnJwnPTUSxbe62A4eOc7OiOXW20PNc8I8SUfWHkGD5W13KqvuXhdrnhGfiijBzlRHYJAyOzW/V7Jbt6JuDWluUYls2PLAu4s1bLhy4IfeGiZRmWn+zHzo7u8bPHIfyO4Hah22Z1pmGYDjiCaRkeuILjESKbtqcbngsnADb+NEQLTw3sqmUrLjQs19Ett0pkHYQW2J7g6Q6YpiMLDWg4eLYtzTEN0S2ZaCGmPrJMGxyWGK2u7oHjQMto9XBfrGz6mmwYDrilkiAbjgIMNKBl6dCQe66rvWm5FuP0nJZB0Op6YJcsmWAJPFrHamgfBt3jZ9/BF19lQ9fyZLNnnAktV/M9x1TesNA3up7iGb7yBmAEPtgG8vDBR6T6SBkZpif0TBl0V8Yyjqx7is33DVsWkLMs40YAwzFLXaVPO+t9RWkYFwRGxpnuyHLD6GqWo52UvL7R1xzPsBXf8HTZVUaKCL4xwk/P1C54CXzdcDmsT7PxU6y+MRw6aAW62Ko0ZE8W06LbESZSohM3o8MwoWAbrIsaNmqKxhgay/KGwHN8FVtzbO8J/cEV8YQzkKGiEAFbbSIoUC1hdOA5TdAUgRexDBg6g1VUdQOwGmLoOGFEWhNWp1gG2LgTui+DRNu1qljC1hJ/SoxP4ETRgNZNW0CuxGHDqqBtK2higsGwdPSPIGgs7uVKZ+xOdFuTkx+voQu3otuRnOBfFNpInKKwi6eGRvNRnKPbowkpuVr8DmaRMywfmBnNYOIQDeakNRJajsRFSDRIjGgKtgYkjprRBoYs30knIosxPdoU7zYK93EN0YDmlsYuYjBDUkfYbSnx8MUf19A9/Te5jasJGttYjg7UTPSFXuZayzlWWPkRu+HOEC224yzXE8trB7EtB9yJbtM17MPmd388+zn417MVuqdfBP/+7envm69ht6BD48C0jJoInUTLdFhYtAJnIuuxNLmFbbgu0/HtEJfEGaEUbaX2YtKCuMrl4o0sEDsuCITdL7POoJ3oNvac/PnH99Rnp4+fReie/hl5679++3NDzwnwm9ER5cRm+o7JNxpa/wRZ2A3ddCylpJd813McXM9Aq2XRuCb0bcVwXQwiXV/3XMvyq40GZzcM8M54x9HwfS1nVO03SkrDJg3N9hnX8Xucc9v/x2Bnzwm/Cd3RdLHw3R+I7umvy6WjTZ1OW3pOMPcwPAf8ltWQW6KLxiLzGP+Nku7ZGFw1FxMSMEc9mhSg1Tm+3JV1XdZwgrmG6Tqlhoz5squcIDbQeqwlWMQ9gZKBaQh+CDRjdGDzvj+YdvfXXY8TV7s6gx/h12E8G/cTr3V1bgmw6GKCpfiiL5d03eIwCfA802d8xfQ8TEc40zQUDizM/xtcV8eyjmZ4CqIzbd7QTU8WBM+ziNgQXE0biXJPtHRXxKSsJzgtHZMXcQTPS/ytALvU7g72tcYuvg3x8PptiPiGxcPp9eLbogTLtDwYtTQiy5yCF4rEa4maJWDuj+lD1dJxhiVKFWTN8qpol5xlCBqvV/WqZbAWprWk1OJYIvNGi9MsTWEUXmEMplUCgw5nUcwROIx3y702u9GteezqNkTyzuvyhsX67bMtTV2cnFjRgGA2atBJnKFEQWKRXjBRFhFlG3GeEqUS8RtoATYOLtHKqJJ4PU1QZHR989b/e8buO2LVDcPWr995Xd2VXS/K7Owkvr1T+zj/JOiGW9gb7/4n77zWLu/KrmtbavJ56AZ06x4baXHn9efmtkYuErnthvpuddOYky3DdRZNXgTu6LvNZYD7nO+H3TzSaYvZXd6d2NjILYzus/ZXZusXoBfito+HpU3elkYuUvXzNrqbR3XyOwbE/rilkYvEfuZGl2Is8VaXvUGfO7kUg/+r2Qb/744R3JeptKAvZtWHYbRFKb43oaX9OmdS4m6je/Aojf56GR9B9AiFDLpddinG24va/uSItuuoxW+OH6TR8de0FrEqZkR3u9lRqu+I7c1uN7k90NH+AzTgjOiqtzpaKN03E/dkR7TdH/ffCN2e7G4il0B3TIWT+BdnF5N1dMu66U+8QKJ5iDrZ43WX0OKF+4COjj1ITY69idwluuP3L1++mxy/mtHfBzh//PVxtG4dnVfydMXTeR0EDaIFhhiiAoZHSekc6J4BAr/gppg63BN0yC5tjiLubueoVugehYOv38Lg1fCvl/DgFbyHB/DoUfBy9nYdneLLWp/elobXIlFsU/NFOOMdg97mJiCZ4HimZRrU/AwDNMO4N+gwzq7d5NkoPkUqnEAXTh80m+9rfw1fvnwAg9oxeRSt2+CwrgBdwTG8royoejqcWK03vMP3PVxUzC69s+Es0AGP8O6Lw9LzraYwPFFLc+c1gW7y9rj5jgRvIRg+GD5ovm3+9SiYvT3egk5+AyBROojO1rU+71RF+qQOx7kQXFcmrQU6AuJ9CROxRP6G7JjR0l19JdAF0/eAr+HLV8P3MCBoeZ0gnL4/Xkfn6HAGbgleUzquAiMOLviG4VsOiGeM4jgYyqwIXUkQBO/ehIlYIqfxa4MpEhaXyuSYZIR99e7dK2zY3r59cPwK5x8cv3v3lq7bkJxwDKkStoov8QKHaAgHGPwJHS/Oc/SBKNF1h8jz/D2zOobC47WNz9lhqxqfepREIq87TmR4UZpynFj3OeR1CYnY5qFfJvFRT9aqe1ww/p1S4qsSqe2hov8wS2eq3H4X2n9fdFS0S4ejytK38/dG9x9J/OZVqk6n9v/S6xKRz/rQC/7Oe04+uMTqN/+VSvG5c5quZJF+83XNf6K7eT6GWI3ayBvEL2L2omndV3z6kJ9Jd/Rokf06yO9l//qNNxNzbdWn9UCbe6UcXWblDptZudVlVo4us3J0mZWjy6wcXWbl6DIrR5dZObrMylPizPq/HF1W5eiy6v8BIf8Bzr0Y2pkAAAAASUVORK5CYII=)
4. Setup cli
   Setup gcloud
   ```bash
   gcloud auth login
   gcloud config set project imperial-ally-285602 # EDITME
   ```
5. Provision network   
   ```bash
   cd 005/gcp-network
   terraform apply -auto-approve
   cd ..
   ```
6. Provion GKE
   ```bash
   cd 020-gke-singapore
   terraform apply -auto-approve
   cd ..
   ```
   Could be long so take a cafe, then get kubeconfig and switch kubectx to it with
   ```bash
   # change cluster name or location if needed
   gcloud container clusters get-credentials zero --location=asia-southeast1-a
   ```

7. Prepare elasticsearch certs
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
   (I will commit my ssl certs so you can skip the ca cert management step, in production It **shouldn't** be in the git repo)

   create kube secret for later use

   ```bash
   kubectl delete secret es-ca-certs
   kubectl create secret generic es-ca-certs \
   --from-file=ca.crt=./ssl/ca.crt \
   --from-file=ca.key=./ssl/ca.key
   ```

8. Prepare initial password
   ```bash
   kubectl delete secret es-bootstrap-password
   ES_PASSWORD=pA55w0rd # remember to store it for later use
   kubectl create secret generic es-bootstrap-password --from-literal=password=pA55w0rd
   ```
9. Apply the elasticsearch
   ```bash
   kubectl delete pvc es-workdir-es-{0..2} # delete old data if having any
   kubectl apply -f 040-elasticsearch
   ```
   As node in other zone may not be up yet so pod will be pending for few minutes waiting for node to be provisioned (auto sclaing: enabled).
   As we have prevent it to be in the same node and our topology spreading across zones. So wait for it
   ```shell
   kubectl get pods -o wide 
   NAME       READY   STATUS    RESTARTS   AGE     IP           NODE                                                  NOMINATED NODE   READINESS GATES
   es-0       1/1     Running   0          104s    10.96.0.20   gke-zero-od-e2-standard-2-singapore-a-850c06e3-knxj   <none>           <none>
   es-1       1/1     Running   0          2m19s   10.96.1.7    gke-zero-od-e2-standard-2-singapore-b-248fcdb1-6z2m   <none>           <none>
   es-2       1/1     Running   0          2m41s   10.96.2.7    gke-zero-od-e2-standard-2-singapore-c-cb73ed97-qvln   <none>           <none>
   ```
10. Test with debug pod
    ```bash
    kubectl delete -f 100-debug.yaml
    kubectl apply -f 100-debug.yaml
    kubectl -n default exec -it es-debug -- /bin/sh
    # now we inside the pod

    apk add openssl curl
    
    ES_USER=elastic
    ES_PASSWORD=pA55w0rd
    
    curl --cacert /ca-certs/ca.crt -u $ES_USER:$ES_PASSWORD https://es-0.es-headless.default.svc.cluster.local:9200/_cat/nodes
    curl --cacert /ca-certs/ca.crt -u $ES_USER:$ES_PASSWORD https://es.default.svc.cluster.local:9200/_cat/nodes
    # should see something similar this
    10.96.2.5  11 72 5 0.11 0.22 0.24 cdfhilmrstw - es-2.es-headless.default.svc.cluster.local
    10.96.1.6  49 72 5 0.05 0.37 0.49 cdfhilmrstw * es-1.es-headless.default.svc.cluster.local
    10.96.0.19 17 71 5 1.52 0.91 0.95 cdfhilmrstw - es-0.es-headless.default.svc.cluster.local
    
    curl --cacert /ca-certs/ca.crt -u $ES_USER:$ES_PASSWORD https://es.default.svc.cluster.local:9200/_cluster/health/?pretty
    curl --cacert /ca-certs/ca.crt -u $ES_USER:$ES_PASSWORD https://es-0.es-headless.default.svc.cluster.local:9200/_cluster/health/?pretty
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
- Update the es-config-template to match the wanted number of replicas
- Change the replicas number in statefulset and kubectl apply
- ? Resharding indexes

# Tips and scripts

Just a collection of notes and convenient command while working with elastic search

```bash
kubectl delete pvc es-workdir-es-{0..2}
```

verify the SAN for ssl verification

```bash
openssl x509 -in /data/server.crt -text -noout
# should see the fqdn of the elasticsearch like:
# DNS:es-0.es-headless.default.svc.cluster.local,DNS:es.default.svc.cluster.local
# DNS:es-1.es-headless.default.svc.cluster.local,DNS:es.default.svc.cluster.local
# DNS:es-2.es-headless.default.svc.cluster.local,DNS:es.default.svc.cluster.local
```

# Possible errors

When you create sts: the pv of pvc when claimed will have the node affinity like this

```yaml
nodeAffinity:
  required:
    nodeSelectorTerms:
    - matchExpressions:
      - key: topology.gke.io/zone
        operator: In
        values:
        - asia-southeast1-b
```

So if nodes in other zones are not up and running yet then this pv forever belong to this single region.
And when you use the pod topology spread constraint, It will conflict with volume affinity, ex:
- we have 3 nodes in: `asia-southeast1-a`, `asia-southeast1-b`, `asia-southeast1-c`
- because of the latency first time deploy 3 pods in the same one node in `asia-southeast1-a`
  - all of those pod now belong to that zone `asia-southeast1-a`
  - all 3 pv(s) attached to that pod have node affinity in `asia-southeast1-a`
- now you apply the pod topology spread constraints with the key: `zone`, the result should be 3 pod in 3 nodes in 3 zones
  - but all of the pv in only in one zone `asia-southeast1-a` so the pod in other zones will be pending as pod in `asia-southeast1-b`, `asia-southeast1-b` can not pickup pv in ``asia-southeast1-a`
    > that's what I know at that time, or I don't know how to make it happens

Solution is to remove the pv and re provision cluster again

To prevent this to be happend then at the begining, add the combination of node anti affinity + topology spread constraint so that gke will know what to do.

# Diary

Just some other notes

## day1: provision GCP: network, GKE
1. Provision networks: vpc, subnet, nat gateway (30m)
  - nat gateway for worker in private network can access public internet
2. Provision GKE cluster (15m code + 15m provisioning)
  - control plane singapore
  - worker node in one zone singapore 

## day2: simple elasticsearch cluster using statefulset, no HA, no zones spreading
Using plain manifests to setup elasticsearch cluster with 3 nodes (4h)

1. Prepare elasticseach certs (1h)
   - ~~using volume, create a k8s job to create ssl~~
   - gen ssl local and create k8s secret from file
   - all elastic search using the same ssl file
   - adding member require ssl to be generated again
2. provision the es cluster (3h) (day2)
   - no HA
   - all pods on the same node
   - having trouble with es cluster bootstraping https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-discovery-bootstrap-cluster.html
     as it required the node name to be the same in `cluster.initial_master_nodes` and `discovery.seed_hosts` in es config
   - having some troubles with GKE default storage class doesn't support ReadWriteMany which break my initial idea with managing certs via volume as it will need to share across nodes
3. create a debug pod (5m)
   - be able to query and get cluster info

## day3: ha elasticsearch cluster with 3 members at the same region but span across 3 zones 

1. Reuse networks: reuse the simple setup above
2. Reuse GKE Cluster (1h)
   - Reuse control plane singapore
   - Change node locations of worker node pool in 3 different zones in sinagpore (1h code, fix, provisioning)
3. Reuse plain manifests + constraints, anti affinity to setup HA elasticsearch (1h)
   - Use topology spread constraint to spread pod per node, zone https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/
   - Use pod anti afinity to prevent pods on the same node
   - Add init container to auto gen server cert and signed by ca cert

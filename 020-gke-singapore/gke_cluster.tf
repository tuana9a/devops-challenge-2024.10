resource "google_container_cluster" "zero" {
  name = "zero"
  # │ Error: googleapi: Error 403: Insufficient regional quota to satisfy request: resource "SSD_TOTAL_GB": request requires '300.0' and is short '66.0'. project has a quota of '250.0' with '234.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=imperial-ally-285602.
  # │ Details:
  # │ [
  # │   {
  # │     "@type": "type.googleapis.com/google.rpc.RequestInfo",
  # │     "requestId": "0x17e6c73a06804e63"
  # │   },
  # │   {
  # │     "@type": "type.googleapis.com/google.rpc.ErrorInfo",
  # │     "domain": "container.googleapis.com",
  # │     "reason": "INSUFFICIENT_QUOTA_REGIONAL"
  # │   }
  # │ ]
  # │ , forbidden
  # │ 
  # │   with google_container_cluster.zero,
  # │   on gke_cluster.tf line 1, in resource "google_container_cluster" "zero":
  # │    1: resource "google_container_cluster" "zero" {
  # │ 
  # ╵
  location = "asia-southeast1-a" # NOTE: regional cluster like "asia-southeast1" is not available because of free trial quota limit.
  network  = data.google_compute_network.zero.name
  # │ Error: googleapi: Error 400: Network "zero" uses manual subnet mode and requires specifying a subnetwork.
  # │ Details:
  # │ [
  # │   {
  # │     "@type": "type.googleapis.com/google.rpc.RequestInfo",
  # │     "requestId": "0x55301c0436f6512"
  # │   }
  # │ ]
  # │ , badRequest
  # │ 
  # │   with google_container_cluster.zero,
  # │   on gke_cluster.tf line 1, in resource "google_container_cluster" "zero":
  # │    1: resource "google_container_cluster" "zero" {
  subnetwork = data.google_compute_subnetwork.zero_singapore.name

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false
}

resource "google_container_node_pool" "od_e2_standard_2_singapore_a" {
  name           = "od-e2-standard-2-singapore-a"
  cluster        = google_container_cluster.zero.id
  node_locations = ["asia-southeast1-a"]

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  network_config {
    enable_private_nodes = true
  }

  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 32
  }
}

resource "google_container_node_pool" "od_e2_standard_2_singapore_b" {
  name           = "od-e2-standard-2-singapore-b"
  cluster        = google_container_cluster.zero.id
  node_locations = ["asia-southeast1-b"]

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  network_config {
    enable_private_nodes = true
  }

  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 32
  }
}

resource "google_container_node_pool" "od_e2_standard_2_singapore_c" {
  name           = "od-e2-standard-2-singapore-c"
  cluster        = google_container_cluster.zero.id
  node_locations = ["asia-southeast1-c"]

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  network_config {
    enable_private_nodes = true
  }

  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 32
  }
}


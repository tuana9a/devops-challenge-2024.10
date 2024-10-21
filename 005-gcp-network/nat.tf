resource "google_compute_address" "nat" {
  name = "nat"
}

resource "google_compute_router" "nat" {
  name    = "nat"
  network = google_compute_network.zero.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.nat.name

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.nat.self_link]

  # If ALL_SUBNETWORKS_ALL_IP_RANGES, all of the IP ranges in every Subnetwork are allowed to Nat.
  # If ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, all of the primary IP ranges in every Subnetwork are allowed to Nat.
  # LIST_OF_SUBNETWORKS: A list of Subnetworks are allowed to Nat
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.location

  remove_default_node_pool = true
  initial_node_count       = 1

  network = var.network

  # min_master_version = var.min_master_version
  # node_version       = var.node_version

  monitoring_service = "none"
  logging_service    = "none"

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

# f1-microのサイズはメモリ不足によりGKEのNODEが作成できなくなっていたため、コメントアウト
# resource "google_container_node_pool" "primary_nodes" {
#   name       = "${var.cluster_name}-node-pool"
#   location   = var.location
#   cluster    = google_container_cluster.primary.name
#   node_count = 1

#   management {
#     auto_repair = true
#   }

#   node_config {
#     machine_type = var.machine_type
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring"
#     ]
#   }
# }

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "${var.cluster_name}-preemptible-node-pool"
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  management {
    auto_repair = true
  }

  node_config {
    preemptible  = true
    machine_type = var.preemptible_machine_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    tags = ["${var.cluster_name}-node"]
  }
}
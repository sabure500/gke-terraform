variable "project" {}

variable "cluster_name" {
  default = "my-gke-cluster"
}

variable "location" {
  default = "us-west1-a"
}

variable "machine_type" {
  default = "f1-micro"
}

variable "network" {
  default = "default"
}

variable "min_master_version" {
  default = "1.15.11-gke.3"
}

variable "node_version" {
  default = "1.15.11-gke.3"
}
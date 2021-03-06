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

variable "preemptible_machine_type" {
  default = "e2-small"
}

variable "network" {
  default = "default"
}

variable "min_master_version" {
  default = "1.17.12-gke.1504"
}

variable "node_version" {
  default = "1.17.12-gke.1504"
}
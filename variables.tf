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
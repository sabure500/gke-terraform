variable "project" {}

variable "cluster_name" {
  default = "gke-cluster"
}

variable "location" {
  default = "us-west1-a"
}

variable "machine_type" {
  default = "f1-micro"
}

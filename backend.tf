terraform {
  backend "gcs" {
    bucket = "tf-state-location"
    prefix = "terraform/gke-state"
  }
}
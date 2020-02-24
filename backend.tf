terraform {
  backend "gcs" {
    bucket = "tf-state-location"
    prefix = "gke-state"
  }
}
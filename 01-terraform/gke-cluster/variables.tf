variable "region" {
}

variable "project_id" {
}

variable "gke_location" {
  description = "location of gke cluster nodepool"
}

variable "gke_num_nodes" {
  description = "number of nodes"
  default     = 1
}

variable "gke_num_nodes" {
  default     = ""
  description = "num of gke nodes"
}

variable "region" {
  default     = ""
  description = "region"
}

variable "project_id" {
  default     = ""
  description = "project id"
}

variable "gke_location" {
  default     = ""
  description = "gke location"
}


module "gke" {
  source        = "../../gke-cluster"
  project_id    = var.project_id
  region        = var.region
  gke_num_nodes = var.gke_num_nodes
  gke_location  = var.gke_location
}

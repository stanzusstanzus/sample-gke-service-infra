variable "app_namespaces" {
  description = "list of namespaces to create"
}

locals {
  num_of_envs = length(var.app_namespaces)
}

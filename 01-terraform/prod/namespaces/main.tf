variable "app_namespaces" {
}

module "namespaces" {
  source         = "../../namespaces"
  app_namespaces = var.app_namespaces
}

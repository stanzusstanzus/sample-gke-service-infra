resource "kubernetes_namespace" "app-namespaces" {
  count = local.num_of_envs

  metadata {
    labels = {
      name = element(var.app_namespaces, count.index)
    }

    name = element(var.app_namespaces, count.index)
  }
}

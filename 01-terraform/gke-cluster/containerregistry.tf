resource "google_project_service" "gcr" {
  project = var.project_id
  service = "containerregistry.googleapis.com"

  disable_dependent_services = true
}

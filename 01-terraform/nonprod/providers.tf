
terraform {
  required_version = ">= 0.12"
}

provider "kubernetes" {
  version = "~>1.13"
}

provider "google" {
  version = "~>3.51"
}

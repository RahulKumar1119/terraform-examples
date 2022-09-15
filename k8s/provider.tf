provider "aws" {
  region  = var.region
  profile = var.profile
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

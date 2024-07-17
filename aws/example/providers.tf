provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Managed-By = "Terraform"
      VCS = "git@github.com:hajdukd/goinfra.git"
    }
  }
}
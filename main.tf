terraform {
  required_version = ">=1.0.7"
  required_providers {
    aws = ">=3.50.0"
    tfe = ">=0.24.1"
  }

  backend "remote" {
  }
}

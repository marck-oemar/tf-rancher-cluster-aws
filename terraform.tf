terraform {
  backend "s3" {
    region  = "eu-west-1"
    encrypt = false
  }
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 1.13"
    }
  }
}

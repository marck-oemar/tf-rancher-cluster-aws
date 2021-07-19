provider "rancher2" {
  api_url = var.rancher-url
  token_key = var.rancher-token
  insecure = true
}

provider "aws" {
  region = var.aws-region
}
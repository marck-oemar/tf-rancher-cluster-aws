provider "rancher2" {
  api_url   = var.rancher_url
  token_key = var.rancher_token
  insecure  = true
}

provider "aws" {
  region = var.aws-region
}

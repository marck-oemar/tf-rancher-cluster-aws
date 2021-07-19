# to keep AWS credentials out of tfstate, we expect a (manually created) AWS Cloud credential to already be created in Rancher 
data "rancher2_cloud_credential" "aws" {
    name = var.rancher-aws-cloud-credential-name
}

data "aws_vpc" "active_vpc" {
  state = "available"

  tags = {
    Name = var.vpc_tag
  }
}

data "aws_subnet" "subnet" {
  id = var.subnet_id
}

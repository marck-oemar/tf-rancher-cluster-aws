
variable "clustername" {
  description = "clustername. must be unique. can be interpolated with branch name"
  type        = string
}

variable "ctrl-node-quantity" {
  description = "how many"
  type        = string
  default     = 1
}

variable "etcd-node-quantity" {
  description = "how many"
  type        = string
  default     = 1
}

variable "worker-node-quantity" {
  description = "how many"
  type        = string
  default     = 2
}

variable "dockerurl" {
  type    = string
  default = "https://releases.rancher.com/install-docker/20.10.sh"
}



#### Rancher specific variables 
variable "rancher_aws_cloud_credential_name" {
  type        = string
  description = "Existing Rancher AWS Cloud credential name. Related to AWS credential keys of powerful role, to create AWS resources for RKE"
  sensitive   = true
}

variable "rancher_url" {
  type        = string
  description = "rancher url"
  sensitive   = true
}

variable "rancher_token" {
  type        = string
  description = "rancher token"
  sensitive   = true
}


#### AWS specific variables
variable "ami" {
  description = "ami to be used"
  type        = string
}

variable "ami-ssh-user" {
  description = "sshuser to login of the ami"
  type        = string
}

variable "aws-region" {
  type        = string
  description = "AWS region used for all resources"
}

variable "vpc_tag" {
  type = string
  #sensitive = true
}

variable "subnet_id" {
  type = string
}

variable "aws-zone" {
  description = "AWS zone for instance (i.e. a,b,c,d,e) (string)"
  type        = string
}

#### Variables for Amazon Cloud Provider https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/cloud-providers/amazon/ 
variable "controlplane_node_iam_instance_profile" {
  type      = string
  sensitive = true
}

variable "etcd_node_iam_instance_profile" {
  type      = string
  sensitive = true
}

variable "worker_node_iam_instance_profile" {
  type      = string
  sensitive = true
}

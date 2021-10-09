variable "role_id" {
  type        = string
  description = "ID used to identify the resources, for instance ctrl, etcd or worker"
}

variable "clustername" {
  type        = string
  description = "name of cluster to make the resources unique"
}

variable "assume_role_policy_template_file" {
  type = string
}

variable "policy_template_file" {
  type = string
}

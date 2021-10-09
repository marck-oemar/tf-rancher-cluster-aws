data "aws_caller_identity" "current" {}

module "iam_role_controlplane" {
  source     = "./modules/iam-role"
  role_id = "rancher-ctrl"
  clustername = var.clustername
  assume_role_policy_template_file = templatefile("${path.module}/policies/assume-role-policy.json.tmpl",{})
  policy_template_file = templatefile("${path.module}/policies/ctrl-role-policy.json.tmpl",{})
}

module "iam_role_etcd_or_worker" {
  source     = "./modules/iam-role"
  role_id = "rancher-etcd-or-worker"
  clustername = var.clustername
  assume_role_policy_template_file = templatefile("${path.module}/policies/assume-role-policy.json.tmpl",{})
  policy_template_file = templatefile("${path.module}/policies/etcd-or-worker-role-policy.json.tmpl",{})
}

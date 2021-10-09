module "iam_example" {
  source     = "./.."
  role_id = "rancher-example-role"
  clustername = "examplecluster"
  assume_role_policy_template_file = templatefile("${path.module}/assume-role-policy.json.tmpl",{})
  policy_template_file = templatefile("${path.module}/example-role-policy.json.tmpl",{})
}

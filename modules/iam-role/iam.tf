data "aws_caller_identity" "current" {}

data "template_file" "assume-role-policy" {
  vars = {
    account_id = "${data.aws_caller_identity.current.account_id}"
  }

  template = var.assume_role_policy_template_file
}

resource "aws_iam_role" "role" {
  name               = "tf-${var.role_id}-${var.clustername}"
  assume_role_policy = data.template_file.assume-role-policy.rendered
}

resource "aws_iam_instance_profile" "profile" {
  name = "tf-${var.role_id}-${var.clustername}"
  role = aws_iam_role.role.name
}

data "template_file" "role_policy" {
  template = var.policy_template_file
}

resource "aws_iam_policy" "role_policy" {
  name_prefix = "tf-${var.role_id}-${var.clustername}"
  policy      = data.template_file.role_policy.rendered
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.role_policy.arn
}



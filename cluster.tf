
resource "aws_security_group" "rancher-nodes" {
  name                   = "ec2-node-rancher-${var.clustername}"
  revoke_rules_on_delete = true
  vpc_id                 = data.aws_vpc.active_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#################
# Rancher cluster
resource "rancher2_cluster" "cluster_ec2" {
  name        = var.clustername
  description = "Terraformed cluster"
  rke_config {
    network {
      plugin = "canal"
    }
    #kubernetes_version = var.k8version
    cloud_provider {
      name = "aws"
    }
    ignore_docker_version = false

    services {
      etcd {
        backup_config {
          enabled = false
        }
      }
      kubelet {
        extra_args = {
          max_pods = 70
        }
      }
    }
  }
  depends_on = [rancher2_node_template.marck-rancher-controlplane, rancher2_node_template.marck-rancher-etcd, rancher2_node_template.marck-rancher-worker]
}



resource "rancher2_node_template" "marck-rancher-controlplane" {
  name                = "ec2-node-rancher-control-${var.clustername}"
  cloud_credential_id = data.rancher2_cloud_credential.aws.id
  engine_install_url  = var.dockerurl
  amazonec2_config {
    ami                  = var.ami
    ssh_user             = var.ami-ssh-user
    region               = var.aws-region
    security_group       = ["ec2-node-rancher-${var.clustername}"]
    subnet_id            = data.aws_subnet.subnet.id
    vpc_id               = data.aws_vpc.active_vpc.id
    zone                 = var.aws-zone
    root_size            = 16
    instance_type        = "t2.medium"
    iam_instance_profile = var.controlplane-node-iam-instance-profile
  }
}

resource "rancher2_node_template" "marck-rancher-etcd" {
  name                = "ec2-node-rancher-etcd-${var.clustername}"
  cloud_credential_id = data.rancher2_cloud_credential.aws.id
  engine_install_url  = var.dockerurl
  amazonec2_config {
    ami                  = var.ami
    ssh_user             = var.ami-ssh-user
    region               = var.aws-region
    security_group       = ["ec2-node-rancher-${var.clustername}"]
    subnet_id            = data.aws_subnet.subnet.id
    vpc_id               = data.aws_vpc.active_vpc.id
    zone                 = var.aws-zone
    root_size            = 16
    instance_type        = "t2.medium"
    iam_instance_profile = var.etcd-node-iam-instance-profile
  }
}

resource "rancher2_node_template" "marck-rancher-worker" {
  name                = "ec2-node-rancher-worker-${var.clustername}"
  cloud_credential_id = data.rancher2_cloud_credential.aws.id
  engine_install_url  = var.dockerurl
  amazonec2_config {
    ami                  = var.ami
    ssh_user             = var.ami-ssh-user
    region               = var.aws-region
    security_group       = ["ec2-node-rancher-${var.clustername}"]
    subnet_id            = data.aws_subnet.subnet.id
    vpc_id               = data.aws_vpc.active_vpc.id
    zone                 = var.aws-zone
    root_size            = 16
    instance_type        = "t2.medium"
    iam_instance_profile = var.worker-node-iam-instance-profile
  }
}





######

resource "rancher2_node_pool" "ctrl" {
  cluster_id       = rancher2_cluster.cluster_ec2.id
  name             = "ctrl"
  hostname_prefix  = "rancher-ctrl-${var.clustername}-"
  node_template_id = rancher2_node_template.marck-rancher-controlplane.id
  quantity         = var.ctrl-node-quantity
  control_plane    = true
  etcd             = false
  worker           = false
}

resource "rancher2_node_pool" "etcd" {
  cluster_id       = rancher2_cluster.cluster_ec2.id
  name             = "etcd"
  hostname_prefix  = "rancher-etcd-${var.clustername}-"
  node_template_id = rancher2_node_template.marck-rancher-etcd.id
  quantity         = var.etcd-node-quantity
  control_plane    = false
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "worker" {
  cluster_id       = rancher2_cluster.cluster_ec2.id
  name             = "worker"
  hostname_prefix  = "rancher-worker-${var.clustername}-"
  node_template_id = rancher2_node_template.marck-rancher-worker.id
  quantity         = var.worker-node-quantity
  control_plane    = false
  etcd             = false
  worker           = true
}

resource "rancher2_cluster_sync" "cluster" {
  cluster_id    = rancher2_cluster.cluster_ec2.id
  node_pool_ids = [rancher2_node_pool.ctrl.id, rancher2_node_pool.etcd.id, rancher2_node_pool.worker.id]
}

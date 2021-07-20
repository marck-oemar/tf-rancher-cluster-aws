# Create a RKE cluster on EC2 AWS with Terraform
This repo contains terraform config to manage a v2.x RKE cluster on EC2 AWS.
Be clear, the config is only a concept, and *not* production ready.

The config is based on Ranchers documentation: 
- https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/node-pools/ec2/
- https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/cloud-providers/amazon/

## Used technology
- https://aws.amazon.com/ec2/
- https://aws.amazon.com/iam/
- https://rancher.com
- https://rancher.com/docs/rke/latest/en/config-options/cloud-providers/aws/
- https://github.com/rancher/machine
- https://kubernetes.io
- https://www.selenium.dev
- https://docs.pytest.org/en/6.2.x/


## Stack resources
The Terraform config will create the following resources.

### Rancher resources
- 3 node templates (controlplane, etcd, worker)
- a RKE cluster
- 3 node pools (controlplane, etcd, worker)

### AWS resources
- 1 cluster specific rancher-nodes Security Group
- TODO: 3 IAM roles (and instance profile) with specific policies for controlplane, etcd, worker. These roles will be attached to the cluster nodes, and will be used by the Kubernetes Amazon Cloud Provider.

## Design
All the heavy lifting is done by Rancher, which we expect to be available with a powerful user.

## Seperation of concern
For seperation of concern, some resources are decoupled and scoped out of this terraform, and should be managed seperately.

### Rancher specific resources
- API token
- Rancher AWS Cloud credentials that relies on a AWS powerful IAM user with credential keys (we don't want this in Terraform)

### AWS specific resources
- AWS powerful IAM user with credential keys for Rancher AWS Cloud credential
- VPC
- Subnet

## Usage
Simply assign the variables and terraform apply.

## Quirk: Delete Nodepools/Cluster
- deletion of nodepools before deletion of cluster does not delete actual AWS ec2 nodes, more precise: when deleting a nodepool, Rancher does not delete the AWS ec2 nodes.
- What does work is deleting the entire cluster, which will signal Rancher Machine (=Docker Machine fork) to terminate the ec2 nodes. In other words, delete cluster is a first class orchestration activity.

- Terraform work around for cluster deletion (this will work): 
  1. remove the node pools from tf state
  2. terraform destroy

Also, deleting the Security Group will take a while because of referenced EC2 instances. AWS takes a few minutes to completely terminate and delete EC2 Instance resources.

## CICD pipeline with Github Actions
The Github Actions pipeline contains an end-2-end approach:
- Deploy a staging RKE cluster. If this fails, we know there is a problem with the code and/or the AWS / Rancher context
- Deploy a hello-world application with a Service that invokes Amazon Cloud Provider to create a traditional L4 Loadbalancer as an endpoint
- Acceptance test the application, using (overkill) Selenium
- Clean-up


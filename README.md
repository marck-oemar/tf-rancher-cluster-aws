# Create a RKE cluster on EC2 AWS with Terraform
This repo contains terraform config to manage a v2.x RKE cluster on EC2 AWS.
Be clear, the config is only a concept, and *not* production ready.

The config is based on Ranchers documentation: 
- https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/node-pools/ec2/
- https://rancher.com/docs/rancher/v2.x/en/cluster-provisioning/rke-clusters/cloud-providers/amazon/


## Stack resources
The Terraform config will create the following resources.

### Rancher resources
- 3 node templates (controlplane, etcd, worker)
- a RKE cluster
- 3 node pools (controlplane, etcd, worker)

### AWS resources
TODO: 
- 1 cluster specific rancher-nodes Security Group
- 3 IAM roles (and instance profile) with specific policies for controlplane, etcd, worker. These roles will be attached to the cluster nodes, and will be used by the Kubernetes Amazon Cloud Provider.

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

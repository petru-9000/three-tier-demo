# Three tier app deployment demo with Terraform in AWS

### Caveats

I do not have a lot of experience with either Terraform or AWS. This code is here since it was required by the challenge, it validates, but I do not have an AWS account, so it's not tested.

A complete production setup would include a bastion, gateway, public and private subnets, perhaps autoscaling groups, etc. To keep things simple the default VPC is used, a single subnet is created (the user should provide the CIDR block in `demo_cidr_block` and availability zone in `subnet_az`), and security groups allow SSH from all IP's, but app internal ports (db, backend) are limited to the created subnet.

### Assumptions

- SSH key pair for AWS EC2 access is available; public key will be supplied at prompt, or saved into `demo.tfvars` in `demo_pub_key`.
- default user on AMI is named `ubuntu` and has passwordless sudo (for Ansible) (this could be ensured by cloud-init if it changes).
- default VPC exists

### Steps

- set region
- maintain SSH key (save pub to AWS if absent)
- adopt default VPC
- create a subnet in the default VPC
- create security groups
- create three server instances with relevant params (ami, security groups, flavours etc.)
- create Ansible inventory and vars file via `local_file` resource from supplied variables (prefixed with `ansible_`)
- run the Ansible playbook via `local-exec`

### Setup

```
export AWS_ACCESS_KEY_ID="yourAccessKey"
export AWS_SECRET_ACCESS_KEY="yourSecretKey"
export AWS_REGION="yourAWSRegion"
```

### Run

```
terraform init
terraform validate
terraform plan
terraform apply
```

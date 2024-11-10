provider "aws" {
  region = var.aws_region
}

# get SSH public key
resource "aws_key_pair" "demo_key" {
  key_name   = "demo_key"
  public_key = var.demo_pub_key
}


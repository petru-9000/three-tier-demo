# select latest Ubuntu 22.04 AMI from vendor, for all servers
data "aws_ami" "demo_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# create web server instance
resource "aws_instance" "demo_web" {
  ami                         = data.aws_ami.demo_ami.id
  instance_type               = var.web_flavor
  subnet_id                   = aws_subnet.demo_subnet.id
  key_name                    = var.demo_pub_key
  vpc_security_group_ids      = ["${aws_security_group.demo_web_sg.id}"]
  associate_public_ip_address = true

  tags = {
    Name = "demo_web"
  }
}

# create app server instance
resource "aws_instance" "demo_app" {
  ami                    = data.aws_ami.demo_ami.id
  instance_type          = var.app_flavor
  subnet_id              = aws_subnet.demo_subnet.id
  key_name               = var.demo_pub_key
  vpc_security_group_ids = ["${aws_security_group.demo_app_sg.id}"]

  tags = {
    Name = "demo_app"
  }
}

# create db server instance
resource "aws_instance" "demo_db" {
  ami                    = data.aws_ami.demo_ami.id
  instance_type          = var.app_flavor
  subnet_id              = aws_subnet.demo_subnet.id
  key_name               = var.demo_pub_key
  vpc_security_group_ids = ["${aws_security_group.demo_db_sg.id}"]

  tags = {
    Name = "demo_db"
  }
}

# adopt default vpc
resource "aws_default_vpc" "default" {

  tags = {
    Name = "Default VPC"
  }
}

# create a subnet for the demo
resource "aws_subnet" "demo_subnet" {
  availability_zone = var.subnet_az
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = var.demo_cidr_block

  tags = {
    Name = "demo_subnet"
  }
}

# create security groups
resource "aws_security_group" "demo_web_sg" {
  name   = "demo_web_sg"
  vpc_id = aws_default_vpc.default.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "demo_app_sg" {
  name   = "demo_app_sg"
  vpc_id = aws_default_vpc.default.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.demo_cidr_block] # accept from same subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.demo_cidr_block] # to same subnet
  }
}

resource "aws_security_group" "demo_db_sg" {
  name   = "demo_db_sg"
  vpc_id = aws_default_vpc.default.id

  # SSH access from the VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.demo_cidr_block] # accept from same subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.demo_cidr_block] # to same subnet
  }
}

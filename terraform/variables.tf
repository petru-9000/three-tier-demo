variable "demo_pub_key" {
  description = "public key for instances"
  type        = string
}

variable "demo_private_key_file" {
  description = "private key for instances"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "subnet_az" {
  description = "availability zone of subnet"
  type        = string
}

variable "demo_cidr_block" {
  description = "CIDR block for demo subnet"
  type        = string
}

variable "web_flavor" {
  description = "size of web ami"
  type        = string
}

variable "app_flavor" {
  description = "size of app ami"
  type        = string
}

variable "db_flavor" {
  description = "size of db ami"
  type        = string
}

variable "ami_default_user" {
  description = "default nopasswd user on selected ami"
  type        = string
}

# ansible --------------------------------------------------------

variable "ansible_vault_pass_file" {
  description = "path to file containing ansible vault password"
  type        = string
}

# Frontend
variable "ansible_apache_http_port" {
  description = "apache http port"
  type        = string
}
variable "ansible_apache_https_port" {
  description = "apache https port"
  type        = string
}

# Backend
variable "ansible_python_version" {
  description = "version of python to install"
  type        = string
}

# Database
variable "ansible_postgresql_version" {
  description = "version of postgresql to install"
  type        = string
}

# Application
# Frontend
variable "ansible_backend_endpoint" {
  description = "backend endpoint, without protocol, hostname, and port"
  type        = string
}

# Backend & Database
variable "ansible_db_fqdn" {
  description = "FQDN of db"
  type        = string
}
variable "ansible_db_name" {
  description = "database name"
  type        = string
}
variable "ansible_db_user" {
  description = "database user"
  type        = string
}
variable "ansible_db_password" {
  description = "database password"
  type        = string
}

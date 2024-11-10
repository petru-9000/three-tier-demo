# create ansible hosts file from instance outputs
resource "local_file" "demo_ansible_inventory" {
  depends_on = [
    aws_instance.demo_web,
    aws_instance.demo_app,
    aws_instance.demo_db
  ]
  content  = <<-EOF
all:
  vars:
    ansible_host_key_checking: false
  hosts:
    demo-web:
      ansible_host: "${aws_instance.demo_web.private_ip}"
      ansible_user: "ubuntu"
      ansible_ssh_private_key_file: "${var.demo_private_key_file}"
    demo-app:
      ansible_host: "${aws_instance.demo_app.private_ip}"
      ansible_user: "ubuntu"
      ansible_ssh_private_key_file: "${var.demo_private_key_file}"
    demo-db:
      ansible_host: "${aws_instance.demo_db.private_ip}"
      ansible_user: "ubuntu"
      ansible_ssh_private_key_file: "${var.demo_private_key_file}"
  EOF
  filename = "../ansible/inventory-terraform.yml"
}

# create ansible var file to be included from the playbook
resource "local_file" "demo_ansible_vars" {
  depends_on = [local_file.demo_ansible_inventory]
  content    = <<-EOF
---
# Variables from terraform.
# Frontend
demo_apache_http_port: ${var.ansible_apache_http_port}
demo_apache_https_port: ${var.ansible_apache_https_port}

# Backend
demo_python_version: ${var.ansible_python_version}

# Database
demo_postgresql_version: ${var.ansible_postgresql_version}

# Application
# Frontend
demo_backend_endpoint: "http://${aws_instance.demo_app.private_ip}$:5000{var.ansible_backend_endpoint}"

# Backend & Database
demo_db_fqdn: ${var.ansible_db_fqdn}
demo_db_name: ${var.ansible_db_name}
demo_db_user: ${var.ansible_db_user}
demo_db_password: ${var.ansible_db_password}
  EOF
  filename   = "../ansible/vars-terraform.yml"
}

# run ansible
resource "null_resource" "demo_ansible" {
  depends_on = [local_file.demo_ansible_vars]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.ami_default_user
      host        = aws_instance.demo_web.private_ip
      private_key = file(var.demo_private_key_file)
      timeout     = "10m"
    }
    inline = ["echo 'Connection successful'"]
  }

  # we can include the private key on the command line, or in the inventory
  provisioner "local-exec" {
    command = join(" ",
      [
        "ansible-playbook",
        "-i ${local_file.demo_ansible_inventory.filename}",
        "-e ${local_file.demo_ansible_vars.filename}",
        "--vault-password-file ${var.ansible_vault_pass_file}",
        "../ansible/playbook.yml"
      ]
    )
  }
}


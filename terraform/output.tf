output "Webserver" {
  value = "${aws_instance.demo_web.public_dns} - ${aws_instance.demo_web.public_ip}:${var.ansible_apache_http_port}"
}

output "Backend" {
  value = "${aws_instance.demo_app.private_dns} - ${aws_instance.demo_web.private_ip}:5000"
}

output "Database" {
  value = "${aws_instance.demo_db.private_dns} - ${aws_instance.demo_db.private_ip}:5432"
}

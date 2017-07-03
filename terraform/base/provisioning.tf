resource "aws_key_pair" "ansible" {
  key_name = "rabble_rouser_ansible_key"
  public_key = "${file(var.public_key_path)}"
}

resource "null_resource" "base_provisioner" {
  # Only do this after the DNS record has been created
  depends_on = ["aws_route53_record.bare_domain"]

  triggers {
    # Re-provision this whenever a new EC2 instance is created
    instance = "${aws_instance.web.id}"
  }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i ${aws_eip.eip.public_ip}, -u ubuntu --private-key='${var.private_key_path}' ../ansible/main.yml -v
EOF
  }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      CERT_EMAIL='${var.tls_cert_email}' \
      APP_DOMAIN='${aws_route53_record.bare_domain.fqdn}' \
      APP_PORT='3000' \
      ansible-playbook -i ${aws_eip.eip.public_ip}, -u ubuntu --private-key='${var.private_key_path}' ../ansible/app-proxy.yml -v
EOF
  }
}

resource "null_resource" "app_proxy_provisioner" {
  depends_on = ["aws_route53_record.app_domain"]

  # triggers {
    # instance = "${aws_instance.web.id}"
  # }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      CERT_EMAIL='${var.tls_cert_email}' \
      APP_DOMAIN='${aws_route53_record.app_domain.fqdn}' \
      APP_PORT='${var.port}' \
      ansible-playbook -i ${var.host_ip}, -u ubuntu --private-key='${var.private_key_path}' ../ansible/app-proxy.yml -v
EOF
  }
}

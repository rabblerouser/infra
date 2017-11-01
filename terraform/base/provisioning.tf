resource "aws_key_pair" "ansible" {
  key_name = "rabble_rouser_ansible_key"
  public_key = "${file(var.public_key_path)}"
}

resource "null_resource" "base_provisioner" {
  triggers {
    # Re-provision when these values change
    instance = "${aws_instance.web.id}"
    docker_api_key = "${tls_private_key.docker_key.private_key_pem}"
    docker_api_ca = "${tls_self_signed_cert.docker_ca.cert_pem}"
    docker_api_cert = "${tls_locally_signed_cert.docker_cert.cert_pem}"
  }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      DOCKER_API_KEY='${tls_private_key.docker_key.private_key_pem}' \
      DOCKER_API_CA='${tls_self_signed_cert.docker_ca.cert_pem}' \
      DOCKER_API_CERT='${tls_locally_signed_cert.docker_cert.cert_pem}' \
      ansible-playbook -i ${aws_instance.web.public_ip}, -u ubuntu --private-key='${var.private_key_path}' ../ansible/main.yml -v
EOF
  }
}

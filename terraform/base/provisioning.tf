resource "tls_private_key" "ec2_ssh_key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "ec2_ssh_key_pair" {
  key_name = "rabble_rouser_ec2_ssh_key_pair"
  public_key = "${tls_private_key.ec2_ssh_key.public_key_openssh}"
}

resource "local_file" "ec2_ssh_key_file" {
  filename = "${path.cwd}/.tf_remote_files/ec2_ssh_key"
  content = "${tls_private_key.ec2_ssh_key.private_key_pem}"
}

resource "null_resource" "chmod_private_key_file" {
  provisioner "local-exec" {
    command = "chmod 600 ${local_file.ec2_ssh_key_file.filename}"
  }
}

locals {
  firewall_ports = "${concat(values(var.app_ports), local.instance_global_ingress)}"
}

resource "null_resource" "provisioner" {
  depends_on = ["null_resource.chmod_private_key_file"]
  triggers {
    # Re-provision when these values change
    instance = "${aws_instance.web.id}"
    firewall_ports = "${join(",", local.firewall_ports)}"
    docker_api_key = "${tls_private_key.docker_key.private_key_pem}"
    docker_api_ca = "${tls_self_signed_cert.docker_ca.cert_pem}"
    docker_api_cert = "${tls_locally_signed_cert.docker_cert.cert_pem}"
  }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      OPEN_PORTS='${join(",", local.firewall_ports)}' \
      DOCKER_API_KEY='${tls_private_key.docker_key.private_key_pem}' \
      DOCKER_API_CA='${tls_self_signed_cert.docker_ca.cert_pem}' \
      DOCKER_API_CERT='${tls_locally_signed_cert.docker_cert.cert_pem}' \
      ansible-playbook -i ${aws_instance.web.public_ip}, -u ubuntu --private-key='${local_file.ec2_ssh_key_file.filename}' ../ansible/main.yml -v
EOF
  }
}

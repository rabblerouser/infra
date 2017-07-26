resource "tls_private_key" "docker_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "docker_ca" {
  key_algorithm = "${tls_private_key.docker_key.algorithm}"
  private_key_pem = "${tls_private_key.docker_key.private_key_pem}"
  subject {
    common_name = "docker-ca.${var.domain}"
  }
  ip_addresses = ["${aws_eip.eip.public_ip}"]
  validity_period_hours = "43800" # 5 years
  is_ca_certificate = true
  allowed_uses = [
    "cert_signing",
    "signing",
    "key encipherment",
    "server auth",
    "client auth"
  ]
}

resource "tls_cert_request" "docker_cert_request" {
  key_algorithm = "${tls_private_key.docker_key.algorithm}"
  private_key_pem = "${tls_private_key.docker_key.private_key_pem}"
  subject {
    common_name = "docker.${var.domain}"
  }
  ip_addresses = ["${aws_eip.eip.public_ip}"]
}

resource "tls_locally_signed_cert" "docker_cert" {
  cert_request_pem = "${tls_cert_request.docker_cert_request.cert_request_pem}"
  ca_key_algorithm = "${tls_private_key.docker_key.algorithm}"
  ca_private_key_pem = "${tls_private_key.docker_key.private_key_pem}"
  ca_cert_pem = "${tls_self_signed_cert.docker_ca.cert_pem}"
  validity_period_hours = "43800" # 5 years
  allowed_uses = [
    "signing",
    "key encipherment",
    "server auth",
    "client auth"
  ]
}

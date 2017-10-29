resource "tls_private_key" "lets_encrypt_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "lets_encrypt_registration" {
  server_url = "https://acme-v01.api.letsencrypt.org/directory"
  account_key_pem = "${tls_private_key.lets_encrypt_private_key.private_key_pem}"
  email_address = "${var.tls_cert_email}"
}

resource "acme_certificate" "bare_domain_cert" {
  server_url = "https://acme-v01.api.letsencrypt.org/directory"
  account_key_pem = "${tls_private_key.lets_encrypt_private_key.private_key_pem}"
  registration_url = "${acme_registration.lets_encrypt_registration.id}"

  common_name = "${var.domain}"
  dns_challenge {
    provider = "route53"
  }
}

resource "aws_iam_server_certificate" "bare_server_cert" {
  name_prefix = "${var.domain}-server-cert"
  private_key = "${acme_certificate.bare_domain_cert.private_key_pem}"
  certificate_body = "${acme_certificate.bare_domain_cert.certificate_pem}"
  certificate_chain = "${acme_certificate.bare_domain_cert.issuer_pem}"

  lifecycle {
    # See the docs for this tf resource type for why this is here
    create_before_destroy = true
  }
}

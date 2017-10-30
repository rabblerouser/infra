resource "tls_private_key" "lets_encrypt_private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "lets_encrypt_registration" {
  server_url = "https://acme-v01.api.letsencrypt.org/directory"
  account_key_pem = "${tls_private_key.lets_encrypt_private_key.private_key_pem}"
  email_address = "${var.tls_cert_email}"
}

resource "acme_certificate" "tls_cert" {
  server_url = "https://acme-v01.api.letsencrypt.org/directory"
  account_key_pem = "${tls_private_key.lets_encrypt_private_key.private_key_pem}"
  registration_url = "${acme_registration.lets_encrypt_registration.id}"

  # TODO: Replace all this with a single wildcard cert once let's encrypt supports it in Jan '17
  common_name = "${var.domain}"
  subject_alternative_names = [
    "core.${var.domain}",
    "mailer.${var.domain}",
    "group-mailer.${var.domain}"
  ]
  dns_challenge {
    provider = "route53"
  }
}

resource "aws_iam_server_certificate" "server_cert" {
  name_prefix = "${var.domain}-server-cert"
  private_key = "${acme_certificate.tls_cert.private_key_pem}"
  certificate_body = "${acme_certificate.tls_cert.certificate_pem}"
  certificate_chain = "${acme_certificate.tls_cert.issuer_pem}"

  lifecycle {
    # See the docs for this tf resource type for why this is here
    create_before_destroy = true
  }
}

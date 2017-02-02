resource "aws_key_pair" "ansible" {
  key_name = "rabble_rouser_ansible_key"
  public_key = "${file(var.public_key_path)}"
}

resource "null_resource" "provisioner" {
  # Only do this after the DNS record has been created
  depends_on = ["aws_route53_record.domain"]

  triggers {
    # Re-provision this whenever a new EC2 instance is created
    instance = "${aws_instance.web.id}"

    # Re-provision when any event auth token changes
    core_event_auth_token = "${random_id.rabblerouser_core_event_forwarder_auth_token.hex}"
    mailer_event_auth_token = "${random_id.rabblerouser_mailer_event_forwarder_auth_token.hex}"
  }

  provisioner "local-exec" {
    command = <<EOF
      ANSIBLE_HOST_KEY_CHECKING=False \
      \
      DOMAIN='${var.domain}' \
      CERT_EMAIL='${var.tls_cert_email}' \
      \
      CORE_APP_GIT_SHA='${var.core_app_git_sha}' \
      CORE_DATABASE_URL='postgres://${aws_db_instance.db.username}:${aws_db_instance.db.password}@${aws_db_instance.db.address}:${aws_db_instance.db.port}/${aws_db_instance.db.name}' \
      CORE_SESSION_SECRET='${var.session_secret}' \
      CORE_AWS_ACCESS_KEY_ID='${aws_iam_access_key.rabblerouser_core_keys.id}' \
      CORE_AWS_SECRET_ACCESS_KEY='${aws_iam_access_key.rabblerouser_core_keys.secret}' \
      CORE_EVENT_AUTH_TOKEN='${random_id.rabblerouser_core_event_forwarder_auth_token.hex}' \
      \
      MAILER_APP_GIT_SHA='${var.mailer_app_git_sha}' \
      MAILER_AWS_ACCESS_KEY_ID='${aws_iam_access_key.rabblerouser_mailer_keys.id}' \
      MAILER_AWS_SECRET_ACCESS_KEY='${aws_iam_access_key.rabblerouser_mailer_keys.secret}' \
      MAILER_EVENT_AUTH_TOKEN='${random_id.rabblerouser_mailer_event_forwarder_auth_token.hex}' \
      MAILER_EMAIL_FROM_ADDRESS='${var.email_from_address}' \
      \
      ansible-playbook -i ${aws_eip.eip.public_ip}, -u ubuntu --private-key='${var.private_key_path}' ../ansible/main.yml -v
EOF
  }
}

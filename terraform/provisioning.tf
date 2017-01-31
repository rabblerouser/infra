resource "aws_key_pair" "ansible" {
  key_name = "rabble_rouser_ansible_key"
  public_key = "${file(var.public_key_path)}"
}

resource "null_resource" "provisioner" {
  # Only do this after the DNS record has been created
  depends_on = ["aws_route53_record.domain"]

  triggers {
    # Redo this whenever a new EC2 instance is created
    instance = "${aws_instance.web.id}"
  }

  provisioner "local-exec" {
    command = "
      ANSIBLE_HOST_KEY_CHECKING=False \\
      \\
      DOMAIN='${var.domain}' \\
      CERT_EMAIL='${var.tls_cert_email}' \\
      APP_GIT_SHA='${var.app_git_sha}' \\
      \\
      DATABASE_URL='postgres://${aws_db_instance.db.username}:${aws_db_instance.db.password}@${aws_db_instance.db.address}:${aws_db_instance.db.port}/${aws_db_instance.db.name}' \\
      SESSION_SECRET='${var.session_secret}' \\
      \\
      AWS_ACCESS_KEY_ID='${aws_iam_access_key.rabblerouser_core_keys.id}' \\
      AWS_SECRET_ACCESS_KEY='${aws_iam_access_key.rabblerouser_core_keys.secret}' \\
      \\
      ansible-playbook -i ${aws_eip.eip.public_ip}, -u ubuntu --private-key='${var.private_key_path}' ../ansible/main.yml -v
    "
  }
}

module "mailer_app" {
  source = "./docker-node-app"
  name = "mailer"
  docker_image = "rabblerouser/mailer"
  port = "3001"
  host_ip = "${var.host_ip}"
  stream_arn = "${var.stream_arn}"
  archive_bucket_arn = "${var.archive_bucket_arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  private_key_path = "${var.private_key_path}"
  stream_name = "${var.stream_name}"
  archive_bucket_name = "${var.archive_bucket_name}"
}

resource "aws_iam_user_policy" "mailer_send_ses_email" {
  name = "send_ses_email"
  user = "${module.mailer_app.aws_user_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action": "ses:SendEmail",
      "Resource": "*"
  }]
}
EOF
}

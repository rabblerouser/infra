module "mailer_app" {
  source = "./docker-node-app"
  name = "mailer"
  docker_image = "rabblerouser/mailer"
  port = "3001"
  host_ip = "${aws_eip.eip.public_ip}"
  stream_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  archive_bucket_arn = "${aws_s3_bucket.event_archive_bucket.arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  private_key_path = "${var.private_key_path}"
  stream_name = "${aws_kinesis_stream.rabblerouser_stream.name}"
  archive_bucket_name = "${aws_s3_bucket.event_archive_bucket.bucket}"
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

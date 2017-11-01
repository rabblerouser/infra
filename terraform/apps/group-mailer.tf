module "group_mailer_app" {
  source = "./docker-node-app"
  name = "group-mailer"
  docker_image = "rabblerouser/group-mailer"
  port = "3002"
  vpc_id = "${var.vpc_id}"
  host_ip = "${var.host_ip}"
  aws_instance_id = "${var.aws_instance_id}"
  alb_dns_name = "${var.alb_dns_name}"
  alb_zone_id = "${var.alb_zone_id}"
  alb_listener_arn = "${var.alb_listener_arn}"
  alb_listener_rule_priority = "3"
  docker_api_key = "${var.docker_api_key}"
  docker_api_ca = "${var.docker_api_ca}"
  docker_api_cert = "${var.docker_api_cert}"
  stream_arn = "${var.stream_arn}"
  archive_bucket_arn = "${var.archive_bucket_arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  private_key_path = "${var.private_key_path}"
  stream_name = "${var.stream_name}"
  archive_bucket_name = "${var.archive_bucket_name}"
  env = [
    "S3_EMAILS_BUCKET=${var.mail_bucket_name}",
    "GROUP_MAIL_RECEIVER_AUTH_TOKEN=${var.group_mail_receiver_auth_token}"
  ]
}

resource "aws_iam_user_policy" "group_mailer_read_mail_bucket" {
  name = "group_mailer_read_mail_bucket"
  user =  "${module.group_mailer_app.aws_user_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "${var.mail_bucket_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${var.mail_bucket_arn}/*"
    }
  ]
}
EOF
}

# NOTE: If you add more resources here, they need to be added to the $GROUP_MAILER variable in the tf shell script

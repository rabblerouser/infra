module "mailer_app" {
  source = "./docker-node-app"
  name = "mailer"
  docker_image = "rabblerouser/mailer"
  port = "3001"
  vpc_id = "${var.vpc_id}"
  host_ip = "${var.host_ip}"
  aws_instance_id = "${var.aws_instance_id}"
  alb_dns_name = "${var.alb_dns_name}"
  alb_zone_id = "${var.alb_zone_id}"
  alb_listener_arn = "${var.alb_listener_arn}"
  alb_listener_rule_priority = "2"
  docker_api_key = "${var.docker_api_key}"
  docker_api_ca = "${var.docker_api_ca}"
  docker_api_cert = "${var.docker_api_cert}"
  stream_arn = "${var.stream_arn}"
  archive_bucket_arn = "${var.archive_bucket_arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  stream_name = "${var.stream_name}"
  archive_bucket_name = "${var.archive_bucket_name}"
  env = [
    "S3_EMAILS_BUCKET=${var.mail_bucket_name}",
    "SES_REGION=${var.ses_region}"
  ]
}

resource "aws_iam_user_policy" "mailer_read_mail_bucket" {
  name = "mailer_read_mail_bucket"
  user =  "${module.mailer_app.aws_user_name}"
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

resource "aws_iam_user_policy" "mailer_send_ses_email" {
  name = "send_ses_email"
  user = "${module.mailer_app.aws_user_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action": [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource": "*"
  }]
}
EOF
}

# NOTE: If you add more resources here, they need to be added to the $MAILER variable in the tf shell script

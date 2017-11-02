module "mailer_app" {
  source = "./docker-node-app"
  name = "mailer"
  docker_image = "rabblerouser/mailer"
  port = "${var.app_ports["mailer"]}"
  aws_instance_id = "${var.aws_instance_id}"
  alb_listener_arn = "${var.alb_listener_arn}"
  alb_listener_rule_priority = "2"
  docker_credentials = "${var.docker_credentials}"
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

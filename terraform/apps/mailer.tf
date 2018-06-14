module "mailer_app" {
  source = "./docker-node-app"
  name = "mailer"
  docker_image = "rabblerouser/mailer"
  port = "${var.app_ports["mailer"]}"
  aws_instance_ip = "${var.aws_instance_ip}"
  alb_listener_rule_priority = "2"
  docker_credentials = "${var.docker_credentials}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  archive_bucket_name = "${var.archive_bucket_name}"
  env = [
    "S3_EMAILS_BUCKET=${var.mail_bucket_name}",
    "SES_REGION=${var.ses_region}"
  ]
}

data "aws_s3_bucket" "mail_bucket" {
  bucket = "${var.mail_bucket_name}"
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
      "Resource": "${data.aws_s3_bucket.mail_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${data.aws_s3_bucket.mail_bucket.arn}/*"
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

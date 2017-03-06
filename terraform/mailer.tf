resource "aws_route53_record" "mailer_domain" {
  # Attaching a subdomain to an existing zone
  zone_id = "${var.route53_zone_id}"
  name = "mailer.${var.domain}"
  type = "A"
  ttl = "300" # seconds
  records = ["${aws_eip.eip.public_ip}"]
}

module "mailer_event_forwarder" {
  source = "./event-forwarder"
  name = "mailer"
  stream_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  forward_to = "https://${aws_route53_record.mailer_domain.fqdn}/events"
}

resource "aws_iam_user" "mailer" {
  name = "rabblerouser_mailer"
}

resource "aws_iam_access_key" "mailer" {
  user = "${aws_iam_user.mailer.name}"
}

resource "aws_iam_user_policy" "send_ses_email" {
  name = "send_ses_email"
  user = "${aws_iam_user.mailer.name}"
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

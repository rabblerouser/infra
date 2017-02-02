module "mailer_event_forwarder" {
  source = "./event-forwarder"
  name = "mailer"
  stream_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  forward_to = "https://${var.domain}/mail"
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

module "core_event_forwarder" {
  source = "./event-forwarder"
  name = "core"
  stream_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  forward_to = "https://${var.domain}/events"
}

resource "aws_iam_user" "core" {
  name = "rabblerouser_core"
}

resource "aws_iam_access_key" "core" {
  user = "${aws_iam_user.core.name}"
}

resource "aws_iam_user_policy" "put_record_to_rabblerouser_stream" {
  name = "put_record_to_rabblerouser_stream"
  user = "${aws_iam_user.core.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action": "kinesis:PutRecord",
      "Resource": "${aws_kinesis_stream.rabblerouser_stream.arn}"
  }]
}
EOF
}

resource "aws_iam_user_policy_attachment" "core_bucket_policy" {
  user = "${aws_iam_user.core.name}"
  policy_arn = "${aws_iam_policy.archive_bucket_access.arn}"
}

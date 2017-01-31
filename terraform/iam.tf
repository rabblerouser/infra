resource "aws_iam_user" "rabblerouser_core" {
  name = "rabblerouser_core"
}

resource "aws_iam_access_key" "rabblerouser_core_keys" {
  user = "${aws_iam_user.rabblerouser_core.name}"
}

resource "aws_iam_user_policy" "put_record_to_rabblerouser_stream" {
  name = "put_record_to_rabblerouser_stream"
  user = "${aws_iam_user.rabblerouser_core.name}"
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

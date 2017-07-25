resource "aws_iam_user" "seeder_user" {
  name = "rabblerouser_seeder"
}

resource "aws_iam_access_key" "seeder_aws_key" {
  user = "${aws_iam_user.seeder_user.name}"
}

resource "aws_iam_user_policy" "seeder_put_to_stream" {
  name = "seeder_put_to_stream"
  user = "${aws_iam_user.seeder_user.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action": "kinesis:PutRecord",
      "Resource": "${var.stream_arn}"
  }]
}
EOF
}

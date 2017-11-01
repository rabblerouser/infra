resource "aws_iam_user" "app_user" {
  name = "rabblerouser_${var.name}"
}

resource "aws_iam_access_key" "app_aws_key" {
  user = "${aws_iam_user.app_user.name}"
}

resource "aws_iam_user_policy" "app_put_to_stream" {
  name = "${var.name}_put_to_stream"
  user = "${aws_iam_user.app_user.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
      "Effect": "Allow",
      "Action": "kinesis:PutRecord",
      "Resource": "${data.aws_kinesis_stream.stream.arn}"
  }]
}
EOF
}

resource "aws_iam_user_policy" "app_read_archive_bucket" {
  name = "${var.name}_read_archive_bucket"
  user = "${aws_iam_user.app_user.name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "${data.aws_s3_bucket.archive_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${data.aws_s3_bucket.archive_bucket.arn}/*"
    }
  ]
}
EOF
}

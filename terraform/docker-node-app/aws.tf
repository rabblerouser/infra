resource "aws_route53_record" "app_domain" {
  # Attaching a subdomain to an existing zone
  zone_id = "${var.route53_parent_zone_id}"
  name = "${var.name}.${var.parent_domain_name}"
  type = "A"
  ttl = "300" # seconds
  records = ["${var.host_ip}"]
}

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
      "Resource": "${var.stream_arn}"
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
      "Resource": "${var.archive_bucket_arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${var.archive_bucket_arn}/*"
    }
  ]
}
EOF
}

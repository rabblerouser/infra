resource "aws_lambda_event_source_mapping" "stream_to_event_archiver" {
  event_source_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  function_name = "${aws_lambda_function.event_archiver.arn}"
  starting_position = "LATEST"
}

data "aws_s3_bucket_object" "event_archiver_zip" {
  bucket = "rabblerouser-artefacts"
  key = "lambdas/event_archiver.zip"
  # Defaults to latest version
}

resource "aws_lambda_function" "event_archiver" {
  s3_bucket = "${data.aws_s3_bucket_object.event_archiver_zip.bucket}"
  s3_key = "${data.aws_s3_bucket_object.event_archiver_zip.key}"
  s3_object_version = "${data.aws_s3_bucket_object.event_archiver_zip.version_id}"
  function_name = "event_archiver"
  handler = "index.handler"
  role = "${aws_iam_role.event_archiver_role.arn}"
  runtime = "nodejs4.3"
  environment = {
    variables = {
      ARCHIVE_BUCKET = "${aws_s3_bucket.event_archive_bucket.id}"
    }
  }
}

resource "aws_s3_bucket" "event_archive_bucket" {
  bucket = "${var.domain}-event-archive"
  acl = "private"
  region = "${var.region}"
}

resource "aws_iam_role" "event_archiver_role" {
  name = "event_archiver_role"
  # This just dictates that only lambdas may assume this role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "event_archiver_base_policy" {
  role = "${aws_iam_role.event_archiver_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

resource "aws_iam_role_policy_attachment" "event_archiver_bucket_policy" {
  role = "${aws_iam_role.event_archiver_role.name}"
  policy_arn = "${aws_iam_policy.archive_bucket_readwrite.arn}"
}

resource "aws_iam_policy" "archive_bucket_readonly" {
  name = "archive_bucket_readonly"
  path = "/"
  description = "Allows read-only access to the event archive bucket"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "${aws_s3_bucket.event_archive_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
      ],
      "Resource": "${aws_s3_bucket.event_archive_bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "archive_bucket_readwrite" {
    name = "archive_bucket_readwrite"
    path = "/"
    description = "Allows read/write access to the event archive bucket"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": "${aws_s3_bucket.event_archive_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": "${aws_s3_bucket.event_archive_bucket.arn}/*"
    }
  ]
}
EOF
}

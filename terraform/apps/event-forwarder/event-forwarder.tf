# This is a module because there will be many of these forwarders - one for each service that consumes the stream.

resource "aws_lambda_event_source_mapping" "stream_to_lambda" {
  event_source_arn = "${var.stream_arn}"
  function_name = "${aws_lambda_function.event_forwarder.arn}"
  starting_position = "LATEST"

  # This is to prevent batches that half-succeed, which could cause events to be missed, or double-handled
  # This is an anti-pattern - ideally we could have some events succeed, and retry just the failed ones
  batch_size = 1
}

data "aws_s3_bucket_object" "event_forwarder_zip" {
  bucket = "rabblerouser-artefacts"
  key = "lambdas/event_forwarder.zip"
  # Defaults to latest version
}

resource "random_id" "auth_token" {
  keepers = {
    # Generate a new token when the lambda code updates or the EC2 instance changes
    lambda_zip_version = "${data.aws_s3_bucket_object.event_forwarder_zip.version_id}"
  }

  # With this length, it's as random as a type-4 UUID
  byte_length = 32
}

resource "aws_lambda_function" "event_forwarder" {
  s3_bucket = "${data.aws_s3_bucket_object.event_forwarder_zip.bucket}"
  s3_key = "${data.aws_s3_bucket_object.event_forwarder_zip.key}"
  s3_object_version = "${random_id.auth_token.keepers.lambda_zip_version}"
  function_name = "${var.name}_event_forwarder"
  handler = "index.handler"
  role = "${aws_iam_role.event_forwarder_role.arn}"
  runtime = "nodejs4.3"
  environment = {
    variables = {
      LISTENER_ENDPOINT = "${var.forward_to}"
      LISTENER_AUTH_TOKEN = "${random_id.auth_token.hex}"
    }
  }
}

resource "aws_iam_role" "event_forwarder_role" {
  name = "${var.name}_event_forwarder_role"
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

resource "aws_iam_role_policy_attachment" "event_forwarder_policy" {
  role = "${aws_iam_role.event_forwarder_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}

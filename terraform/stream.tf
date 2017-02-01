resource "aws_kinesis_stream" "rabblerouser_stream" {
  name = "rabblerouser_stream"
  shard_count = 1
}

resource "aws_lambda_event_source_mapping" "stream_to_lambda" {
  event_source_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  function_name = "${aws_lambda_function.event_forwarder.arn}"
  starting_position = "LATEST"
}

data "aws_s3_bucket_object" "event_forwarder_bucket" {
  bucket = "rabblerouser-artefacts"
  key = "lambdas/rabblerouser_event_forwarder.zip"
  # Defaults to latest version
}

resource "aws_lambda_function" "event_forwarder" {
  s3_bucket = "${data.aws_s3_bucket_object.event_forwarder_bucket.bucket}"
  s3_key = "${data.aws_s3_bucket_object.event_forwarder_bucket.key}"
  s3_object_version = "${data.aws_s3_bucket_object.event_forwarder_bucket.version_id}"
  function_name = "rabblerouser_event_forwarder"
  handler = "index.handler"
  role = "${aws_iam_role.event_forwarder_role.arn}"
  runtime = "nodejs4.3"
  environment = {
    variables = {
      RR_CORE_EVENT_ENDPOINT = "https://${var.domain}/events"
    }
  }
}

resource "aws_iam_role" "event_forwarder_role" {
  name = "event_forwarder_role"
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

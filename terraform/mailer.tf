resource "aws_lambda_event_source_mapping" "stream_to_mailer_lambda" {
  event_source_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  function_name = "${aws_lambda_function.mailer_event_forwarder.arn}"
  starting_position = "LATEST"
}

resource "random_id" "rabblerouser_mailer_event_forwarder_auth_token" {
  keepers = {
    # Generate a new token when the lambda code updates or the EC2 instance changes
    lambda_zip_version = "${data.aws_s3_bucket_object.event_forwarder_zip.version_id}"
  }

  # With this length, it's as random as a type-4 UUID
  byte_length = 32
}

resource "aws_lambda_function" "mailer_event_forwarder" {
  s3_bucket = "${data.aws_s3_bucket_object.event_forwarder_zip.bucket}"
  s3_key = "${data.aws_s3_bucket_object.event_forwarder_zip.key}"
  s3_object_version = "${random_id.rabblerouser_mailer_event_forwarder_auth_token.keepers.lambda_zip_version}"
  function_name = "rabblerouser_mailer_event_forwarder"
  handler = "index.handler"
  role = "${aws_iam_role.event_forwarder_role.arn}"
  runtime = "nodejs4.3"
  environment = {
    variables = {
      EVENT_ENDPOINT = "https://${var.domain}/mail"
      EVENT_AUTH_TOKEN = "${random_id.rabblerouser_mailer_event_forwarder_auth_token.hex}"
    }
  }
}

resource "aws_iam_user" "rabblerouser_mailer" {
  name = "rabblerouser_mailer"
}

resource "aws_iam_access_key" "rabblerouser_mailer_keys" {
  user = "${aws_iam_user.rabblerouser_mailer.name}"
}

resource "aws_iam_user_policy" "send_ses_email" {
  name = "put_record_to_rabblerouser_stream"
  user = "${aws_iam_user.rabblerouser_mailer.name}"
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

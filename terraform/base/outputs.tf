output "host_ip" {
  value = "${aws_eip.eip.public_ip}"
}

output "stream_arn" {
  value = "${aws_kinesis_stream.rabblerouser_stream.arn}"
}

output "archive_bucket_arn" {
  value = "${aws_s3_bucket.event_archive_bucket.arn}"
}

output "stream_name" {
  value = "${aws_kinesis_stream.rabblerouser_stream.name}"
}

output "archive_bucket_name" {
  value = "${aws_s3_bucket.event_archive_bucket.bucket}"
}

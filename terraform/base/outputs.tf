output "host_ip" {
  value = "${aws_instance.web.public_ip}"
}

output "aws_instance_id" {
  value = "${aws_instance.web.id}"
}

output "alb_listener_arn" {
  value = "${aws_lb_listener.alb_listener.arn}"
}

output "stream_name" {
  value = "${aws_kinesis_stream.rabblerouser_stream.name}"
}

output "archive_bucket_name" {
  value = "${aws_s3_bucket.event_archive_bucket.bucket}"
}

output "mail_bucket_arn" {
  value = "${module.group_mail_receiver.mail_bucket_arn}"
}

output "mail_bucket_name" {
  value = "${module.group_mail_receiver.mail_bucket_name}"
}

output "docker_credentials" {
  value = {
    key = "${tls_private_key.docker_key.private_key_pem}"
    ca = "${tls_self_signed_cert.docker_ca.cert_pem}"
    cert = "${tls_locally_signed_cert.docker_cert.cert_pem}"
  }
}

output "group_mail_receiver_auth_token" {
  value = "${module.group_mail_receiver.auth_token}"
}
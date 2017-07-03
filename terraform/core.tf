module "core_app" {
  source = "./docker-node-app"
  name = "core"
  docker_image = "rabblerouser/core"
  port = "3000"
  host_ip = "${aws_eip.eip.public_ip}"
  stream_arn = "${aws_kinesis_stream.rabblerouser_stream.arn}"
  archive_bucket_arn = "${aws_s3_bucket.event_archive_bucket.arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  private_key_path = "${var.private_key_path}"
  stream_name = "${aws_kinesis_stream.rabblerouser_stream.name}"
  archive_bucket_name = "${aws_s3_bucket.event_archive_bucket.bucket}"
  env = ["SESSION_SECRET=${random_id.session_secret.hex}"]
}

resource "random_id" "session_secret" {
  keepers = {
    # Generate a new session secret when building a new EC2 instance
    ec2_instance_id = "${aws_instance.web.id}"
  }
  byte_length = 32
}

# setup_command: "{{ (lookup('env', 'SEED_DATABASE') == 'true') | ternary('npm run --prefix backend seed','') }}"
# SEED_DATABASE='${var.seed_database}'\

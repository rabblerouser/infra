module "core_app" {
  source = "./docker-node-app"
  name = "core"
  docker_image = "rabblerouser/core"
  port = "3000"
  host_ip = "${var.host_ip}"
  stream_arn = "${var.stream_arn}"
  archive_bucket_arn = "${var.archive_bucket_arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  private_key_path = "${var.private_key_path}"
  stream_name = "${var.stream_name}"
  archive_bucket_name = "${var.archive_bucket_name}"
  env = ["SESSION_SECRET=${random_id.session_secret.hex}"]
}

resource "random_id" "session_secret" {
  keepers = {
    # Generate a new session secret when IP address changes
    ec2_instance_id = "${var.host_ip}"
  }
  byte_length = 32
}

module "group_mailer_app" {
  source = "./docker-node-app"
  name = "group-mailer"
  docker_image = "rabblerouser/group-mailer"
  port = "3002"
  host_ip = "${var.host_ip}"
  docker_api_key = "${var.docker_api_key}"
  docker_api_ca = "${var.docker_api_ca}"
  docker_api_cert = "${var.docker_api_cert}"
  stream_arn = "${var.stream_arn}"
  archive_bucket_arn = "${var.archive_bucket_arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  private_key_path = "${var.private_key_path}"
  stream_name = "${var.stream_name}"
  archive_bucket_name = "${var.archive_bucket_name}"
  env = ["S3_EMAIL_BUCKET=${var.domain}-mail-storage"]
}

# NOTE: If you add more resources here, they need to be added to the $GROUP_MAILER variable in the tf shell script

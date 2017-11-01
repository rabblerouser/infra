module "core_app" {
  source = "./docker-node-app"
  name = "core"
  docker_image = "rabblerouser/core"
  port = "3000"
  vpc_id = "${var.vpc_id}"
  host_ip = "${var.host_ip}"
  aws_instance_id = "${var.aws_instance_id}"
  alb_dns_name = "${var.alb_dns_name}"
  alb_zone_id = "${var.alb_zone_id}"
  alb_listener_arn = "${var.alb_listener_arn}"
  alb_listener_rule_priority = "1"
  docker_api_key = "${var.docker_api_key}"
  docker_api_ca = "${var.docker_api_ca}"
  docker_api_cert = "${var.docker_api_cert}"
  stream_arn = "${var.stream_arn}"
  archive_bucket_arn = "${var.archive_bucket_arn}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
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

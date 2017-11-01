module "core_app" {
  source = "./docker-node-app"
  name = "core"
  docker_image = "rabblerouser/core"
  port = "3000"
  aws_instance_id = "${var.aws_instance_id}"
  alb_listener_arn = "${var.alb_listener_arn}"
  alb_listener_rule_priority = "1"
  docker_credentials = "${var.docker_credentials}"
  parent_domain_name = "${var.domain}"
  route53_parent_zone_id = "${var.route53_zone_id}"
  stream_name = "${var.stream_name}"
  archive_bucket_name = "${var.archive_bucket_name}"
  env = ["SESSION_SECRET=${random_id.session_secret.hex}"]
}

resource "random_id" "session_secret" {
  keepers = {
    # Generate a new session secret when instance ID changes
    ec2_instance_id = "${var.aws_instance_id}"
  }
  byte_length = 32
}

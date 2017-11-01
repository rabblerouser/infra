terraform {
  backend "s3" {
    # Empty config here because each organisation will configure its own remote state
  }
}

provider "aws" {
  version = "~> 1.1.0"
  region = "${var.region}"
}

provider "null" {
  version = "~> 1.0.0"
}

provider "random" {
  version = "~> 1.0.0"
}

provider "tls" {
  version = "~> 1.0.0"
}

# These data sources just look up certain AWS objects so we can reference them elsewhere
data "aws_route53_zone" "parent_hosted_zone" {
  # Determine parent domain: split FQDN on '.', then drop the first element, then join on '.' again
  # This is pretty hairy, but it works, and it means *everything* can be configured from just `var.domain` alone!
  name = "${join(".", slice(split(".", var.domain), 1, length(split(".", var.domain))))}"
}

locals {
  route53_zone_id = "${data.aws_route53_zone.parent_hosted_zone.zone_id}"
}

module base {
  source = "./base"
  route53_zone_id = "${local.route53_zone_id}"
  ses_region = "${var.ses_region}"
  domain = "${var.domain}"
  private_key_path = "${var.private_key_path}"
}

module apps {
  source = "./apps"
  domain = "${var.domain}"
  route53_zone_id = "${local.route53_zone_id}"

  aws_instance_id = "${module.base.aws_instance_id}"
  alb_listener_arn = "${module.base.alb_listener_arn}"
  docker_credentials = "${module.base.docker_credentials}"
  stream_name = "${module.base.stream_name}"
  archive_bucket_name = "${module.base.archive_bucket_name}"
  ses_region = "${var.ses_region}"
  mail_bucket_arn = "${module.base.mail_bucket_arn}"
  mail_bucket_name = "${module.base.mail_bucket_name}"
  group_mail_receiver_auth_token = "${module.base.group_mail_receiver_auth_token}"
}

module seeder {
  source = "./seeder"
  host_ip = "${module.base.host_ip}"
  docker_credentials = "${module.base.docker_credentials}"
  stream_name = "${module.base.stream_name}"
}

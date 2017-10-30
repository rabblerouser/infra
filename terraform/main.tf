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

data "aws_route53_zone" "parent_hosted_zone" {
  # Determine parent domain: split FQDN on '.', then drop the first element, then join on '.' again
  # This is pretty hairy, but it works, and it means *everything* can be configured from just `var.domain` alone!
  name = "${join(".", slice(split(".", var.domain), 1, length(split(".", var.domain))))}"
}

locals {
  route53_zone_id = "${data.aws_route53_zone.parent_hosted_zone.zone_id}"
  tls_cert_email = "admin@${var.domain}"
}

module base {
  source = "./base"
  route53_zone_id = "${local.route53_zone_id}"
  tls_cert_email = "${local.tls_cert_email}"
  ses_region = "${var.ses_region}"
  domain = "${var.domain}"
  private_key_path = "${var.private_key_path}"
}

module apps {
  source = "./apps"
  domain = "${var.domain}"
  route53_zone_id = "${local.route53_zone_id}"
  tls_cert_email = "${local.tls_cert_email}"
  private_key_path = "${var.private_key_path}"

  host_ip = "${module.base.host_ip}"
  alb_dns_name = "${module.base.alb_dns_name}"
  alb_zone_id = "${module.base.alb_zone_id}"
  docker_api_key = "${module.base.docker_api_key}"
  docker_api_ca = "${module.base.docker_api_ca}"
  docker_api_cert = "${module.base.docker_api_cert}"
  stream_arn = "${module.base.stream_arn}"
  stream_name = "${module.base.stream_name}"
  archive_bucket_arn = "${module.base.archive_bucket_arn}"
  archive_bucket_name = "${module.base.archive_bucket_name}"
  ses_region = "${var.ses_region}"
  mail_bucket_arn = "${module.base.mail_bucket_arn}"
  mail_bucket_name = "${module.base.mail_bucket_name}"
  group_mail_receiver_auth_token = "${module.base.group_mail_receiver_auth_token}"
}

module seeder {
  source = "./seeder"
  host_ip = "${module.base.host_ip}"
  docker_api_key = "${module.base.docker_api_key}"
  docker_api_ca = "${module.base.docker_api_ca}"
  docker_api_cert = "${module.base.docker_api_cert}"
  stream_arn = "${module.base.stream_arn}"
  stream_name = "${module.base.stream_name}"
}

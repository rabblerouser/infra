terraform {
  backend "s3" {
    # Empty config here because each organisation will configure its own remote state
  }
}

provider "aws" {
  region = "${var.region}"
}

module base {
  source = "./base"
  route53_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  domain = "${var.domain}"
  private_key_path = "${var.private_key_path}"
}

module apps {
  source = "./apps"
  domain = "${var.domain}"
  route53_zone_id = "${var.route53_zone_id}"
  tls_cert_email = "${var.tls_cert_email}"
  private_key_path = "${var.private_key_path}"

  host_ip = "${module.base.host_ip}"
  docker_api_key = "${module.base.docker_api_key}"
  docker_api_ca = "${module.base.docker_api_ca}"
  docker_api_cert = "${module.base.docker_api_cert}"
  stream_arn = "${module.base.stream_arn}"
  archive_bucket_arn = "${module.base.archive_bucket_arn}"
  stream_name = "${module.base.stream_name}"
  archive_bucket_name = "${module.base.archive_bucket_name}"
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

output host_ip {
  value = "${module.base.host_ip}"
}

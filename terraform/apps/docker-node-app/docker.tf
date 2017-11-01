provider "docker" {
  version = "~> 0.1.0"
  host = "tcp://${data.aws_instance.instance.public_ip}:2376"
  key_material = "${var.docker_credentials["key"]}"
  ca_material = "${var.docker_credentials["ca"]}"
  cert_material = "${var.docker_credentials["cert"]}"
}

data "docker_registry_image" "app_image" {
  name = "${var.docker_image}"
}

resource "docker_image" "app_image" {
  name = "${data.docker_registry_image.app_image.name}"
  pull_triggers = ["${data.docker_registry_image.app_image.sha256_digest}"]
}

resource "docker_container" "app_container" {
  name = "${var.name}"
  image = "${docker_image.app_image.latest}"
  ports = {
    internal = "${var.port}"
    external = "${var.port}"
  }
  env = ["${concat(
    list(
      "PORT=${var.port}",
      "AWS_ACCESS_KEY_ID=${aws_iam_access_key.app_aws_key.id}",
      "AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.app_aws_key.secret}",
      "LISTENER_AUTH_TOKEN=${module.app_event_forwarder.auth_token}",
      "STREAM_NAME=${var.stream_name}",
      "ARCHIVE_BUCKET=${var.archive_bucket_name}",
      "DOMAIN=${var.parent_domain_name}"
    ),
    "${var.env}"
  )}"]
}

provider "docker" {
  host = "tcp://${var.host_ip}:2375"
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
    ip = "127.0.0.1"
  }
  env = ["${concat(
    list(
      "AWS_ACCESS_KEY_ID=${aws_iam_access_key.app_aws_key.id}",
      "AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.app_aws_key.secret}",
      "LISTENER_AUTH_TOKEN=${module.app_event_forwarder.auth_token}",
      "STREAM_NAME=${var.stream_name}",
      "ARCHIVE_BUCKET=${var.archive_bucket_name}"
    ),
    "${var.env}"
  )}"]
}
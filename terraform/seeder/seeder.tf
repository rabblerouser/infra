provider "docker" {
  version = "~> 0.1.0"
  host = "tcp://${var.host_ip}:2376"
  key_material = "${var.docker_credentials["key"]}"
  ca_material = "${var.docker_credentials["ca"]}"
  cert_material = "${var.docker_credentials["cert"]}"
}

data "aws_kinesis_stream" "stream" {
  name = "${var.stream_name}"
}

data "docker_registry_image" "seeder_image" {
  name = "rabblerouser/core"
}

resource "docker_image" "seeder_image" {
  name = "${data.docker_registry_image.seeder_image.name}"
  pull_triggers = ["${data.docker_registry_image.seeder_image.sha256_digest}"]
}

resource "docker_container" "seeder_container" {
  name = "seeder"
  image = "${docker_image.seeder_image.latest}"
  command = ["npm", "run", "--prefix", "backend", "seed"]
  restart = "no"
  env = [
    "AWS_ACCESS_KEY_ID=${aws_iam_access_key.seeder_aws_key.id}",
    "AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.seeder_aws_key.secret}",
    "STREAM_NAME=${var.stream_name}",
  ]
  depends_on = ["aws_iam_user_policy.seeder_put_to_stream"]
}

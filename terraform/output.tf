output host_ip {
  value = "${module.base.host_ip}"
}

output "docker_api_key" {
  value = "${module.base.docker_api_key}"
}

output "docker_api_ca" {
  value = "${module.base.docker_api_ca}"
}

output "docker_api_cert" {
  value = "${module.base.docker_api_cert}"
}

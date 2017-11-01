output host_ip {
  value = "${module.base.host_ip}"
}

output "docker_api_key" {
  value = "${module.base.docker_credentials["key"]}"
  sensitive = true
}

output "docker_api_ca" {
  value = "${module.base.docker_credentials["ca"]}"
  sensitive = true
}

output "docker_api_cert" {
  value = "${module.base.docker_credentials["cert"]}"
  sensitive = true
}

output host_ip {
  value = "${module.base.host_ip}"
}

output "docker_api_key" {
  value = "${module.base.docker_credentials["key"]}"
}

output "docker_api_ca" {
  value = "${module.base.docker_credentials["ca"]}"
}

output "docker_api_cert" {
  value = "${module.base.docker_credentials["cert"]}"
}

###########################################################
# NOTE! If you add any outputs here that are sensitive,   #
# you must take care to make sure that they don't end     #
# written to stdout during a `terraform apply`. You can   #
# use `sed` for this - see the `tf` script for an example #
###########################################################

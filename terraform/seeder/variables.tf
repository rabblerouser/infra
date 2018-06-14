variable "domain" {
  description = "The domain where the Rabble Rouser instance lives."
  type = "string"
}

variable "host_ip" {
  description = "The IP address of the host where the seeder should run"
  type = "string"
}

variable "docker_credentials" {
  description = "The key, ca, and cert PEMs used to authenticate with the remote Docker daemon"
  type = "map"
}

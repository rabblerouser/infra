variable "host_ip" {
  description = "The IP address of the host where the seeder should run"
  type = "string"
}

variable "docker_credentials" {
  description = "The key, ca, and cert PEMs used to authenticate with the remote Docker daemon"
  type = "map"
}

variable "stream_name" {
  description = "The name of the kinesis event stream"
  type = "string"
}

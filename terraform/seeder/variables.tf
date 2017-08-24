variable "host_ip" {
  description = "The IP address of the host where the seeder should run"
  type = "string"
}

variable "docker_api_key" {
  description = "The private key used to authenticate with the docker remote API"
  type = "string"
}

variable "docker_api_ca" {
  description = "The CA cert used to authenticate with the docker remote API"
  type = "string"
}

variable "docker_api_cert" {
  description = "The cert used to authenticate with the docker remote API"
  type = "string"
}

variable "stream_arn" {
  description = "The ARN of the kinesis event stream"
  type = "string"
}

variable "stream_name" {
  description = "The name of the kinesis event stream"
  type = "string"
}

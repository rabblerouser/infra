variable "name" {
  description = "The name of the app being deployed. Must be a valid subdomain"
  type = "string"
}

variable "docker_image" {
  description = "The Docker image to deploy for this app"
  type = "string"
}

variable "port" {
  description = "The port that the app will bind to"
  type = "string"
}

variable "env" {
  description = "Environment variables to inject into the app container. List of strings like: 'VAR=value'"
  type = "list"
  default = []
}

variable "host_ip" {
  description = "The IP address of the host where the app should be deployed"
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

variable "archive_bucket_arn" {
  description = "The ARN of the event archive bucket"
  type = "string"
}

variable "archive_bucket_name" {
  description = "The name of the event archive bucket"
  type = "string"
}

variable "parent_domain_name" {
  description = "The parent domain name under which this app will be reachable"
  type = "string"
}

variable "route53_parent_zone_id" {
  description = "The ID of the Route53 Zone that contains the parent domain"
  type = "string"
}

variable "tls_cert_email" {
  description = "The email under which to register the TLS cert. E.g. webmaster@rabblerouser.team"
  type = "string"
}

variable "private_key_path" {
  description = "Private key to be used for ansible provisioning"
  type = "string"
}

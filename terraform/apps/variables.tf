variable "domain" {
  description = "The domain where you want your Rabble Rouser instance to live. Must be valid for the host zone where it will be created. E.g. if the hosted zone is example.com, then this variable might be set to 'rabblerouser.example.com'. Do not include a trailing period on the end of the domain name."
  type = "string"
}

variable "route53_zone_id" {
  description = "An existing Route53 hosted zone, where the new DNS entry should be placed"
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

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

variable "aws_instance_ip" {
  description = "The public IP address of the EC2 instance where this app should be deployed"
  type = "string"
}

variable "alb_listener_rule_priority" {
  description = "The priority of this app's ALB listener rule"
  type = "string"
}

variable "docker_credentials" {
  description = "The key, ca, and cert PEMs used to authenticate with the remote Docker daemon"
  type = "map"
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

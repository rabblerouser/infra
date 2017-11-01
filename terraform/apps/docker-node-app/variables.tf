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

variable "vpc_id" {
  description = "The ID of the VPC where the app should be deployed"
  type = "string"
}

variable "host_ip" {
  description = "The IP address of the host where the app should be deployed"
  type = "string"
}

variable "aws_instance_id" {
  description = "The ID of the EC2 instance where the app should be deployed"
  type = "string"
}

variable "alb_dns_name" {
  description = "The DNS name assigned to the application load balancer"
  type = "string"
}

variable "alb_zone_id" {
  description = "The canonical hosted zone ID of the ALB"
  type = "string"
}

variable "alb_listener_arn" {
  description = "The ARN of the ALB listener"
  type = "string"
}

variable "alb_listener_rule_priority" {
  description = "The priority of this app's ALB listener rule"
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

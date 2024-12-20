# VPC cidr block
variable "vpc_cidr_block" {
  description = "VPC cidr block"
  type        = string
}

# HTTP port allow
variable "port_http" {
  description = "Allow http port in security group"
  type        = string
}

# HTTPS port allow
variable "port_https" {
  description = "Allow Https port in security group"
  type        = string
}

# Protocol allow
variable "protocol" {
  description = "Allow ip protocol"
  type        = string
}

# default tag
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
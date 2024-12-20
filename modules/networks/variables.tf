variable "region" {
  description = "The region of the deployment"
  type        = string
}


variable "vpc_cidr_block" {
  description = "The cidr block"
  type        = string
}

variable "port_http" {
  description = "The allowed http port in security group"
  type        = string
}

variable "port_https" {
  description = "The allowed Https port in security group"
  type        = string
}

variable "protocol" {
  description = "The allowed ip protocol"
  type        = string
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
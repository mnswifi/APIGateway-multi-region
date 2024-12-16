variable "provider" {
  description = "The deployment provider"
  type        = string
}

variable "region" {
  description = "The region of the deployment"
  type        = string
}


variable "vpc_cidr_block" {
  description = "The cidr block"
  type        = string
}

variable "port" {
  description = "The allowed port in security group"
  type = string  
}

variable "protocol" {
  description = "The allowed ip protocol"
  type = string  
}
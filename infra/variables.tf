variable "region1" {
    description = "The region for the deployment"
    type = string  
}


variable "region2" {
    description = "The region for the deployment"
    type = string  
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



variable "http_method" {
  description = "The Apigateway method"
  type = string
}

variable "primary_region" {
    description = "The region for the deployment"
    type = string  
    default = "us-east-1"
}


variable "secondary_region" {
    description = "The region for the deployment"
    type = string 
    default = "us-west-2" 
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

variable "environment" {
  description = "The deployment environment"
  type = string  
}


variable "dynamodb_table_name" {
  description = "dynamodb table name"
  type = string  
}
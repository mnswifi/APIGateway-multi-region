# Cloudwatch log group arn
variable "log_groups_arn" {
  description = "Cloudwatch log group arn"
  type        = string
}

# Apigateway method 
variable "http_method" {
  description = "Apigateway http method"
  type        = string
}

# API Gateway role arn
variable "api_gateway_role_arn" {
  description = "API Gateway role arn"
  type        = string
}

# input VPC id
variable "vpc_id" {
  description = "VPC id"
  type        = string
}


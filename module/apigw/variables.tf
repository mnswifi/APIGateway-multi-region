variable "provider" {
  description = "The deployment provider"
  type        = string
}

variable "region" {
  description = "The default region of deployment"
  type        = string
}

variable "log_groups_arn" {
  description = "Cloudwatcg log group arn"
  type        = string
}


variable "http_method" {
  description = "The Apigateway method"
  type = string
}


# variable "api_gateway_role_arn" {
#     description = "The apigateway role arn"
#     type = string  
# }

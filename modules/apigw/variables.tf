
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

variable "api_gateway_role_arn" {
  
  description = "The role arn for apigateway"
  type = string
}
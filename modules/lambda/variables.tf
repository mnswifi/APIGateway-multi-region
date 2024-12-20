variable "region" {
  description = "Deployment Region"
  type        = string
}

# Lambda function name
variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "Test_apigw_curl"
}

# lambda curl arn
variable "lambda_curl_arn" {
  description = "Lambda Function ARN"
  type        = string
}

# API GATEWAY invoke curl URL
variable "apigw_invoke_curl" {
  description = "API Gateway invoke url"
  type        = string
}


# Subnet ids
variable "subnet_ids" {
  description = "VPC Subnet ids"
  type        = string
}

# Security Group ids
variable "security_group_ids" {
  description = "VPC Security group ids"
  type        = string
}

# The resource path for API Gateway
variable "apigw_path_part" {
  description = "Api Gateway resource path"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "Test_apigw_curl"
}


variable "lambda_curl_arn" {
  description = "The Lambda Function ARN"
  type        = string
}


variable "apigw_invoke_curl" {
  description = "API Gateway invoke url"
  type        = string
}



variable "subnet_ids" {
  description = "The VPC subnet ids"
  type        = string
}

variable "security_group_ids" {
  description = "The security group ids"
  type        = string
}

variable "apigw_path_part" {
  description = ""
  type        = string
}

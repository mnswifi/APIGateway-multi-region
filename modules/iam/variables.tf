# VPC ids
variable "vpc_ids" {
  description = "VPC ID"
  type        = map(string)
}

# DynamoDB table arn
variable "dynamodb_table_arn" {
  description = "Dynamodb arn"
  type        = string
}

# Dynamodb Table name
variable "dynamodb_table_name" {
  description = "dynamodb table name"
  type        = string
}

# Default tag
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Cloudwatch log group arn
variable "log_group_arns" {
  description = "Cloudwatch Log group ARN"
  type        = map(string)
}

# API Gateway arn
variable "apigw_arns" {
  description = "API Gateway ARN"
  type        = map(string)
}


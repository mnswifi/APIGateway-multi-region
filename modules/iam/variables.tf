variable "vpc_ids" {
  description = "The vpc id"
  type        = map(string)
}


variable "dynamodb_table_arn" {
  description = "Dynamodb arn"
  type        = string
}

variable "dynamodb_table_name" {
  description = "dynamodb table name"
  type        = string
}

# variable "apigw_ids" {
#   description = "REST APIGateway ID"
#   type        = map(string)
# }


variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "log_group_arns" {
  description = "The Log group ARN"
  type        = map(string)
}

variable "apigw_arns" {
  description = "The APIgw ARN"
  type        = map(string)
}


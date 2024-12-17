variable "vpc_id" {
  description = "The vpc id"
  type        = string
}


variable "dynamodb_table_arn" {
  description = "Dynamodb arn"
  type        = string
}

variable "dynamodb_table_name" {
  description = "dynamodb table name"
  type = string  
}

variable "apigw_id" {
  description = "REST APIGateway ID"
  type        = string
}


variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

variable "log_group_arn" {
  description = "The Log group ARN"
  type = string  
}

variable "apigw_arn" {
  description = "The APIgw ARN"
  type = string  
}


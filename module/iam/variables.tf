variable "region" {
  description = "The deployment region"
  type = string 
}

variable "vpc_id" {
  description = "The vpc id"
  type = string
}


variable "dynamodb_table_arn" {
    description = "Dynamodb arn"
  type = string
}

variable "apigw_id" {
    description = "REST APIGateway ID"
    type = string  
}

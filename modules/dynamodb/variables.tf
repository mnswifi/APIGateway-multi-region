variable "table_name" {
  description = "The name of the DynamoDB table."
  type        = string
}

variable "billing_mode" {
  description = "The billing mode for the DynamoDB table (e.g., PAY_PER_REQUEST or PROVISIONED)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "The primary hash key for the table."
  type        = string
}

variable "range_key" {
  description = "The primary range key for the table."
  type        = string
}

variable "hash_key_type" {
  description = "The type of the hash key (e.g., S or N)."
  type        = string
  default     = "S"
}

variable "range_key_type" {
  description = "The type of the range key (e.g., S or N)."
  type        = string
  default     = "S"
}

variable "ttl_attribute_name" {
  description = "The attribute name used for TTL."
  type        = string
  default     = "TimeToExist"
}

variable "ttl_enabled" {
  description = "Whether TTL is enabled for the table."
  type        = bool
  default     = true
}

variable "global_secondary_indexes" {
  description = "List of global secondary indexes."
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = string
    projection_type    = string
    non_key_attributes = list(string)
  }))
  default = []
}

variable "create_replica" {
  description = "Whether to create a replica for the DynamoDB table."
  type        = bool
  default     = true
}


variable "tags" {
   description = "A map of tags to assign to resources."
  type = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
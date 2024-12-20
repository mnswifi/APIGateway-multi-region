# Dynamodb table name
variable "table_name" {
  description = "DynamoDB table name"
  type        = string
}

# Dynamodb billing mode
variable "billing_mode" {
  description = "The billing mode for the DynamoDB table (e.g., PAY_PER_REQUEST or PROVISIONED)."
  type        = string
  default     = "PAY_PER_REQUEST"
}

# Dynamodb Hash Key
variable "hash_key" {
  description = "The primary hash key for the table."
  type        = string
}

# Create Replica option
variable "create_replica" {
  description = "Whether to create a replica for the DynamoDB table."
  type        = bool
  default     = true
}

# Default tags
variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
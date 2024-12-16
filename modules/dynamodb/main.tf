# DynamoDB Table
# resource "aws_dynamodb_table" "primary_table" {
#   name         = var.table_name
#   billing_mode = var.billing_mode
#   hash_key     = var.hash_key
#   range_key    = var.range_key

#   attribute {
#     name = var.hash_key
#     type = var.hash_key_type
#   }

#   attribute {
#     name = var.range_key
#     type = var.range_key_type
#   }

#   ttl {
#     attribute_name = var.ttl_attribute_name
#     enabled        = var.ttl_enabled
#   }

#   global_secondary_index {
#     count = length(var.global_secondary_indexes)

#     name               = var.global_secondary_indexes[count.index].name
#     hash_key           = var.global_secondary_indexes[count.index].hash_key
#     range_key          = var.global_secondary_indexes[count.index].range_key
#     projection_type    = var.global_secondary_indexes[count.index].projection_type
#     non_key_attributes = var.global_secondary_indexes[count.index].non_key_attributes
#   }

#   tags = var.tags
# }

# DynamoDB Replica (Optional)
# resource "aws_dynamodb_table_replica" "replica_table" {
#   count            = var.create_replica ? 1 : 0
#   provider         = aws.secondary
#   global_table_arn = aws_dynamodb_table.tf_primary_db.arn

#   tags = var.tags
# }


provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

provider "aws" {
  region = "us-west-2"
  alias  = "secondary"
}


















##################### DYNAMODB ####################################

# Primary DynamoDB Table
resource "aws_dynamodb_table" "tf_primary_db" {
  name         = "GameScores"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "customerId"
  range_key    = "GameTitle"

  # Define only the required attributes
  attribute {
    name = "customerId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N" # Optional but included for global index projection
  }

  # Time-to-live (TTL) configuration
  ttl {
    attribute_name = "TimeToExist" # Set for auto-expiry of items
    enabled        = true
  }

  # Global Secondary Index (GSI)
  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    projection_type    = "INCLUDE" # Include only necessary attributes
    non_key_attributes = ["userId"] # Reduced to valid attributes
  }

  tags = {
    Name        = "dynamodb-primary"
    Environment = "dev"
  }
}

# Global Table Replica (Cross-region replication)
resource "aws_dynamodb_table_replica" "tf_secondary_db" {
  count = var.create_replica ? 1: 0
  provider         = aws.secondary # Use an aliased provider for another region
  global_table_arn = aws_dynamodb_table.tf_primary_db.arn

  tags = {
    Name        = "dynamodb-secondary"
    Environment = "dev"
  }
}

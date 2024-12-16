#################### DYNAMODB ####################################

# Primary DynamoDB Table
resource "aws_dynamodb_table" "basic_dynamodb_table" {
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
    non_key_attributes = ["customerId"] # Reduced to valid attributes
  }

  tags = {
    Name        = "dynamodb-primary"
    Environment = "dev"
  }
}

# Global Table Replica (Cross-region replication)
resource "aws_dynamodb_table_replica" "example" {
  provider         = aws.replica_provider # Use an aliased provider for another region
  global_table_arn = aws_dynamodb_table.basic_dynamodb_table.arn

  tags = {
    Name        = "dynamodb-secondary"
    Environment = "dev"
  }
}

############################## DYNAMODB ####################################

# Primary DynamoDB Table
resource "aws_dynamodb_table" "tf_primary_db" {
  name             = "GameScores"
  billing_mode     = var.billing_mode
  hash_key         = "userId"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # Define only the required attributes
  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "gameTitle"
    type = "S"
  }

  attribute {
    name = "TopScore"
    type = "N"
  }

  # Time-to-live (TTL) configuration
  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name            = "GameTitleIndex"
    hash_key        = "gameTitle"
    range_key       = "TopScore"
    projection_type = "ALL"
  }

  tags = {
    Name        = "dynamodb-primary"
    Environment = "dev"
  }
}

# Global Table Replica (Cross-region replication)
resource "aws_dynamodb_table_replica" "tf_secondary_db" {
  count            = var.create_replica ? 1 : 0
  provider         = aws.secondary
  global_table_arn = aws_dynamodb_table.tf_primary_db.arn

  tags = {
    Name        = "dynamodb-secondary"
    Environment = "dev"
  }
}


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
  hash_key     = "userId"
  # range_key    = "gameTitle"

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

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  global_secondary_index {
    name            = "GameTitleIndex"
    hash_key        = "gameTitle"
    range_key       = "TopScore"
    projection_type = "ALL"
    # non_key_attributes = ["customerId"] 
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

#################### DYNAMODB ####################################

resource "aws_dynamodb_table" "basic_dynamodb_table" {
  name         = "GameScores"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "customerId"
  range_key    = "GameTitle"

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
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name               = "GameTitleIndex"
    hash_key           = "GameTitle"
    range_key          = "TopScore"
    projection_type    = "INCLUDE"
    non_key_attributes = ["UserId"] # Ensure "UserId" is valid in the schema
  }

  lifecycle {
    ignore_changes = [replica]
  }

  tags = {
    Name        = "dynamodb-primary"
    Environment = "dev"
  }
}

resource "aws_dynamodb_table_replica" "example" {
  provider         = aws.replica_provider # Use an aliased provider
  global_table_arn = aws_dynamodb_table.basic_dynamodb_table.arn

 tags = {
    Name        = "dynamodb-secondary"
    Environment = "dev"
  }
}


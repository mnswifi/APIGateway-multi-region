# Output Dynamodb arn
output "dynamodb_arn" {
  value = aws_dynamodb_table.tf_primary_db.arn
}

# Output replica dynamodb arn
output "replica_dynamodb_arn" {
  value = aws_dynamodb_table_replica.tf_secondary_db[0].arn
}

# Output Dynamodb table name
output "table_name" {
  value = aws_dynamodb_table.tf_primary_db.name
}


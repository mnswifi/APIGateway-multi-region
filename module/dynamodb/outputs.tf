output "dynamodb_arn" {
  value = aws_dynamodb_table.tf_primary_db.arn
}


output "replica_dynamodb_arn" {
  value = aws_dynamodb_table_replica.tf_secondary_db.arn  
}
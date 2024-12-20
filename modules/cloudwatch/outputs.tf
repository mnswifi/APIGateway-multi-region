# Output Cloudwatch log group arn
output "log_groups_arn" {
  value = aws_cloudwatch_log_group.api_gateway_logs.arn
}

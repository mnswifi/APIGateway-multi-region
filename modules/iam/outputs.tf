# Output API Gateway role arn
output "api_gateway_role_arn" {
  value = aws_iam_role.api_gateway_role.arn
}

# Output Lambda execution role arn
output "lambda_curl_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}
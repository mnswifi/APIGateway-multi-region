
output "api_gateway_role_arn" {
  value = aws_iam_role.api_gateway_role.arn
}


output "lambda_role_id" {
  value = aws_iam_role.lambda_role.id
}
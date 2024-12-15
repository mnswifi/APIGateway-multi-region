
# Cloudwatch Logs

resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/multi-region-api"
  retention_in_days = 14
}


resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action   = ["dynamodb:Query"],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

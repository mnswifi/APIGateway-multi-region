
# Cloudwatch Logs

resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.log_name}"
  retention_in_days = 14
}





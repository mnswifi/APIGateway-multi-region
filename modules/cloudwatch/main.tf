
# Cloudwatch Logs

resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/multi-region-api"
  retention_in_days = 14
}





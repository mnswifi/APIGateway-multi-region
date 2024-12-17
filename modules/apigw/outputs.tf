# Output API Gateway Endpoint
output "apigw_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}


output "api_endpoint" {
  value = aws_api_gateway_stage.tf_stage.invoke_url
}

output "apigw_arn" {
  value = aws_api_gateway_rest_api.rest_api.arn  
}


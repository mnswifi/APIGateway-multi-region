# Output API Gateway Endpoint id
output "apigw_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

# Output api gateway endpoint url
output "api_endpoint" {
  value = aws_api_gateway_stage.tf_stage.invoke_url
}

# Output API Gateway arn
output "apigw_arn" {
  value = aws_api_gateway_rest_api.rest_api.arn
}

# Output API Gateway resource path
output "path_part" {
  value = aws_api_gateway_resource.tf_resource.path_part
}



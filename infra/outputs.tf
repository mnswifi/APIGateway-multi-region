# Primary region APIGateway invoke url 
output "api_endpoint_use" {
  value = module.apigw_use.api_endpoint
}

# Secondary region APIGateway invoke url
output "api_endpoint_usw" {
  value = module.apigw_usw.api_endpoint
}
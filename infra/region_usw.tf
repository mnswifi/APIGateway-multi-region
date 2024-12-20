########################### API Gateway  ######################################

module "apigw_usw" {
  source = "../modules/apigw"
  providers = {
    aws = aws.secondary
  }
  vpc_id               = module.networks_usw.vpc_id
  log_groups_arn       = module.cloudwatch_usw.log_groups_arn
  http_method          = var.regions[var.secondary_region].http_method
  api_gateway_role_arn = module.iam_role.api_gateway_role_arn
}



########################### VPC AND SECURITY GROUPS ##############################

module "networks_usw" {
  source = "../modules/networks"
  providers = {
    aws = aws.secondary
  }
  vpc_cidr_block = var.regions[var.secondary_region].vpc_cidr_block
  protocol       = var.regions[var.secondary_region].protocol
  port_http      = var.regions[var.secondary_region].port_http
  port_https     = var.regions[var.secondary_region].port_https
}

################################ CLOUDWATCH LOG GROUP ################################

module "cloudwatch_usw" {
  source = "../modules/cloudwatch"
  providers = {
    aws = aws.secondary
  }
  log_name = var.regions[var.secondary_region].log_name
}


############################# LAMBDA CURL TEST ##################################

module "Lambda_test_usw" {
  depends_on = [module.apigw_usw]
  providers = {
    aws = aws.secondary
  }
  source             = "../modules/lambda"
  lambda_curl_arn    = module.iam_role.lambda_curl_arn
  apigw_invoke_curl  = module.apigw_usw.api_endpoint
  subnet_ids         = module.networks_usw.subnet_id
  security_group_ids = module.networks_usw.security_group_id
  apigw_path_part    = module.apigw_usw.path_part
  region             = var.regions[var.secondary_region].region
}







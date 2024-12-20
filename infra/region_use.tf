########################### API Gateway  ######################################

module "apigw_use" {
  source = "../modules/apigw"
  providers = {
    aws = aws.primary
  }
  vpc_id               = module.networks_use.vpc_id
  log_groups_arn       = module.cloudwatch_use.log_groups_arn
  http_method          = var.regions[var.primary_region].http_method
  api_gateway_role_arn = module.iam_role.api_gateway_role_arn
}



########################### VPC AND SECURITY GROUPS ##############################

module "networks_use" {
  source = "../modules/networks"
  providers = {
    aws = aws.primary
  }
  vpc_cidr_block = var.regions[var.primary_region].vpc_cidr_block
  protocol       = var.regions[var.primary_region].protocol
  port_http      = var.regions[var.primary_region].port_http
  port_https     = var.regions[var.primary_region].port_https
}


################################# DYNAMO DB #################################################

module "dynamodb_use" {
  source         = "../modules/dynamodb"
  providers      = { aws = aws.primary }
  table_name     = var.regions[var.primary_region].table_name
  billing_mode   = var.regions[var.primary_region].billing_mode
  hash_key       = var.regions[var.primary_region].userId
  create_replica = true
}


################################ CLOUDWATCH LOG GROUP ######################################

module "cloudwatch_use" {
  source = "../modules/cloudwatch"
  providers = {
    aws = aws.primary
  }
  log_name = var.regions[var.primary_region].log_name
}


############################# LAMBDA CURL TEST ##############################################

module "Lambda_test_use" {
  depends_on = [module.networks_use]
  providers = {
    aws = aws.primary
  }
  source             = "../modules/lambda"
  lambda_curl_arn    = module.iam_role.lambda_curl_arn
  apigw_invoke_curl  = module.apigw_use.api_endpoint
  subnet_ids         = module.networks_use.subnet_id
  security_group_ids = module.networks_use.security_group_id
  apigw_path_part    = module.apigw_use.path_part
  region             = var.regions[var.primary_region].region
}







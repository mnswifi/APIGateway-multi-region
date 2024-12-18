########################### API Gateway  ######################################

module "apigw_usw" {
  source = "../modules/apigw"
  providers = {
    aws = aws.secondary
  }
  vpc_id = module.networks_usw.vpc_id
  log_groups_arn = module.cloudwatch_usw.log_groups_arn
  region = var.secondary_region
  http_method = var.regions[var.secondary_region].http_method
  api_gateway_role_arn = module.iam_role.api_gateway_role_arn  
}



########################### VPC AND SECURITY GROUPS ##############################

module "networks_usw" {
  source = "../modules/networks"
  providers = {
    aws = aws.secondary
  }
  vpc_cidr_block = var.regions[var.secondary_region].vpc_cidr_block
  region = var.secondary_region
  protocol = var.regions[var.secondary_region].protocol
  port = var.regions[var.secondary_region].port
}

################################ CLOUDWATCH LOG GROUPS #################################################

module "cloudwatch_usw" {
  source = "../modules/cloudwatch"
  providers = {
    aws = aws.secondary
  }
}










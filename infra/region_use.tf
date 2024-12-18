########################### API Gateway  ######################################

module "apigw_use" {
  source = "../modules/apigw"
  providers = {
    aws = aws.primary
  }
  vpc_id               = module.networks_use.vpc_id
  log_groups_arn       = module.cloudwatch_use.log_groups_arn
  region               = var.primary_region
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
  region         = var.primary_region
  protocol       = var.regions[var.primary_region].protocol
  port           = var.regions[var.primary_region].port
}


################################# DYNAMO DB #################################################

module "dynamodb_use" {
  source             = "../modules/dynamodb"
  providers          = { aws = aws.primary }
  table_name         = "GameScores"
  billing_mode       = "PAY_PER_REQUEST"
  hash_key           = "userId"
  range_key          = "GameTitle"
  hash_key_type      = "S"
  range_key_type     = "S"
  ttl_attribute_name = "TimeToExist"
  ttl_enabled        = true
  create_replica     = true

  global_secondary_indexes = [
    {
      name               = "GameTitleIndex"
      hash_key           = "GameTitle"
      range_key          = "TopScore"
      projection_type    = "INCLUDE"
      non_key_attributes = ["userId"]
    }
  ]
}



################################ CLOUDWATCH LOG GROUPS #################################################

module "cloudwatch_use" {
  source = "../modules/cloudwatch"
  providers = {
    aws = aws.primary
  }
  log_name = var.regions[var.primary_region].log_name
}










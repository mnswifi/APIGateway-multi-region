########################### API Gateway  ######################################

module "apigw_usw" {
  source = "../modules/apigw"
  providers = {
    aws = aws.secondary
  }
  log_groups_arn = module.cloudwatch_usw.log_groups_arn
  region = var.secondary_region
  http_method = var.http_method
  api_gateway_role_arn = module.iam_role.api_gateway_role_arn  
}



########################### VPC AND SECURITY GROUPS ##############################

module "networks_usw" {
  source = "../modules/networks"
  providers = {
    aws = aws.secondary
  }
  vpc_cidr_block = var.vpc_cidr_block
  region = var.secondary_region
  protocol = var.protocol
  port = var.port
}


################################# DYNAMO DB #################################################

module "dynamodb_usw" {
  source              = "../modules/dynamodb"
  providers           = { aws = aws.secondary }
  table_name          = "GameScores"
  billing_mode        = "PAY_PER_REQUEST"
  hash_key            = "userId"
  range_key           = "GameTitle"
  hash_key_type       = "S"
  range_key_type      = "S"
  ttl_attribute_name  = "TimeToExist"
  ttl_enabled         = true
  create_replica      = true

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

module "cloudwatch_usw" {
  source = "../modules/cloudwatch"
  providers = {
    aws = aws.secondary
  }
}










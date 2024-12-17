########################### API Gateway  ######################################

module "apigw" {
  source = "../modules/apigw"
  providers = {
    aws = aws.primary
  }
  log_groups_arn = module.cloudwatch.log_groups_arn
  region = var.primary_region
  http_method = var.http_method
  api_gateway_role_arn = module.iam_role.api_gateway_role_arn
  
}



########################### VPC AND SECURITY GROUPS ##############################

module "networks" {
  source = "../modules/networks"
  providers = {
    aws = aws.primary
  }
  vpc_cidr_block = var.vpc_cidr_block
  region = var.primary_region
  protocol = var.protocol
  port = var.port
}


################################# DYNAMO DB #################################################

module "dynamodb" {
  source              = "../modules/dynamodb"
  providers           = { aws = aws.primary }
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

module "cloudwatch" {
  source = "../modules/cloudwatch"
  providers = {
    aws = aws.primary
  }
}










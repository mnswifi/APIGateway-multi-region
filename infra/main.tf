########################### API Gateway  ######################################

module "apigw" {
  source = "../modules/apigw"
  providers = {
    aws = aws.primary
  }
  log_groups_arn = module.cloudwatch.log_groups_arn
  region = var.region1
  http_method = var.http_method
  api_gateway_role_arn = module.iam_role.api_gateway_role_arn
  
}

########################### IAM ROLE  ######################################

module "iam_role" {
  source = "../modules/iam"
  providers = {
    aws = aws.primary
  }
  region = var.region1
  dynamodb_table_arn = module.dynamodb.dynamodb_arn
  apigw_id = module.apigw.apigw_id
  vpc_id = module.networks.vpc_id
  
}


########################### VPC AND SECURITY GROUPS ##############################

module "networks" {
  source = "../modules/networks"
  providers = {
    aws = aws.primary
  }
  vpc_cidr_block = var.vpc_cidr_block
  region = var.region1
  protocol = var.protocol
  port = var.port
  
}


################################# DYNAMO DB #################################################

# module "dynamodb" {
#     source = "../module/dynamodb"
#     providers = {
#     aws = aws.primary
#   }
# }




################################ CLOUDWATCH LOG GROUPS #################################################

module "cloudwatch" {
  source = "../modules/cloudwatch"
  providers = {
    aws = aws.primary
  }
  lambda_role_id = "" 
}




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

  tags = {
    Name        = "dynamodb-primary"
    Environment = "dev"
  }
}

# module "dynamodb_replica" {
#   source              = "../module/dynamodb"
#   providers           = { aws = aws.replica }
#   table_name          = "GameScores"
#   billing_mode        = "PAY_PER_REQUEST"
#   hash_key            = "customerId"
#   range_key           = "GameTitle"
#   hash_key_type       = "S"
#   range_key_type      = "S"
#   ttl_attribute_name  = "TimeToExist"
#   ttl_enabled         = true
#   create_replica      = false # Replica is created from the primary table

#   tags = {
#     Name        = "dynamodb-replica"
#     Environment = "dev"
#   }
# }






########################### API Gateway  ######################################

module "apigw" {
  source = "../module/apigw"
  provider = aws.secondary
  log_groups_arn = module.cloudwatch.log_groups_arn
  region = var.region
  http_method = var.http_method
  
}

########################### IAM ROLE  ######################################

module "iam_role" {
  source = "../module/iam"
  provider = aws.primary
  region = var.region
  dynamodb_table_arn = module.dynamodb.dynamodb_arn
  apigw_id = module.apigw.apigw_id
  vpc_id = module.networks.vpc_id
  
}


########################### VPC AND SECURITY GROUPS ##############################

module "networks" {
  source = "../module/networks"
  provider = aws.primary
  vpc_cidr_block = var.vpc_cidr_block
  region = var.region
  protocol = var.protocol
  port = var.port
  
}


################################# DYNAMO DB #################################################

module "dynamodb" {
    source = "../module/dynamodb"
    provider = aws.primary
}




################################ CLOUDWATCH LOG GROUPS #################################################

module "cloudwatch" {
  source = "../module/cloudwatch"
  provider = aws.primary
  lambda_role_id = module.iam_role.lambda_role_id  
}



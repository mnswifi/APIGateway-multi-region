########################### IAM ROLE  ######################################


module "iam_role" {
  source = "../modules/iam"
  providers = {
    aws = aws.primary
  }
  dynamodb_table_arn = module.dynamodb.dynamodb_arn
  apigw_id = module.apigw.apigw_id
  log_group_arn = module.cloudwatch.log_groups_arn
  apigw_arn = module.apigw.apigw_arn
  vpc_id = module.networks.vpc_id
  dynamodb_table_name = module.dynamodb.table_name
}


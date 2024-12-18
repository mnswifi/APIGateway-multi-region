########################### IAM ROLE  ######################################


module "iam_role" {
  source = "../modules/iam"
  providers = {
    aws = aws.primary
  }

  vpc_ids = {
    use = module.networks_use.vpc_id
    usw = module.networks_usw.vpc_id
  }

  log_group_arns = {
    use = module.cloudwatch_use.log_groups_arn
    usw = module.cloudwatch_usw.log_groups_arn
  }

  apigw_arns = {
    use = module.apigw_use.apigw_arn
    usw = module.apigw_usw.apigw_arn
  }

  dynamodb_table_arn = module.dynamodb_use.dynamodb_arn 
  dynamodb_table_name = module.dynamodb_use.table_name
}


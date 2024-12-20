######################## Regions Variable Configurations ############################
primary_region   = "us-east-1"
secondary_region = "us-west-2"

regions = {
  "us-east-1" = {
    vpc_cidr_block = "10.0.0.0/16"
    port_http      = 80
    port_https     = 443
    protocol       = "tcp"
    http_method    = "GET"
    environment    = "dev"
    log_name       = "east-log"
    billing_mode   = "PAY_PER_REQUEST"
    table_name     = "GameScores"
    hash_key       = "userId"
    region         = "east"

  }
  "us-west-2" = {
    vpc_cidr_block = "10.1.0.0/16"
    port_http      = 80
    port_https     = 443
    protocol       = "tcp"
    http_method    = "GET"
    environment    = "dev"
    log_name       = "west-log"
    region         = "west"
  }
}






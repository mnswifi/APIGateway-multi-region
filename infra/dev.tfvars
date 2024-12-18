

primary_region = "us-east-1"
secondary_region = "us-west-2"


regions = {
  "us-east-1" = {
    vpc_cidr_block = "10.0.0.0/16"
    port           = 80
    protocol       = "tcp"
    http_method    = "GET"
    environment    = "dev"
  }
  "us-west-2" = {
    vpc_cidr_block = "10.1.0.0/16"
    port           = 80
    protocol       = "tcp"
    http_method    = "GET"
    environment    = "dev"
  }
}

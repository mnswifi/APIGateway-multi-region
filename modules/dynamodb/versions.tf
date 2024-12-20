# Required version and providers
terraform {
  required_version = "~>1.10.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}


# Primary Region
provider "aws" {
  region = "us-east-1"
  alias  = "primary"
}

# Secondary Region
provider "aws" {
  region = "us-west-2"
  alias  = "secondary"
}
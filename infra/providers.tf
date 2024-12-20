# Required versions and providers
terraform {
  required_version = "~>1.10.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

# Primary Region
provider "aws" {
  region = var.primary_region
  alias  = "primary"

  default_tags {
    tags = {
      Environment = "dev-east"
      Owner       = "terraform"
      Project     = "terraform-challenge"
    }
  }
}

# Secondary Region
provider "aws" {
  region = var.secondary_region
  alias  = "secondary"

  default_tags {
    tags = {
      Environment = "dev-west"
      Owner       = "terraform"
      Project     = "terraform-challenge"
    }
  }
}
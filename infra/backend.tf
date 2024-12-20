# terraform {
#   backend "s3" {
#     bucket         = "tf-challenge-state-bucket"
#     key            = "global/state.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "tf-challenge-state-lock"
#   }
# }
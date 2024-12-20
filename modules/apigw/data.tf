# Obtain current aws region
data "aws_region" "current" {}

# Obtain current aws current identity
data "aws_caller_identity" "current" {}
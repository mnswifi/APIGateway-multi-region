




################### API Gateway  ######################################

# Create API Gateway



# Create Integration Request




# Create Integration Response



# IAM role for dynamodb query and policy




################################# DYNAMO DB #################################################

# Create 

module "dynamodb" {
    source = "../module/dynamodb"
    provider = aws.primary
}




################################ CLOUDWATCH #################################################

# create cloudwatch log group


# create policy for log group




################################## LAMBDA - curl test #######################################

# Create Lambda curl test 

# Lambda for Testing
resource "aws_lambda_function" "test_lambda" {
  filename         = "test_logic.zip"
  function_name    = "test-api-gateway"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"

  environment {
    variables = {
      API_URL = "${aws_apigateway_rest_api.rest_api.execution_arn}/${aws_apigateway_stage.stage.stage_name}/data"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}





# 
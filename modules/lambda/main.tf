
# provider "aws" {
#   region = "us-east-1" # Replace with your desired region
# }


# Lambda Function
resource "aws_lambda_function" "curl_test_lambda" {
  # depends_on = [ data.archive_file.lambda_payload ]
  function_name = "CurlToApiGateway"
  role          = var.lambda_curl_arn
  handler       = "lambda_curl.lambda_handler"
  runtime       = "python3.12"

  # Inline Python code for testing the curl command
  filename         = "${path.module}/lambda_payload.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_payload.zip")

  # VPC config
  vpc_config {
    subnet_ids         = [var.subnet_ids]
    security_group_ids = [var.security_group_ids]
  }

  # Environment Variables (Optional)
  environment {
    variables = {
      API_GATEWAY_URL = "${var.apigw_invoke_curl}/${var.apigw_path_part}" //"https://your-api-gateway-url.amazonaws.com/accounts?accountId=123456789" 
    }
  }

  memory_size = 128
  timeout     = 10
}

# Archive Lambda Function Code
# data "archive_file" "lambda_payload" {
#   type        = "zip"
#   source_dir  = "${path.module}/lambda_code"
#   output_path = "${path.module}/lambda_payload.zip"
# }


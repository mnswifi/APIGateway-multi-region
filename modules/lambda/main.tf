######################## LAMBDA FUNCTION FOR CURL TEST ######################################

# Lambda Function
resource "aws_lambda_function" "curl_test_lambda" {
  function_name = "CurlToApiGateway-${var.region}"
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
      API_GATEWAY_URL = "${var.apigw_invoke_curl}/${var.apigw_path_part}"
    }
  }

  memory_size = 128
  timeout     = 10
}
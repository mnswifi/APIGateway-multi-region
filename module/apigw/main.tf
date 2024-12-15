# REST API Gateway
resource "aws_apigateway_rest_api" "rest_api" {
  name        = "multi-region-api"
  description = "Multi-region DynamoDB access"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

# Resource for API Gateway
resource "aws_apigateway_resource" "resource" {
  rest_api_id = aws_apigateway_rest_api.rest_api.id
  parent_id   = aws_apigateway_rest_api.rest_api.root_resource_id
  path_part   = "registry"
}

# Integration with DynamoDB (Lambda Proxy)
resource "aws_apigateway_method" "method_get" {
  rest_api_id   = aws_apigateway_rest_api.rest_api.id
  resource_id   = aws_apigateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# IAM Role for API Gateway to access DynamoDB
resource "aws_iam_role" "api_gateway_role" {
  name               = "api-gateway-dynamodb-role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}



resource "aws_apigateway_integration" "integration_dynamodb" {
  rest_api_id = aws_apigateway_rest_api.rest_api.id
  resource_id = aws_apigateway_resource.resource.id
  http_method = aws_apigateway_method.method_get.http_method
  type        = "AWS"
  integration_http_method = "POST"
  uri         = "arn:aws:apigateway:${data.aws_region.current.name}:dynamodb:action/Query"
  credentials = var.api_gateway_role_arn
#   request_parameters = {
#     "integration.request.querystring.TableName" = aws_dynamodb_table.dynamodb_us_east_1.name
#   }
}


# API Deployment
resource "aws_apigateway_deployment" "deployment" {
  rest_api_id = aws_apigateway_rest_api.rest_api.id
  depends_on  = [aws_apigateway_method.method_get]
}

resource "aws_apigateway_stage" "stage" {
  deployment_id = aws_apigateway_deployment.deployment.id
  rest_api_id   = aws_apigateway_rest_api.rest_api.id
  stage_name    = "development"

  xray_tracing_enabled = true
  

  access_log_settings {
    destination_arn = var.log_groups_arn
    format          = jsonencode({
      requestId       = "$context.requestId",
      ip              = "$context.identity.sourceIp",
      caller          = "$context.identity.caller",
      user            = "$context.identity.user",
      requestTime     = "$context.requestTime",
      httpMethod      = "$context.httpMethod",
      resourcePath    = "$context.resourcePath",
      status          = "$context.status",
      protocol        = "$context.protocol",
      responseLength  = "$context.responseLength"
    })
  }
}









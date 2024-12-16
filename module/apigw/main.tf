# REST API Gateway
resource "aws_apigateway_rest_api" "rest_api" {
  name        = "multi-region-api"
  description = "Multi-region DynamoDB access"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

# Resource for API Gateway
resource "aws_apigateway_resource" "tf_resource" {
  rest_api_id = aws_apigateway_rest_api.rest_api.id
  parent_id   = aws_apigateway_rest_api.rest_api.root_resource_id
  path_part   = "registry"
}

# Integration with DynamoDB (Lambda Proxy)
resource "aws_apigateway_method" "method_get" {
  rest_api_id   = aws_apigateway_rest_api.rest_api.id
  resource_id   = aws_apigateway_resource.resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

################## Integration to DynamoDB ##################
resource "aws_apigateway_integration" "integration_dynamodb" {
  rest_api_id             = aws_apigateway_rest_api.rest_api.id
  resource_id             = aws_apigateway_resource.tf_resource.id
  http_method             = aws_apigateway_method.method_get.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:dynamodb:action/Query"
  credentials             = var.api_gateway_role_arn

  request_templates = {
    "application/json" = <<EOF
    {
      "TableName": "GameScores",
      "KeyConditionExpression": "customerId = :customerId AND GameTitle = :gameTitle",
      "ExpressionAttributeValues": {
        ":customerId": {
          "S": "$input.params('customerId')"
        },
        ":gameTitle": {
          "S": "$input.params('gameTitle')"
        }
      }
    }
    EOF
  }
}


################## Integration Response #################################

resource "aws_api_gateway_integration_response" "tf_response" {
  http_method = aws_apigateway_method.method_get.http_method
  resource_id = aws_apigateway_resource.tf_resource.id
  rest_api_id = aws_apigateway_rest_api.rest_api.id
  status_code = "200"

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$'))
    {
      "customerId": "$inputRoot.Items[0].customerId.S",
      "GameTitle": "$inputRoot.Items[0].GameTitle.S",
      "TopScore": "$inputRoot.Items[0].TopScore.N"
    }
    EOF
  }
}

################## Method Response ################################

resource "aws_api_gateway_method_response" "tf_response_method" {
  http_method = aws_apigateway_method.method_get.http_method
  resource_id = aws_apigateway_resource.tf_resource.id
  rest_api_id = aws_apigateway_rest_api.rest_api.id
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}



# API Deployment
resource "aws_apigateway_deployment" "deployment" {
  rest_api_id = aws_apigateway_rest_api.rest_api.id
  depends_on  = [aws_apigateway_method.method_get]
}

resource "aws_apigateway_stage" "tf_stage" {
  deployment_id = aws_apigateway_deployment.deployment.id
  rest_api_id   = aws_apigateway_rest_api.rest_api.id
  stage_name    = "development"

  xray_tracing_enabled = true


  access_log_settings {
    destination_arn = var.log_groups_arn
    format = jsonencode({
      requestId      = "$context.requestId",
      ip             = "$context.identity.sourceIp",
      caller         = "$context.identity.caller",
      user           = "$context.identity.user",
      requestTime    = "$context.requestTime",
      httpMethod     = "$context.httpMethod",
      resourcePath   = "$context.resourcePath",
      status         = "$context.status",
      protocol       = "$context.protocol",
      responseLength = "$context.responseLength"
    })
  }
}


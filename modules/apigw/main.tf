################################# APIGATEWAY ##########################################
# Resource Rest API Gateway
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "multi-region-api"
  description = "Multi-region DynamoDB access"

  endpoint_configuration {
    types = ["PRIVATE"]
  }
}

# Resource API Gateway path
resource "aws_api_gateway_resource" "tf_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "records"
}

# Resource API Gateway method
resource "aws_api_gateway_method" "method_get" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.tf_resource.id
  http_method   = var.http_method
  authorization = "NONE"
}

############################# Integration to DynamoDB ############################
# Resource API Gateway Dynamodb Integration
resource "aws_api_gateway_integration" "integration_dynamodb" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.tf_resource.id
  http_method             = aws_api_gateway_method.method_get.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:dynamodb:action/Query"
  credentials             = var.api_gateway_role_arn

  request_templates = {
    "application/json" = <<EOF
    {
      "TableName": "GameScores",
      "KeyConditionExpression": "userId = :userId",
      "ProjectionExpression": "userId, gameTitle, TopScore",
      "ExpressionAttributeValues": {
        ":userId": {
          "S": "$input.params('userId')"
        }
      }
    }
    EOF
  }
  passthrough_behavior = "WHEN_NO_MATCH"
}


############################### Integration Response #################################
# Resource API Gateway Integration response
resource "aws_api_gateway_integration_response" "tf_response" {
  depends_on  = [aws_api_gateway_integration.integration_dynamodb]
  http_method = aws_api_gateway_method.method_get.http_method
  resource_id = aws_api_gateway_resource.tf_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  status_code = "200"

  response_templates = {
    "application/json" = <<EOF
    #set($inputRoot = $input.path('$'))
    {
      "userId": "$inputRoot.Items[0].userId.S",
      "gameTitle": "$inputRoot.Items[0].gameTitle.S",
      "TopScore": "$inputRoot.Items[0].TopScore.N"
    }
    EOF
  }
}

############################ Method Response ################################
# Resource API Gateway method response
resource "aws_api_gateway_method_response" "tf_response_method" {
  http_method = aws_api_gateway_method.method_get.http_method
  resource_id = aws_api_gateway_resource.tf_resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  status_code = "200"

  response_parameters = {
    "method.response.header.Content-Type" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}



# Resource API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  depends_on  = [aws_api_gateway_method.method_get, aws_api_gateway_rest_api_policy.example_policy]
}

# Resource API Gateway Stage
resource "aws_api_gateway_stage" "tf_stage" {
  depends_on    = [aws_api_gateway_account.account_settings]
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = "dev"

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


# Resource Policy to Restrict API Gateway Access to VPC
resource "aws_api_gateway_rest_api_policy" "example_policy" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  policy      = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.rest_api.id}/*",
        "Condition": {
          "StringEquals": {
            "aws:SourceVpc": "${var.vpc_id}"
          }
        }
      }
    ]
  }
  EOF
}

# Resource API Gateway account settings
resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = var.api_gateway_role_arn
  reset_on_delete     = true
}

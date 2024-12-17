data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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




resource "aws_iam_policy" "dynamodb_policy" {
  name   = "dynamodb-access-policy"
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "dynamodb:Query",
        "Resource": "arn:aws:dynamodb:*:${data.aws_caller_identity.current.account_id}:table/${var.dynamodb_table_name}"
      }
    ]
  }
  EOF
}



resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}


# Resource Policy to Restrict API Gateway Access to VPC Endpoint
resource "aws_api_gateway_rest_api_policy" "example_policy" {
  rest_api_id = var.apigw_id
  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": "*",
        "Action": "execute-api:Invoke",
        "Resource": "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.apigw_id}/*",
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



resource "aws_cloudwatch_log_resource_policy" "tf_log_policy" {
  policy_name = "tf_resource_policy"
  policy_document = jsonencode(
    {
      "Version": "2012-10-17",
      "Id":"CWLogsPolicy"
      "Statement": [
        {
          "Effect":"Allow",
          "Principal":{
            "Service":[
              "apigateway.amazonaws.com",
              "delivery.logs.amazonaws.com"
            ]
          },
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource": var.log_group_arn,
          "Condition":{
            "ArnEquals": {
              "aws:SourceArn" : var.apigw_arn
            }
          }
        }
      ]
    }
  )  
}


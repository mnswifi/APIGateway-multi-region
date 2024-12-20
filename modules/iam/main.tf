#################################### IAM ROLES AND POLICIES #################################
# IAM Role for API Gateway to access DynamoDB
resource "aws_iam_role" "api_gateway_role" {
  name               = "api-gateway-role"
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


# Dnamodb policy for API Gateway
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


# Cloud watch log resource policy for API Gateway role
resource "aws_cloudwatch_log_resource_policy" "tf_log_policy" {
  policy_name = "tf_resource_policy"
  policy_document = jsonencode(
    {
      "Version" : "2012-10-17",
      "Id" : "CWLogsPolicy",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "apigateway.amazonaws.com",
              "delivery.logs.amazonaws.com"
            ]
          },
          "Action" : [
            "logs:CreatLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : values(var.log_group_arns),
          "Condition" : {
            "ArnEquals" : {
              "aws:SourceArn" : values(var.apigw_arns)
            }
          }
        }
      ]
    }
  )
}


# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda Execution Role
resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "EC2:*"
        ]
        Resource = "*"
      }
    ]
  })
}




# Dynamodb policy attachment for API Gateway role
resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

# CloudWatch log policy for API Gateway role
resource "aws_iam_role_policy_attachment" "api_gateway_role_policy" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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
          "Service": ["apigateway.amazonaws.com",
          "delivery.logs.amazonaws.com"]
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



resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "CloudWatchLogsPolicy"
  description = "Policy to allow API Gateway to write logs to CloudWatch"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = values(var.log_group_arns),
        Condition = {
          ArnEquals = {
            "aws:SourceArn": values(var.apigw_arns)
          }
        }
      }
    ]
  })
}





resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}


resource "aws_iam_role_policy_attachment" "attach_logs_policy" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}

resource "aws_iam_role_policy_attachment" "api_gateway_role_policy" {
  role       = aws_iam_role.api_gateway_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}





# resource "aws_cloudwatch_log_resource_policy" "tf_log_policy" {
#   policy_name = "tf_resource_policy"
#   policy_document = jsonencode(
#     {
#       "Version": "2012-10-17",
#       "Id":"CWLogsPolicy",
#       "Statement": [
#         {
#           "Effect":"Allow",
#           "Principal":{
#             "Service":[
#               "apigateway.amazonaws.com",
#               "delivery.logs.amazonaws.com"
#             ]
#           },
#           "Action" : [
#             "logs:CreatLogGroup",
#             "logs:CreateLogStream",
#             "logs:PutLogEvents"
#           ],
#           "Resource": values(var.log_group_arns),
#           "Condition":{
#             "ArnEquals": {
#               "aws:SourceArn" : values(var.apigw_arns)
#             }
#           }
#         }
#       ]
#     }
#   )  
# }


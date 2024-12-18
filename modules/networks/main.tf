# Create VPC Endpoint for API Gateway
# resource "aws_vpc_endpoint" "api_gateway" {
#   vpc_id            = "<your-vpc-id>" # Replace with your VPC ID
#   service_name      = "com.amazonaws.${var.region}.execute-api"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = ["<sg-id>"] # Replace with a security group ID allowing traffic
#   subnet_ids        = ["<subnet-id-1>", "<subnet-id-2>"] # Replace with subnet IDs
# }


resource "aws_vpc" "tf_challenge_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "tf_private_subnet" {
  vpc_id     = aws_vpc.tf_challenge_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 0)

}


resource "aws_security_group" "tf_sg" {
  name        = "Allow http traffic"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.tf_challenge_vpc.id

  tags = {
    name = "allow-${var.protocol}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.tf_sg.id
  cidr_ipv4         = aws_vpc.tf_challenge_vpc.cidr_block
  from_port         = var.port
  ip_protocol       = var.protocol
  to_port           = var.port
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}




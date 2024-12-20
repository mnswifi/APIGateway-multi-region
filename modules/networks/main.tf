############################# VPC, SECURITY GROUP, SUBNETS ###################################### 

# Create VPC
resource "aws_vpc" "tf_challenge_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "tf_private_subnet" {
  vpc_id     = aws_vpc.tf_challenge_vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 0)
}

# Create Security Group
resource "aws_security_group" "tf_sg" {
  name        = "Allow http/https traffic"
  description = "Allow http/https inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.tf_challenge_vpc.id

  tags = {
    name = "allow-${var.protocol}"
  }
}

# Create HTTP rules
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.tf_sg.id
  cidr_ipv4         = aws_vpc.tf_challenge_vpc.cidr_block
  from_port         = var.port_http
  ip_protocol       = var.protocol
  to_port           = var.port_http
}

# Create HTTPS rules
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.tf_sg.id
  cidr_ipv4         = aws_vpc.tf_challenge_vpc.cidr_block
  from_port         = var.port_https
  ip_protocol       = var.protocol
  to_port           = var.port_https
}


# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.tf_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Create VPC Endpoint for API Gateway
resource "aws_vpc_endpoint" "apigw_vpce" {
  depends_on          = [aws_subnet.tf_private_subnet]
  vpc_id              = aws_vpc.tf_challenge_vpc.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.execute-api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.tf_sg.id]
  subnet_ids          = [aws_subnet.tf_private_subnet.id]
  private_dns_enabled = true
}


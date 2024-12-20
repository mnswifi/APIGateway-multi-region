# Output VPC id
output "vpc_id" {
  value = aws_vpc.tf_challenge_vpc.id
}

# Output Security group id
output "security_group_id" {
  value = aws_security_group.tf_sg.id
}

# output private Subnet id
output "subnet_id" {
  value = aws_subnet.tf_private_subnet.id
}

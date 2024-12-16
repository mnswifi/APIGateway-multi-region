output "vpc_id" {
  value = aws_vpc.tf_challenge_vpc.id
}

output "tf_sg_id" {
  value = aws_security_group.tf_sg.id
}

output "tf_private_subnet_id" {
  value = aws_subnet.tf_private_subnet.id
}
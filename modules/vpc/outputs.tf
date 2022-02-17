output "vpc_id" {
  value = aws_vpc.carlos.id
}

output "pub_subnets" {
  value = aws_subnet.pub[*].id 
}

output "priv_subnets" {
  value = aws_subnet.priv[*].id 
}
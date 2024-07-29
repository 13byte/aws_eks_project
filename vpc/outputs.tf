# Availability_zones
output "availability_zones" {
  description = "Availability zone list of VPC"
  value       = var.availability_zones
}

# VPC
output "vpc_name" {
  description = "The name of the VPC which is also the environment name"
  value       = var.vpc_name
}

output "vpc_id" {
  description = "VPC ID of newly created VPC"
  value       = aws_vpc.default.id
}

output "cidr_block" {
  description = "CIDR block of VPC"
  value       = aws_vpc.default.cidr_block
}

output "cidr_numeral" {
  description = "number that specifies the vpc range (B class)"
  value       = var.cidr_numeral
}

output "short_azs" {
  description = "Short version of Availavility Zone"
  value       = var.short_azs
}

# Public subnets
output "public_subnets" {
  description = "List of public subnet ID in VPC"
  value       = aws_subnet.public.*.id
}

# Prviate WAS subnets
output "was_private_subnets" {
  description = "List of private subnet ID in VPC"
  value       = aws_subnet.private_was.*.id
}

# Private Database Subnets
output "db_private_subnets" {
  description = "List of DB private subnet ID in VPC"
  value       = aws_subnet.private_db.*.id
}

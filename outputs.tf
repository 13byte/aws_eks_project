# Region
output "aws_region" {
  description = "리전"
  value       = var.aws_region
}

# VPC
output "availability_zones" {
  description = "vpc 가용 영역"
  value       = module.vpc.availability_zones
}

output "vpc_name" {
  description = "vpc 이름"
  value       = module.vpc.vpc_name
}

output "vpc_id" {
  description = "vpc id"
  value       = module.vpc.vpc_id
}

output "cidr_block" {
  description = "vpc cidr block"
  value       = module.vpc.cidr_block
}

output "cidr_numeral" {
  description = "vpc b class에 들어간 숫자"
  value       = module.vpc.cidr_numeral
}

output "short_azs" {
  description = "짧은 가용 영역"
  value       = module.vpc.short_azs
}

output "public_subnets" {
  description = "vpc public subnets 리스트"
  value       = module.vpc.public_subnets
}

output "was_private_subnets" {
  description = "vpc was private subnets 리스트"
  value       = module.vpc.was_private_subnets
}

output "db_private_subnets" {
  description = "vpc db priavate subnets 리스트"
  value       = module.vpc.db_private_subnets
}

# EKS
output "cluster_id" {
  description = "클러스터 id"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "클러스터 arn"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "클러스터 API Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_default_security_group_id" {
  description = "클러스터 vpc config 보안그룹 id"
  value       = module.eks.cluster_default_security_group_id
}

output "cluster_security_group_id" {
  description = "클러스터 보안그룹 id"
  value       = module.eks.cluster_security_group_id
}

output "aws_auth_config_map" {
  description = "aws-auth ConfigMap 설정"
  value       = module.eks.aws_auth_config_map
}

output "coredns_version" {
  value = module.eks.coredns_version
}

output "kube_proxy_version" {
  value = module.eks.kube_proxy_version
}

output "vpc_cni_version" {
  value = module.eks.vpc_cni_version
}

output "ebs_csi_driver_version" {
  value = module.eks.ebs_csi_driver_version
}

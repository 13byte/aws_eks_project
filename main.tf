module "vpc" {
  source = "./vpc"

  vpc_name           = var.vpc_name
  availability_zones = var.availability_zones
  short_azs          = var.short_azs

  cidr_numeral             = var.cidr_numeral
  cidr_numeral_public      = var.cidr_numeral_public
  cidr_numeral_private_was = var.cidr_numeral_private_was
  cidr_numeral_private_db  = var.cidr_numeral_private_db
}

module "eks" {
  source = "./eks"

  target_vpc = module.vpc.vpc_id

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_enable_public_access = var.cluster_enable_public_access
  cluster_subnet_ids           = flatten([module.vpc.public_subnets, module.vpc.was_private_subnets])
  cluster_private_subnet_ids   = module.vpc.was_private_subnets
  cluster_public_access_cidrs  = var.cluster_public_access_cidrs

  iam_group_name = var.iam_group_name
  aws_profile    = var.aws_profile

  node_group_configurations = var.node_group_configurations

  coredns_version        = var.coredns_version
  kube_proxy_version     = var.kube_proxy_version
  vpc_cni_version        = var.vpc_cni_version
  ebs_csi_driver_version = var.ebs_csi_driver_version
}

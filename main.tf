module "vpc" {
  source = "./vpc"

  vpc_name           = var.vpc_name
  availability_zones = var.availability_zones
  short_azs          = var.short_azs

  cidr_numeral             = var.cidr_numeral
  cidr_numeral_public      = var.cidr_numeral_public
  cidr_numeral_private_was = var.cidr_numeral_private_was
  cidr_numeral_private_db  = var.cidr_numeral_private_db

  cluster_name = var.cluster_name
}

module "route53" {
  source = "./route53"

  vpc_name    = var.vpc_name
  vpc_id      = module.vpc.vpc_id
  domain_name = var.domain_name

  cloudfront_domain_name         = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id      = module.cloudfront.cloudfront_hosted_zone_id
  cert_domain_validation_options = module.acm.cert_domain_validation_options

  rds_address = module.rds.rds_address
}

module "eks" {
  source = "./eks"
  region = var.aws_region

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
  coredns_version           = var.coredns_version
  kube_proxy_version        = var.kube_proxy_version
  vpc_cni_version           = var.vpc_cni_version
  ebs_csi_driver_version    = var.ebs_csi_driver_version

  # acm_elb_arn = module.acm.elb_arn
}

module "acm" {
  source = "./acm"

  domain_name = var.domain_name
}

module "acm_validation" {
  source = "./acm/acm_validation"

  cloudfront_certificate_arn = module.acm.cloudfront_arn
  # elb_certificate_arn        = module.acm.elb_arn
  validation_record_fqdns = [module.route53.cert_validation_fqdn]
}

module "cloudfront" {
  source = "./cloudfront"

  domain_name = var.domain_name
  waf_arn     = module.waf.waf_arn

  acm_cloudfront_arn = module.acm.cloudfront_arn
  origin_lb_dns_name = module.elb.dns_name
  origin_lb_id       = module.elb.id
}

module "waf" {
  source = "./waf"

  vpc_name = var.vpc_name
}

module "rds" {
  source = "./rds"

  vpc_id   = module.vpc.vpc_id
  vpc_name = var.vpc_name

  root_username = var.root_username
  root_password = var.root_password
  init_db_name  = var.init_db_name

  additional_ingress = [
    {
      from_port       = 3306
      to_port         = 3306
      protocol        = "tcp"
      security_groups = [module.eks.cluster_default_security_group_id]
    }
  ]

  db_subnet = module.vpc.db_private_subnets
}

module "elb" {
  source = "./elb"

  depends_on = [module.eks.kubernetes_ingress_v1]
}

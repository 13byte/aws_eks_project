variable "aws_region" {
  description = "리전"
  default     = "ap-northeast-2"
}

variable "domain_name" {
  description = "사용할 도메인 이름"
}

# VPC

variable "vpc_name" {
  description = "VPC 이름"
}

variable "cidr_numeral" {
  description = "VPC B Class에 들어갈 숫자"
}

variable "availability_zones" {
  type        = list(string)
  description = "가용 영역"
}

variable "short_azs" {
  type        = list(string)
  description = "짧은 가용 영역"
}

variable "cidr_numeral_public" {
  description = "Subnet C Class에 들어갈 숫자"
  default = {
    "0" = "0"
    "1" = "16"
    "2" = "32"
  }
}

variable "cidr_numeral_private_was" {
  description = "Subnet C Class에 들어갈 숫자"
  default = {
    "0" = "80"
    "1" = "96"
    "2" = "112"
  }
}

variable "cidr_numeral_private_db" {
  description = "Subnet C Class에 들어갈 숫자"
  default = {
    "0" = "160"
    "1" = "176"
    "2" = "192"
  }
}

# EKS

variable "cluster_name" {
  description = "클러스터 이름"
  type        = string
}

variable "cluster_version" {
  description = "클러스터 버전"
  type        = string
}

variable "cluster_enable_public_access" {
  description = "EKS API 퍼블릭 여부"
  type        = bool
  default     = true
}

variable "cluster_public_access_cidrs" {
  description = "EKS API 퍼블릭 접근 IP"
  type        = list(string)
}

variable "additional_ingress" {
  description = "ingress security group"

  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
  }))
  default = []
}

variable "cluster_policy_list" {
  description = "클러스터 정책"
  type = list(object({
    type       = string
    identifier = list(string)
  }))
  default = []
}

variable "iam_group_name" {
  description = "EKS 클러스터에 접근 권한 부여할 IAM 그룹의 이름"
  type        = string
}

variable "aws_profile" {
  description = "aws profile"
  type        = string
  default     = ""
}

variable "node_group_configurations" {
  type = list(object({
    name                = string
    spot_enabled        = bool
    disk_size           = number
    ami_type            = string
    node_instance_types = list(string)
    node_min_size       = number
    node_desired_size   = number
    node_max_size       = number
  }))

  description = "노드 설정"
}

variable "coredns_version" {
  type = string
}

variable "kube_proxy_version" {
  type = string
}

variable "vpc_cni_version" {
  type = string
}

variable "ebs_csi_driver_version" {
  type = string
}

# RDS

variable "root_username" {
  type = string
}

variable "root_password" {
  type = string
}

variable "init_db_name" {
  type = string
}

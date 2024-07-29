variable "region" {

}

variable "target_vpc" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "cluster_subnet_ids" {
  type = list(string)
}

variable "cluster_private_subnet_ids" {
  type = any
}

variable "cluster_enable_public_access" {
  type    = bool
  default = true
}

variable "cluster_public_access_cidrs" {
  type = list(string)
}

variable "additional_ingress" {
  type = list(object({
    from_port       = number
    to_port         = number
    protocol        = string
    security_groups = list(string)
  }))
  default = []
}

variable "cluster_policy_list" {
  type = list(object({
    type       = string
    identifier = list(string)
  }))
  default = []
}

variable "iam_group_name" {
  type = string
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

variable "namespace" {
  description = "Kubernetes namespace for the application"
  default     = "spring-boot"
}

# variable "acm_elb_arn" {

# }

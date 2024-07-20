variable "domain_name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cloudfront_domain_name" {
  type = string
}

variable "cloudfront_hosted_zone_id" {
  type = string
}

variable "cert_domain_validation_options" {
  type = list(object({
    resource_record_name  = string
    resource_record_value = string
    resource_record_type  = string
  }))
}

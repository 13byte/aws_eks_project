variable "cloudfront_certificate_arn" {
  type = string
}

variable "validation_record_fqdns" {
  type = list(string)
}

output "cloudfront_arn" {
  value = aws_acm_certificate.cloudfront.arn
}

# output "elb_arn" {
#   value = aws_acm_certificate.elb.arn
# }

output "cert_domain_validation_options" {
  value = aws_acm_certificate.cloudfront.domain_validation_options
}

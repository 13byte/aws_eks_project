resource "aws_acm_certificate" "cloudfront" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = ["*.${var.domain_name}"]

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.virginia
}

# resource "aws_acm_certificate" "elb" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"

#   subject_alternative_names = ["*.${var.domain_name}"]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_acm_certificate_validation" "elb" {
#   certificate_arn         = aws_acm_certificate.elb.arn
#   validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
# }


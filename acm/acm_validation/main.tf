resource "aws_acm_certificate_validation" "cloudfront" {
  certificate_arn         = var.cloudfront_certificate_arn
  validation_record_fqdns = var.validation_record_fqdns

  provider = aws.virginia
}

data "aws_route53_zone" "kosa" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_zone" "internal" {
  name    = "${var.domain_name}.internal"
  comment = "${var.vpc_name}.internal - Managed by Terraform"

  vpc {
    vpc_id = var.vpc_id
  }
}

# acm validation
resource "aws_route53_record" "cert_validation" {
  allow_overwrite = true
  name            = var.cert_domain_validation_options[0].resource_record_name
  records         = [var.cert_domain_validation_options[0].resource_record_value]
  type            = var.cert_domain_validation_options[0].resource_record_type
  ttl             = 60
  zone_id         = data.aws_route53_zone.kosa.zone_id
}

# cloudfront alias1 (var.domain_name)
resource "aws_route53_record" "cloudfront_alias1" {
  name    = var.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.kosa.zone_id

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

# cloudfront alias2 (www.var.domain_name)
resource "aws_route53_record" "cloudfront_alias2" {
  name    = "www.${var.domain_name}"
  type    = "A"
  zone_id = data.aws_route53_zone.kosa.zone_id

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}

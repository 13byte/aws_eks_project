resource "aws_cloudfront_distribution" "distribution" {
  origin {
    domain_name              = aws_s3_bucket.origin_s3.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = aws_s3_bucket.origin_s3.id
  }

  origin {
    domain_name = var.origin_lb_dns_name
    origin_id   = var.origin_lb_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

    custom_header {
      name  = "X-Custom-Header"
      value = "}Y$ILp#~sY{qAA1"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.domain_name}"
  default_root_object = "index.html"

  aliases = ["${var.domain_name}", "www.${var.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.origin_s3.id
    compress         = true

    cache_policy_id = aws_cloudfront_cache_policy.s3_cache_policy.id

    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern     = "/api/*"
    target_origin_id = var.origin_lb_id
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    compress         = true

    cache_policy_id          = aws_cloudfront_cache_policy.alb_cache_policy.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.alb_origin_request_policy.id

    viewer_protocol_policy = "allow-all"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_cloudfront_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  web_acl_id = var.waf_arn
  provider   = aws.virginia
}

# OAC
resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "S3-OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# for s3 cache policy
resource "aws_cloudfront_cache_policy" "s3_cache_policy" {
  name = "s3-cache-policy"

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_gzip   = true
    enable_accept_encoding_brotli = true
  }

  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1

  comment = "Optimized cache policy for S3"
}


# for ALB policy
resource "aws_cloudfront_cache_policy" "alb_cache_policy" {
  name = "alb-cache-policy"

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "none"
    }

    query_strings_config {
      query_string_behavior = "none"
    }

    enable_accept_encoding_gzip   = false
    enable_accept_encoding_brotli = false
  }

  default_ttl = 0
  max_ttl     = 0
  min_ttl     = 0
}

resource "aws_cloudfront_origin_request_policy" "alb_origin_request_policy" {
  name = "alb-origin-request-policy"

  cookies_config {
    cookie_behavior = "all"
  }

  headers_config {
    header_behavior = "allViewer"
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_s3_bucket" "origin_s3" {
  bucket = var.domain_name

  tags = {
    Name = var.domain_name
  }
}

resource "aws_s3_bucket_public_access_block" "origin_s3_acl" {
  bucket = aws_s3_bucket.origin_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# OAC for CloudFront
resource "aws_s3_bucket_policy" "public_get_policy" {
  bucket = aws_s3_bucket.origin_s3.id
  policy = data.aws_iam_policy_document.public_get_policy.json
}

data "aws_iam_policy_document" "public_get_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.distribution.arn,
      ]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.origin_s3.arn}/*"]
  }
}

# s3 upload static web files
resource "null_resource" "upload_web_files" {
  provisioner "local-exec" {
    command = "aws s3 sync ./build/ s3://${aws_s3_bucket.origin_s3.bucket}"
  }

  depends_on = [aws_s3_bucket.origin_s3]
}

resource "null_resource" "delete_web_files" {
  triggers = {
    bucket_name = aws_s3_bucket.origin_s3.bucket
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.triggers.bucket_name} --recursive"
  }

  depends_on = [aws_s3_bucket.origin_s3]
}

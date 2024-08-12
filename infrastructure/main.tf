resource "aws_s3_bucket" "site" {
  bucket = "jeffcavejr-portfolio-site"
}

resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "jeffcavejr-portfolio-site.s3.us-east-1.amazonaws.com"
  description                       = "jeffcavejr-portfolio-site s3 bucket access control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "site" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "site" {
  aliases = ["jeffcavejr.com"]
  comment = "jeffcavejr.com portfolio"
  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.site.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
    origin_path              = "/prod"
    connection_attempts      = 3
    connection_timeout       = 10
  }

  enabled             = true
  price_class         = "PriceClass_100"
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site.bucket_regional_domain_name
    cache_policy_id  = data.aws_cloudfront_cache_policy.site.id
    compress         = true

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.site.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_acm_certificate" "site" {
  domain_name       = "*.jeffcavejr.com"
  validation_method = "DNS"
}

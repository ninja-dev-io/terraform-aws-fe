resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = local.distribution

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = var.cloudfront.enabled
  is_ipv6_enabled     = var.cloudfront.is_ipv6_enabled
  comment             = var.cloudfront.comment
  default_root_object = var.cloudfront.default_root_object

  logging_config {
    include_cookies = var.cloudfront.logging_config.include_cookies
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = var.cloudfront.logging_config.prefix
  }

  aliases = var.certificate_arn != null ? concat([local.distribution], var.cloudfront.aliases) : []

  dynamic "default_cache_behavior" {
    for_each = { for index, behavior in slice(var.cloudfront.ordered_cache_behavior, 0, 1) : tostring(index) => behavior if length(var.cloudfront.ordered_cache_behavior) > 0 }
    content {
      allowed_methods  = default_cache_behavior.value.allowed_methods
      cached_methods   = default_cache_behavior.value.cached_methods
      target_origin_id = local.distribution
      forwarded_values {
        query_string = default_cache_behavior.value.forwarded_values.query_string

        cookies {
          forward = default_cache_behavior.value.forwarded_values.cookies.forward
        }
      }

      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy
      min_ttl                = default_cache_behavior.value.min_ttl
      default_ttl            = default_cache_behavior.value.default_ttl
      max_ttl                = default_cache_behavior.value.max_ttl

    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = { for index, behavior in slice(var.cloudfront.ordered_cache_behavior, 1, length(var.cloudfront.ordered_cache_behavior)) : tostring(index) => behavior if length(var.cloudfront.ordered_cache_behavior) > 1 }
    content {
      path_pattern     = default_cache_behavior.value.path_pattern
      allowed_methods  = default_cache_behavior.value.allowed_methods
      cached_methods   = default_cache_behavior.value.cached_methods
      target_origin_id = local.origin_id
      forwarded_values {
        query_string = default_cache_behavior.value.forwarded_values.query_string

        cookies {
          forward = default_cache_behavior.value.forwarded_values.cookies.forward
        }
      }

      viewer_protocol_policy = default_cache_behavior.value.viewer_protocol_policy
      min_ttl                = default_cache_behavior.value.min_ttl
      default_ttl            = default_cache_behavior.value.default_ttl
      max_ttl                = default_cache_behavior.value.max_ttl

    }
  }

  price_class = var.cloudfront.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront.restrictions.geo_restriction.restriction_type
      locations        = var.cloudfront.restrictions.geo_restriction.locations
    }
  }

  tags = var.cloudfront.tags != null ? merge(var.cloudfront.tags, { Environment = "${var.env}" }) : { "Name" = local.distribution }

  viewer_certificate {
    cloudfront_default_certificate = var.certificate_arn == null
    acm_certificate_arn            = var.certificate_arn
    ssl_support_method             = var.cloudfront.viewer_certificate.ssl_support_method
    minimum_protocol_version       = var.cloudfront.viewer_certificate.minimum_protocol_version
  }

}

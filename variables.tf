variable "env" {
  type = string
}

variable "domain" {
  type = string
}

variable "certificate_arn" {
  description = "The certificate ARN for the provided domain."
  type        = string
  default     = null
}

variable "bucket" {
  type = object({
    acl           = string
    force_destroy = bool
    tags          = map(string)
    versioning    = bool
  })
}

variable "cloudfront" {
  type = object({
    enabled             = bool
    is_ipv6_enabled     = bool
    comment             = string
    default_root_object = string
    aliases             = list(string)
    price_class         = string
    tags                = map(string)
    logging_config = object({
      include_cookies = bool
      prefix          = string
    })
    ordered_cache_behavior = list(object({
      path_pattern    = string
      allowed_methods = list(string)
      cached_methods  = list(string)
      forwarded_values = object({
        query_string = bool
        headers      = list(string)
        cookies = object({
          forward = string
        })
      })
      viewer_protocol_policy = string
      min_ttl                = number
      default_ttl            = number
      max_ttl                = number
    }))
    restrictions = object({
      geo_restriction = object({
        restriction_type = string
        locations        = list(string)
      })
    })
    viewer_certificate = object({
      ssl_support_method       = string
      minimum_protocol_version = string
    })
  })
}

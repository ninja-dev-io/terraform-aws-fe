# terraform-aws-fe
frontend IaC

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.s3_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_identity.origin_access_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | n/a | <pre>object({<br>    acl           = string<br>    force_destroy = bool<br>    tags          = map(string)<br>    versioning    = bool<br>  })</pre> | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | The certificate ARN for the provided domain. | `string` | `null` | no |
| <a name="input_cloudfront"></a> [cloudfront](#input\_cloudfront) | n/a | <pre>object({<br>    enabled             = bool<br>    is_ipv6_enabled     = bool<br>    comment             = string<br>    default_root_object = string<br>    aliases             = list(string)<br>    price_class         = string<br>    tags                = map(string)<br>    logging_config = object({<br>      include_cookies = bool<br>      prefix          = string<br>    })<br>    ordered_cache_behavior = list(object({<br>      path_pattern    = string<br>      allowed_methods = list(string)<br>      cached_methods  = list(string)<br>      forwarded_values = object({<br>        query_string = bool<br>        headers      = list(string)<br>        cookies = object({<br>          forward = string<br>        })<br>      })<br>      viewer_protocol_policy = string<br>      min_ttl                = number<br>      default_ttl            = number<br>      max_ttl                = number<br>    }))<br>    restrictions = object({<br>      geo_restriction = object({<br>        restriction_type = string<br>        locations        = list(string)<br>      })<br>    })<br>    viewer_certificate = object({<br>      ssl_support_method       = string<br>      minimum_protocol_version = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
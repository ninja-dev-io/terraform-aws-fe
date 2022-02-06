locals {
  distribution = "${var.env}.${var.domain}"
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = local.distribution
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_s3_bucket" "bucket" {
  bucket        = local.distribution
  acl           = var.bucket.acl
  force_destroy = var.bucket.force_destroy
  tags          = var.bucket.tags != null ? merge(var.bucket.tags, { Environment = "${var.env}" }) : { "Name" = local.distribution }

  versioning {
    enabled = var.bucket.versioning
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "logs.${local.distribution}"
  acl    = "private"
}

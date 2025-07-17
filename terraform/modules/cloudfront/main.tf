data "aws_caller_identity" "self" {}

############
# CloudFront
############

resource "aws_cloudfront_distribution" "contents" {

  origin {
    domain_name              = var.contents_bucket
    origin_id                = var.contents_bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.contents.id
  }

  enabled         = true
  http_version    = "http2"
  is_ipv6_enabled = true
  comment         = var.comment

  aliases = ["${var.cloudfront_fqdn}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.contents_bucket

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "https-only"

    default_ttl = 0
    min_ttl     = 0
    max_ttl     = 0
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.identifiers
    content {
      path_pattern     = "/applications/${ordered_cache_behavior.key}/*"
      allowed_methods  = ["GET", "HEAD"]
      cached_methods   = ["GET", "HEAD"]
      target_origin_id = var.contents_bucket

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value != null ? [1] : []
        content {
          event_type   = "viewer-request"
          function_arn = data.aws_cloudfront_function.function[ordered_cache_behavior.key].arn
        }
      }

      forwarded_values {
        query_string = false

        cookies {
          forward = "none"
        }
      }
      min_ttl                = 0
      default_ttl            = 0
      max_ttl                = 0
      compress               = true
      viewer_protocol_policy = "redirect-to-https"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "contents" {
  name                              = var.name
  description                       = "${var.name}-policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "contents" {
  bucket = var.contents_bucket_id
  policy = <<EOT
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "${var.contents_bucket_arn}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudfront_distribution.contents.arn}"
                }
            }
        }
    ]
}
EOT
}

##################
# CloudfrontFunction
##################
locals {
  filtered_identifiers = { for k, v in var.identifiers : k => v if v != null }
}

resource "aws_cloudfront_function" "function" {
  for_each = local.filtered_identifiers

  name    = "basic_authentication_${each.key}"
  runtime = "cloudfront-js-1.0"
  comment = "basic authentication for ${each.key}"
  publish = true
  code    = templatefile("${path.module}/functions/basic_authentication_function.js.tpl", { auth_string = each.value })
}

data "aws_cloudfront_function" "function" {
  for_each = local.filtered_identifiers

  name  = "basic_authentication_${each.key}"
  stage = "LIVE"
}

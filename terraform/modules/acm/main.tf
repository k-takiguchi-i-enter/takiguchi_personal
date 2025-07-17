############
# ACM
############

terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.0"
      configuration_aliases = [aws.virginia]
    }
  }
}

############
### CloudFront
############

resource "aws_acm_certificate" "cloudfront_acm" {
  domain_name               = var.cloudfront_fqdn
  validation_method         = "DNS"
  provider                  = aws.virginia
}

# 以下はsystemadminでは適用しない（route53がroadworkerで別管理されているため）

# resource "aws_route53_record" "cloudfront_acm_validation_record" {
#   for_each = {
#     for dvo in aws_acm_certificate.cloudfront_acm.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = "Z0540715JEJJA3YX1VCG"
# }

# resource "aws_acm_certificate_validation" "cloudfront_acm_cv" {
#   provider                = aws.virginia
#   certificate_arn         = aws_acm_certificate.cloudfront_acm.arn
#   validation_record_fqdns = [for record in aws_route53_record.cloudfront_acm_validation_record : record.fqdn]
# }

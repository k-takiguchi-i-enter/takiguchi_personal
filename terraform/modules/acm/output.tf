output "cloudfront_acm_certificate_arn" {
  value       = aws_acm_certificate.cloudfront_acm.arn
  description = "The arn of the certificate."
}

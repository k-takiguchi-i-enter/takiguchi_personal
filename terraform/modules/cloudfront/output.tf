output "distribution_id" {
  value       = aws_cloudfront_distribution.contents.id
  description = "ID of CloudFront Distribution"
}

output "distribution_arn" {
  value       = aws_cloudfront_distribution.contents.arn
  description = "ARN of CloudFront Distribution"
}

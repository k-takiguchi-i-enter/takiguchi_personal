output "contents_bucket" {
  value       = aws_s3_bucket.contents.bucket_domain_name
  description = "The Bucket Domain Name of S3"
}

output "contents_bucket_id" {
  value       = aws_s3_bucket.contents.id
  description = "The ID of S3"
}

output "contents_bucket_arn" {
  value       = aws_s3_bucket.contents.arn
  description = "The ARN of S3"
}


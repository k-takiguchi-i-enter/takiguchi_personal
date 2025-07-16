variable "name" {
  type        = string
  description = "The module name"
}

variable "comment" {
  type        = string
  description = "The comment of CloudFront Distribution"
}

variable "cloudfront_fqdn" {
  type        = string
  description = "The FQDN of CloudFront admin"
}

variable "cloudfront_acm_certificate_arn" {
  type        = string
  description = "The arn of the certificate."
}

variable "contents_bucket" {
  type        = string
  description = "The Bucket Domain Name of S3"
}

variable "contents_bucket_id" {
  type        = string
  description = "The ID of S3"
}

variable "contents_bucket_arn" {
  type        = string
  description = "The ARN of S3"
}

variable "identifiers" {
  description = "Map of identifiers and auth strings"
  type        = map(string)
}

variable "name" {
  type        = string
  description = "The module Name"
}

variable "contents_bucket_arn" {
  type        = string
  description = "The ARN of S3"
}

variable "terraform_backend_bucket_arn" {
  type        = string
  description = "The ARN of the Terraform backend bucket"
}

variable "distribution_id" {
  type        = string
  description = "ID of CloudFront Distribution"
}

variable "distribution_arn" {
  type        = string
  description = "ARN of CloudFront Distribution"
}

variable "provider_domain_name" {
  type        = string
  description = "The domain name of provider"
}

variable "provider_project_path" {
  type        = string
  description = "The path of the project in provider"
}

variable "provider_branch_name" {
  type        = string
  description = "The name of the branch in provider"
}


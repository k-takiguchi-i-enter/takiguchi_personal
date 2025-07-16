variable "env" {
  type        = string
  description = "Current state of project: stage, prod"
}

variable "project" {
  type        = string
  description = "The Project prefix."
}

variable "az_cnt" {
  type        = number
  description = "Number of AZs to cover"
  default     = 2
}

variable "comment" {
  type        = string
  description = "The comment of CloudFront Distribution"
}

variable "cloudfront_fqdn" {
  type        = string
  description = "cloudfront_fqdn"
}

variable "identifiers" {
  description = "Map of identifiers and auth strings"
  type        = map(string)
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

variable "terraform_backend_bucket_arn" {
  type        = string
  description = "The ARN of the Terraform backend bucket"
}

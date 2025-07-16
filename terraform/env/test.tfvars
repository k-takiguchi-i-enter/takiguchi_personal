project = "dev-storage"
env     = "test"

# CloudFront
comment = "prod"
### basic認証を付与したい時"true"、外したい時"false"
cloudfront_fqdn = "dev-storage.takumi-sre.com"

identifiers = {
  "Nonstress"       = "Tm9uU3RyZXNzOk5HOXlUdEho",
  "tohmatsu-as-uat" = "dG9obWF0c3Vhc3VhdDphc3VhdDIwMjE="
}

# IAM
provider_domain_name         = "git.shibuyalabo.com"
provider_project_path        = "*"
provider_branch_name         = "*"
terraform_backend_bucket_arn = "arn:aws:s3:::shimoyama-dev-storage-test-bucket"

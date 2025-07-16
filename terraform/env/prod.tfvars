project = "dev-storage"
env     = "prod"

# CloudFront
comment = "prod"
### basic認証を付与したい時"true"、外したい時"false"
cloudfront_fqdn = "dev-storage.shibuyalabo.com"

identifiers = {
  "Nonstress"             = "Tm9uU3RyZXNzOk5HOXlUdEho",
  "datakit-tester"        = "dWNoaW5ldG1vYmlsZTpWZm43RWlXZHZ3OFF0QQ=="
  "prime-assistance-test" = "ZGZndmhqYms6eGRjZmd2aGpia25s"
  "r1"                    = "cjE6cjE="
  "recognitions"          = "cmVjb2duaXRpb25zOnJlY29nbml0aW9ucw=="
  "tohmatsu"              = "dG9obWF0c3U6cnNzM2tX"
  "tohmatsu-as"           = "dG9obWF0c3VhczphczIwMjE="
  "tohmatsu-test"         = null
  "tohmatsu-as-uat"       = "dG9obWF0c3Vhc3VhdDphc3VhdDIwMjE="
  "YarukiSwitch"          = "eXNnOmVNM0JTZkF1"
  "YSG"                   = "eXNnOmVNM0JTZkF1"
}

# IAM
provider_domain_name         = "git.shibuyalabo.com"
provider_project_path        = "smart-device-solution/all/dev-storage-infra"
provider_branch_name         = "*"
terraform_backend_bucket_arn = "arn:aws:s3:::s3-dev-storage-terraform"

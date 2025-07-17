###########
# Provider
###########
terraform {
  required_version = ">= 1.3.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  backend "s3" {}
}


provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      ManagedBy = "terraform"
    }
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"

  default_tags {
    tags = {
      ManagedBy = "terraform"
    }
  }
}

##################
# Local Variables
##################
locals {
  name = "${var.project}-${var.env}"
}

#######
# S3
#######
module "s3" {
  source = "./modules/s3"

  name = local.name
}

##############
# ACM
##############
module "acm" {
  source = "./modules/acm"

  name            = local.name
  cloudfront_fqdn = var.cloudfront_fqdn
  providers = {
    aws          = aws
    aws.virginia = aws.virginia
  }
}


##############
# CloudFront
##############
module "cloudfront" {
  source = "./modules/cloudfront"

  name                           = local.name
  comment                        = var.comment
  cloudfront_acm_certificate_arn = module.acm.cloudfront_acm_certificate_arn
  cloudfront_fqdn                = var.cloudfront_fqdn
  identifiers                    = var.identifiers
  contents_bucket                = module.s3.contents_bucket
  contents_bucket_id             = module.s3.contents_bucket_id
  contents_bucket_arn            = module.s3.contents_bucket_arn

  depends_on = [module.s3]
}

#######
# IAM
#######
module "iam" {
  source = "./modules/iam"

  name                         = local.name
  contents_bucket_arn          = module.s3.contents_bucket_arn
  terraform_backend_bucket_arn = var.terraform_backend_bucket_arn
  distribution_id              = module.cloudfront.distribution_id
  distribution_arn             = module.cloudfront.distribution_arn
  provider_domain_name         = var.provider_domain_name
  provider_project_path        = var.provider_project_path
  provider_branch_name         = var.provider_branch_name
}

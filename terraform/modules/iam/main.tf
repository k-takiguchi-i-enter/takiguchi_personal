data "aws_caller_identity" "current" {}

############
# IAM
############

#############
# IAM Role for Provider
#############
resource "aws_iam_role" "provider" {
  name = "${var.name}-oidc-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = "provider"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.provider_domain_name}"
        }
        Condition = {
          StringLike = {
            "${var.provider_domain_name}:sub" = "project_path:${var.provider_project_path}:ref_type:branch:ref:${var.provider_branch_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "provider" {
  name = "${var.name}-oidc-role-policy"
  role = aws_iam_role.provider.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "cloudfront",
        "Effect" : "Allow",
        "Action" : [
          "cloudfront:GetDistribution",
          "cloudfront:List*",
          "cloudfront:UpdateDistribution",
          "cloudfront:GetFunction",
          "cloudfront:UpdateFunction",
          "cloudfront:CreateFunction",
          "cloudfront:DeleteFunction",
          "cloudfront:DescribeFunction",
          "cloudfront:PublishFunction",
          "cloudfront:GetOriginAccessControl",
          "cloudfront:CreateFunction",
          "cloudfront:DeleteFunction"
        ]
        "Resource" : [
          "${var.distribution_arn}",
          "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:function/*",
          "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:origin-access-control/*"
        ]
      },
      {
        "Sid" : "s3",
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*",
          "s3:Put*",
          "s3:Delete*",
        ],
        "Resource" : [
          "${var.contents_bucket_arn}",
          "${var.contents_bucket_arn}/*"
        ]
      },
      {
        "Sid" : "terraform",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "${var.terraform_backend_bucket_arn}",
          "${var.terraform_backend_bucket_arn}/*"
        ]
      },
      {
        "Sid" : "iam",
        "Effect" : "Allow",
        "Action" : [
          "iam:Get*",
          "iam:List*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "acm",
        "Effect" : "Allow",
        "Action" : [
          "acm:Describe*",
          "acm:Get*",
          "acm:List*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "route53",
        "Effect" : "Allow",
        "Action" : [
          "route53:Get*",
          "route53:List*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

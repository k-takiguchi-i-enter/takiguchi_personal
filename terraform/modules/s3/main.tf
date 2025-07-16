data "aws_caller_identity" "self" {}

##################
# S3
##################

##################
### Contents Bucket
##################

resource "aws_s3_bucket" "contents" {
  bucket = "${var.name}-contents"
}

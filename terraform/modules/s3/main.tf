resource "aws_s3_bucket" "hosting_bucket" {
  bucket = "${var.common.app_name}-${var.common.env}-hosting"
}

resource "aws_s3_bucket_acl" "hosting_acl" {
  bucket = aws_s3_bucket.hosting_bucket.id
  acl    = "private"
}

resource "aws_cloudfront_origin_access_identity" "hosting" {
}

resource "aws_s3_bucket_public_access_block" "hosting_access_block" {
  bucket                  = aws_s3_bucket.hosting_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "hosting_policy_document" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.hosting.iam_arn]
    }
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.hosting_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "hosting_policy" {
  bucket = aws_s3_bucket.hosting_bucket.id
  policy = data.aws_iam_policy_document.hosting_policy_document.json
}

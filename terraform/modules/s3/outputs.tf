output "hosting_bucket" {
  value = {
    id                          = aws_s3_bucket.hosting_bucket.id
    bucket_regional_domain_name = aws_s3_bucket.hosting_bucket.bucket_regional_domain_name
  }
}

output "origin_access_identity" {
  value = {
    path = aws_cloudfront_origin_access_identity.hosting.cloudfront_access_identity_path
  }
}

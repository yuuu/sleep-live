resource "aws_cloudfront_distribution" "hosting" {
  enabled = true

  web_acl_id = var.acl.id

  origin {
    domain_name = var.hosting_bucket.bucket_regional_domain_name
    origin_id   = var.hosting_bucket.id
    s3_origin_config {
      origin_access_identity = var.origin_access_identity.path
    }
  }

  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.hosting_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 60
    max_ttl                = 600
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "hosting_dst" {
  value = {
    domain_name = aws_cloudfront_distribution.hosting.domain_name
  }
}
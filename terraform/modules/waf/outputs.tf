output "acl" {
  value = {
    id = aws_waf_web_acl.hosting_acl.id
  }
}

resource "aws_waf_ipset" "hosting_ipset" {
  name = "${var.common.app_name}-${var.common.env}-hosting-ipset"

  ip_set_descriptors {
    type  = "IPV4"
    value = var.allow_ip
  }
}

resource "aws_waf_rule" "hosting_rule" {
  name        = "${var.common.app_name}-${var.common.env}-hosting-rule"
  metric_name = "hostingRule"

  predicates {
    data_id = aws_waf_ipset.hosting_ipset.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "hosting_acl" {
  name        = "${var.common.app_name}-${var.common.env}-hosting-acl"
  metric_name = "hostingAcl"

  default_action {
    type = "BLOCK"
  }

  rules {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_waf_rule.hosting_rule.id
    type     = "REGULAR"
  }
}
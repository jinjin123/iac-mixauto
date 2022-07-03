variable "domain_name" {
  type    = string
  default = "value"
}

variable "aws_lb_depends_on" {
  type    = string
  default = "value"
}

locals {
  environment = terraform.workspace
}


resource "aws_route53_zone" "primary" {
  name = "${locals.environment}-${var.domain_name}"
  tags = {
    Environment = locals.environment
  }
}
/*  can multiable  dns table*/
resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = aws_route53_zone.primary.name
  type    = "A"
  ttl     = "300"
  records = [var.aws_lb_depends_on]
  /* alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  } */
}

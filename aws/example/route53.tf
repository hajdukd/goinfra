resource "aws_route53_zone" "zone" {
  name = local.domain_name
}

resource "aws_route53_record" "goapi" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "something.${local.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}
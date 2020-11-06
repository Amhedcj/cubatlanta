
# resource "aws_route53_delegation_set" "delegation_set"{
#   lifecycle {
#     prevent_destroy = true # IF DELETED will need to reconfigure NS records on domain provider. 
#   }
# }

# resource "aws_route53_zone" "primary" {
#   name = var.domain_name
#   delegation_set_id = aws_route53_delegation_set.delegation_set.id
# }

# resource "aws_route53_record" "domain" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name                   = aws_s3_bucket.domain_bucket.website_domain
#     zone_id                = aws_s3_bucket.domain_bucket.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "sub_domain" {
#   zone_id = aws_route53_zone.primary.zone_id
#   name    = "www."
#   type    = "A"

#   alias {
#     name                   = aws_s3_bucket.www_subdomain_bucket.website_domain
#     zone_id                = aws_s3_bucket.www_subdomain_bucket.hosted_zone_id
#     evaluate_target_health = false
#   }
# }


output "hosted_zone_id" {
  description = "ID of the route 53 private hosted zone"
  value       = aws_route53_zone.private.zone_id
}

output "app_record_name" {
  description = "DNS name of the application record"
  value       = aws_route53_record.app.fqdn
}
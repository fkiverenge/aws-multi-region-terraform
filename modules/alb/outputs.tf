
output "target_group_arn" {
  description = "ARN of the alb target group"
  value       = aws_lb_target_group.app-tg.arn
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app-lb.dns_name
}

output "alb_zone_id" {
  description = "Canonical hosted zone id of the ALB"
  value       = aws_lb.app-lb.zone_id
}
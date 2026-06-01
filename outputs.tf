output "alb_dns_name" {
  description = "Public DNS name of the Application Load Balancer. Use this to send requests to the API."
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer."
  value       = aws_lb.main.arn
}

output "target_group_arn" {
  description = "ARN of the target group that the ALB listener forwards traffic to."
  value       = aws_lb_target_group.api.arn
}

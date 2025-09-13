#===========================================
# terraform/outputs.tf
#===========================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "cloudfront_domain_name" {
  description = "Domain name of CloudFront distribution"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.database.rds_endpoint
}

output "redis_endpoint" {
  description = "Redis cluster endpoint"
  value       = module.cache.redis_endpoint
}

output "application_url" {
  description = "Application URL through CloudFront"
  value       = "https://${aws_cloudfront_distribution.main.domain_name}"
}


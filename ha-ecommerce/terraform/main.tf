# terraform/main.tf
terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "ha-ecommerce/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "HA-Ecommerce"
      Environment = var.environment
      Owner       = "Benny"
      Terraform   = "true"
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-vpc"
  })
}

# Security Module
module "security" {
  source = "./modules/security"
  
  vpc_id = module.vpc.vpc_id
  
  tags = var.common_tags
}

# Database Module
module "database" {
  source = "./modules/database"
  
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  database_security_group_id = module.security.database_sg_id
  
  db_instance_class     = var.db_instance_class
  db_allocated_storage  = var.db_allocated_storage
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  
  tags = var.common_tags
}

# Cache Module
module "cache" {
  source = "./modules/cache"
  
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  cache_security_group_id = module.security.cache_sg_id
  
  node_type            = var.cache_node_type
  num_cache_nodes      = var.cache_num_nodes
  
  tags = var.common_tags
}

# Compute Module
module "compute" {
  source = "./modules/compute"
  
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  alb_security_group_id = module.security.alb_sg_id
  web_security_group_id = module.security.web_sg_id
  
  ami_id              = data.aws_ami.amazon_linux.id
  instance_type       = var.instance_type
  key_pair_name       = var.key_pair_name
  
  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  
  db_endpoint         = module.database.rds_endpoint
  cache_endpoint      = module.cache.redis_endpoint
  
  tags = var.common_tags
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = module.compute.alb_dns_name
    origin_id   = "ALB-${var.project_name}"
    
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  
  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "ALB-${var.project_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = false
      headers      = ["Host"]
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }
  
  # Cache behavior for static assets
  ordered_cache_behavior {
    path_pattern           = "/static/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "ALB-${var.project_name}"
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    
    forwarded_values {
      query_string = false
      
      cookies {
        forward = "none"
      }
    }
    
    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }
  
  price_class = "PriceClass_100"
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  
  tags = merge(var.common_tags, {
    Name = "${var.project_name}-cloudfront"
  })
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"
  
  project_name        = var.project_name
  alb_arn_suffix      = module.compute.alb_arn_suffix
  target_group_arn_suffix = module.compute.target_group_arn_suffix
  asg_name           = module.compute.asg_name
  rds_identifier     = module.database.rds_identifier
  
  notification_email = var.notification_email
  
  tags = var.common_tags
}

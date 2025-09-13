#===========================================
# terraform/modules/vpc/variables.tf
#===========================================

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"  
  type        = list(string)
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "ha-ecommerce"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

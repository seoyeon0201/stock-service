# Region, VPC
variable "region" {
  default     = "ap-northeast-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to deploy resources in"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2d"]
}

# AWS Credentials
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

# AWS RDS
variable "db_username" {
  description = "Username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}
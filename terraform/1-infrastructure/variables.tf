variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
}

variable "state_bucket_region" {
  default     = "us-east-1"
  description = "Terraform AWS Remote State S3 Bucket Region"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
}

variable "public_subnet_1_cidr" {
  description = "CIDR Block for Public Subnet 1"
}

variable "public_subnet_2_cidr" {
  description = "CIDR Block for Public Subnet 2"
}

variable "public_subnet_3_cidr" {
  description = "CIDR Block for Public Subnet 3"
}

variable "private_subnet_1_cidr" {
  description = "CIDR Block for Private Subnet 1"
}

variable "private_subnet_2_cidr" {
  description = "CIDR Block for Private Subnet 2"
}

variable "private_subnet_3_cidr" {
  description = "CIDR Block for Private Subnet 3"
}

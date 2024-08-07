# variables.tf
variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
  default     = "ami-04a81a99f5ec58529"  # Replace with a suitable AMI for your region
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t2.micro"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password123"
}

variable "frontend_desired_capacity" {
  description = "Desired number of frontend instances"
  type        = number
  default     = 2
}

variable "backend_desired_capacity" {
  description = "Desired number of backend instances"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
  default     = "key.pem"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}
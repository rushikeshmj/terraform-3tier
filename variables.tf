# variables.tf
variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Replace with a suitable AMI for your region
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

# main.tf

provider "aws" {
  region = "us-east-1"
}

# Security group for frontend
resource "aws_security_group" "frontend_sg" {
  name = "frontend-sg"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for backend
resource "aws_security_group" "backend_sg" {
  name = "backend-sg"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch Configuration for frontend
resource "aws_launch_configuration" "frontend_lc" {
  name          = "frontend-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.frontend_sg.id]
  key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for frontend
resource "aws_autoscaling_group" "frontend_asg" {
  launch_configuration = aws_launch_configuration.frontend_lc.id
  min_size             = 1
  max_size             = var.frontend_desired_capacity
  desired_capacity     = var.frontend_desired_capacity
  vpc_zone_identifier  = "[var.public_subnet_id]"

  tag {
    key                 = "Name"
    value               = "frontend-instance"
    propagate_at_launch = true
  }
}

# Launch Configuration for backend
resource "aws_launch_configuration" "backend_lc" {
  name          = "backend-lc"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.backend_sg.id]
  key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for backend
resource "aws_autoscaling_group" "backend_asg" {
  launch_configuration = aws_launch_configuration.backend_lc.id
  min_size             = 1
  max_size             = var.backend_desired_capacity
  desired_capacity     = var.backend_desired_capacity
  vpc_zone_identifier  = "[var.private_subnet_id]"

  tag {
    key                 = "Name"
    value               = "backend-instance"
    propagate_at_launch = true
  }
}

# RDS Database Instance
resource "aws_db_instance" "db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  db_name              = "mydb"
  username             = "var.db_username"
  password             = "var.db_password"
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = "[var.private_subnet_id]"
}

# Load Balancer
resource "aws_alb" "frontend_alb" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.frontend_sg.id]
  subnets            = "[var.public_subnet_id]"
}

# Target Group for frontend
resource "aws_alb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "var.vpc_id"
}

# ALB Listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.frontend_tg.arn
  }
}

# Auto Scaling Attachment
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
  lb_target_group_arn    = aws_alb_target_group.frontend_tg.arn
}

output "frontend_asg_instance_ids" {
  value = aws_autoscaling_group.frontend_asg.instances[*].instance_id
}

output "frontend_load_balancer_dns" {
  value = aws_alb.frontend_alb.dns_name
}

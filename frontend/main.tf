provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the frontend instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the frontend instances"
  type        = string
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
}

variable "frontend_desired_capacity" {
  description = "Desired number of frontend instances"
  type        = number
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

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

resource "aws_launch_configuration" "frontend_lc" {
  name                  = "frontend-lc"
  image_id              = var.ami_id
  instance_type         = var.instance_type
  security_groups       = [aws_security_group.frontend_sg.id]
  key_name              = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "frontend_asg" {
  launch_configuration = aws_launch_configuration.frontend_lc.id
  min_size             = 1
  max_size             = var.frontend_desired_capacity
  desired_capacity     = var.frontend_desired_capacity
  vpc_zone_identifier  = [var.public_subnet_id]

  tag {
    key                 = "Name"
    value               = "frontend-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
}

resource "aws_alb" "frontend_alb" {
  name                    = "frontend-alb"
  internal                = false
  load_balancer_type      = "application"
  security_groups         = [aws_security_group.frontend_sg.id]
  subnets                 = [var.public_subnet_id]

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.frontend_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
      target_group_arn = aws_alb_target_group.frontend_tg.arn
  }
}

data "aws_vpc" "default" {
  default = true
}

# If target_group_arns is causing issues, use aws_autoscaling_attachment for the ASG
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
  lb_target_group_arn   = aws_alb_target_group.frontend_tg.arn
}

output "instance_ids" {
  value = aws_autoscaling_group.frontend_asg.instances[*].instance_id
}

output "load_balancer_dns" {
  value = aws_alb.frontend_alb.dns_name
}

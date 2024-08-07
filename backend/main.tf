# backend/main.tf
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

resource "aws_launch_configuration" "backend_lc" {
  name          = "backend-lc"
  image_id      = "var.ami_id"
  instance_type = "var.instance_type"
  security_groups = [aws_security_group.backend_sg.id]
  key_name = "var.key_name"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend_asg" {
  launch_configuration = aws_launch_configuration.backend_lc.id
  min_size             = 1
  max_size             = "var.backend_desired_capacity"
  desired_capacity     = "var.backend_desired_capacity"
  vpc_zone_identifier  = "[var.private_subnet_id]"

  tag {
    key                 = "Name"
    value               = "backend-instance"
    propagate_at_launch = true
  }
}

output "instance_ids" {
  value = aws_autoscaling_group.backend_asg.instances[*].instance_id
}

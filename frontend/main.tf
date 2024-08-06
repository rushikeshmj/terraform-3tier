# frontend/main.tf
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

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.frontend_sg.name]

  tags = {
    Name = "frontend-instance"
  }
}

output "instance_id" {
  value = aws_instance.frontend.id
}

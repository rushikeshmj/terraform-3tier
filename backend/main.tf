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

resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.backend_sg.name]

  tags = {
    Name = "backend-instance"
  }
}

output "instance_id" {
  value = aws_instance.backend.id
}

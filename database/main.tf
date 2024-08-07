# database/main.tf
resource "aws_security_group" "database_sg" {
  name = "database-sg"
  
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "example" {
  identifier        = "example-db"
  engine            = "postgres"
  instance_class    = "db.t2.micro"
  db_name           = "exampledb"
  username          = "var.db_username"
  password          = "var.db_password"
  allocated_storage = 20

  vpc_security_group_ids = [aws_security_group.database_sg.id]
}

output "endpoint" {
  value = aws_db_instance.example.endpoint
}

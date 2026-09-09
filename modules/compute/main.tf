########################################
# Security Group
########################################
resource "aws_security_group" "web_sg" {
  lifecycle {
    ignore_changes = [description, tags, tags_all]
  }
  name        = "web-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "web-sg"
  }
}

########################################
# EC2 Instance (Web App)
########################################
resource "aws_instance" "web" {
  ami                    = "ami-0ccabb5f82d4c9af5"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Terraform!" > index.html
              python3 -m http.server 80 &
              EOF

  tags = {
    Name = "web-server"
  }
}

resource "aws_security_group" "rule" {
  name        = "EC2_BASE_GROUP"
  description = "aws_security"

  ingress {
    description = "ICMP ssh protocol"
    from_port   = 22
    to_port     = 22
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
    Name = "EC2_BASE_GROUP"
  }
}
output "aws_security"{
    value = aws_security_group.rule.id
}
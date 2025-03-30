/*
This allows access to the PostgreSQL port (5432) from anywhere (0.0.0.0/0). You should limit access to specific IPs or security groups in production.

 */
# Security group for RDS PostgreSQL access
resource "aws_security_group" "rds_sg" {
  name        = "rds-postgresql-sg"
  description = "Security group for RDS PostgreSQL access"
  vpc_id      = aws_vpc.main.id # Use the existing VPC from your `vpc.tf`

  ingress {
    from_port   = 5432 # PostgreSQL default port
    to_port     = 5432 # PostgreSQL default port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all IPs (change this for more secure access)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow outbound traffic
  }

  tags = {
    Name = "rds-postgresql-sg"
  }
}

/*
This allows access to the PostgreSQL port (5432) from anywhere (0.0.0.0/0). You should limit access to specific IPs or security groups in production.

 */
# Security group for RDS PostgreSQL access
resource "aws_security_group" "rds_sg" {
  name        = "rds-postgresql-sg"
  description = "Security group for RDS PostgreSQL access"
  vpc_id      = local.vpc_id # Use the existing VPC from your `vpc.tf`

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


resource "aws_security_group_rule" "rds-ingress-node" {
  count                    = 1
  description              = "Allow pods to communicate with the database"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = module.eks.node_security_group_id
}
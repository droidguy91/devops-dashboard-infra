# db-subnet-group.tf

# DB Subnet Group for RDS
resource "aws_db_subnet_group" "subnet_group" {
  name        = "devops-dashboard-subnet-group"
  description = "Subnet group for RDS PostgreSQL instance"
  subnet_ids  = [aws_subnet.subnet_public.id, aws_subnet.subnet_private.id] # Add appropriate subnets

  tags = {
    Name = "devops-dashboard-db-subnet-group"
  }
}

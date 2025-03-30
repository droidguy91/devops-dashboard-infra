# db.tf

resource "aws_db_subnet_group" "devops-dashboard-db-subnet-group" {

  name        = "devops_dashboard-db"
  subnet_ids  = local.subnets
  description = "Subnet group for RDS PostgreSQL instance"

  tags = {
    Name = "devops-dashboard-db-subnet-group"
  }
}

resource "aws_security_group" "devops-dashboard-db-security-group" {

  name        = "devops_dashboard-db"
  description = "EKS cluster communication with database"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-postgresql-sg"
  }
}

resource "aws_security_group_rule" "devops-dashboard-db-ingress-node" {

  description              = "Allow pods to communicate with the database"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.devops-dashboard-db-security-group.id
  source_security_group_id = module.eks.node_security_group_id
}


# RDS PostgreSQL instance
resource "aws_db_instance" "devops-dashboard-db" {
  allocated_storage         = 20                                                         # Size of the storage in GB
  storage_type              = "gp2"                                                      # General purpose SSD storage
  instance_class            = "db.t3.micro"                                              # Instance type (can be changed based on your requirements)
  engine                    = "postgres"                                                 # Database engine
  engine_version            = "17.2"                                                     # Version of PostgreSQL (adjust if needed)
  db_name                   = "devops_dashboard"                                         # Name of the database to create
  username                  = "postgres"                                                 # Master username for the database
  password                  = "your_secure_password"                                     # Master password (use secrets management in production)
  db_subnet_group_name      = aws_db_subnet_group.devops-dashboard-db-subnet-group.name  # Subnet group to place the RDS in
  vpc_security_group_ids    = [aws_security_group.devops-dashboard-db-security-group.id] # Security group to allow inbound connections
  multi_az                  = false                                                      # Set to true for high availability
  publicly_accessible       = true                                                       # Set to false if you don’t want the database to be publicly accessible
  backup_retention_period   = 7                                                          # Number of days to retain backups
  final_snapshot_identifier = "devops-dashboard-final-snapshot"                          # Snapshot before deleting (optional)

  tags = {
    Name = "devops-dashboard-db"
  }
}

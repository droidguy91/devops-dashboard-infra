# rds-instance.tf

# RDS PostgreSQL instance
resource "aws_db_instance" "postgresql" {
  allocated_storage         = 20                                    # Size of the storage in GB
  storage_type              = "gp2"                                 # General purpose SSD storage
  instance_class            = "db.t3.micro"                         # Instance type (can be changed based on your requirements)
  engine                    = "postgres"                            # Database engine
  engine_version            = "13.3"                                # Version of PostgreSQL (adjust if needed)
  db_name                   = "devops_dashboard"                    # Name of the database to create
  username                  = "admin"                               # Master username for the database
  password                  = "your_secure_password"                # Master password (use secrets management in production)
  db_subnet_group_name      = aws_db_subnet_group.subnet_group.name # Subnet group to place the RDS in
  vpc_security_group_ids    = [aws_security_group.rds_sg.id]        # Security group to allow inbound connections
  multi_az                  = false                                 # Set to true for high availability
  publicly_accessible       = true                                  # Set to false if you don’t want the database to be publicly accessible
  backup_retention_period   = 7                                     # Number of days to retain backups
  final_snapshot_identifier = "devops-dashboard-final-snapshot"     # Snapshot before deleting (optional)

  tags = {
    Name = "devops-dashboard-db"
  }

  # Optionally, enable enhanced monitoring
  monitoring_interval = 60 # Enable monitoring with a 1-minute interval
}

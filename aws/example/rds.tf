resource "aws_kms_key" "rds" {
  description             = "KMS key used to encrypt RDS database"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "rds" {
  name          = "alias/rds/db"
  target_key_id = aws_kms_key.rds.key_id
}

resource "aws_db_instance" "rds" {
  allocated_storage      = 20
  max_allocated_storage  = 100
  engine                 = "postgres"
  engine_version         = "13.4"
  instance_class         = "db.t3.micro"
  db_name                = "goapi"
  username               = "goapi"
  password               = "goapi"
  parameter_group_name   = "default.postgres13"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  skip_final_snapshot    = true
  deletion_protection    = false
  multi_az               = false
  storage_encrypted      = true
  kms_key_id             = aws_kms_key.rds.arn

  backup_retention_period = 7

  tags = {
    Name = "MyRDSInstance"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds_subnet_group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "Allow traffic to RDS"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
    description = "Allow VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
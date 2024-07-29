# RDS
resource "aws_db_instance" "default" {
  identifier        = "rds-${var.vpc_name}"
  engine            = "mariadb"
  engine_version    = "10.11.6"
  instance_class    = "db.t4g.small"
  storage_type      = "gp3"
  allocated_storage = 40

  username = var.root_username
  password = var.root_password
  db_name  = var.init_db_name

  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  multi_az               = true

  parameter_group_name         = "default.mariadb10.11"
  skip_final_snapshot          = true
  performance_insights_enabled = false
  storage_encrypted            = false
  delete_automated_backups     = true
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group-${var.vpc_name}"
  subnet_ids = var.db_subnet

  tags = {
    Name = "rds-subnet-group-${var.vpc_name}"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-${var.vpc_name}"
  description = "rds sg for ${var.vpc_name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.additional_ingress
    content {
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      security_groups = ingress.value["security_groups"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outbound"
  }

  tags = {
    Name = "rds-sg-${var.vpc_name}"
  }
}

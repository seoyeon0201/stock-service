resource "aws_security_group" "rds_sg" {
  vpc_id = module.vpc.vpc_id
  name   = "sy-rds-sg"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { name = "sy-rds-sg"}
}

resource "aws_db_instance" "rds" {
  identifier             = "sy-rds"
  allocated_storage      = 100
  storage_type           = "gp2"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.medium"
  username              = var.db_username
  password              = var.db_password
  db_subnet_group_name  = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible   = false
  skip_final_snapshot   = true

  tags = { name = "sy-rds"}
}

resource "aws_subnet" "rds_private_subnet" {
  count             = length(var.availability_zones)
  vpc_id           = module.vpc.vpc_id
  cidr_block       = cidrsubnet(var.vpc_cidr, 8, count.index + 10)  # EKS 서브넷과 겹치지 않도록 설정
  availability_zone = var.availability_zones[count.index]

  tags = { Name = "rds-private-subnet-${count.index}" }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.rds_private_subnet[*].id

  tags = { Name = "rds-subnet-group" }
}
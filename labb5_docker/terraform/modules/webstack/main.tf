# ============================================
# LOKALA VÄRDEN
# ============================================

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  aws_region = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

# ============================================
# DATA SOURCES
# ============================================

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# ============================================
# IAM ROLL FÖR EC2 (ECR-åtkomst)
# ============================================

resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-role"
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-ec2-profile"
  })
}

# ============================================
# SECURITY GROUPS
# ============================================

resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-web-sg"
  description = "Allow SSH and HTTP for ${var.project_name}"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-web-sg"
  })
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow MySQL from web-sg only for ${var.project_name}"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from web-sg"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-db-sg"
  })
}

# ============================================
# SSH KEY PAIR
# ============================================

resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = file(var.public_key_path)

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-key"
  })
}

# ============================================
# EC2 INSTANS (kör Docker)
# ============================================

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Installera Docker
              dnf update -y
              dnf install -y docker
              systemctl start docker
              systemctl enable docker

              # Logga in mot ECR
              aws ecr get-login-password --region ${local.aws_region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${local.aws_region}.amazonaws.com

              # Starta containern
              docker run -d \
                --name webapp \
                --restart always \
                -p 80:${var.container_port} \
                -e APP_VERSION=${var.app_version} \
                -e ENVIRONMENT=${var.environment} \
                ${var.container_image}
              EOF

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-web"
  })
}

# ============================================
# RDS MYSQL
# ============================================

resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp2"
  db_name                = replace(var.project_name, "-", "")
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  deletion_protection    = false

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-db"
  })
}
# ============================================
# NETWORK MODULE – skapar VPC och subnät
# ============================================

module "network" {
  source = "../../modules/network"

  project_name = "labb4-dev"
  environment  = "dev"
}

# ============================================
# WEBSTACK MODULE – skapar EC2 + RDS
# ============================================

module "webstack" {
  source = "../../modules/webstack"

  # Identitet
  project_name = "labb4-dev"
  environment  = "dev"

  # Nätverket – outputs från network-modulen blir inputs här
  vpc_id               = module.network.vpc_id
  public_subnet_id     = module.network.public_subnet_ids[0]
  db_subnet_group_name = module.network.db_subnet_group_name

  # Storlekar
  instance_type        = "t3.micro"
  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 20

  # Databas
  db_username = "admin"
  db_password = var.db_password

  # SSH
  public_key_path  = "../../keys/dev-key.pub"
  allowed_ssh_cidr = "0.0.0.0/0"
}
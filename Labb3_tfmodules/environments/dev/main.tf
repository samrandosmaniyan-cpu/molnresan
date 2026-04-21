module "webstack" {
  source = "../../modules/webstack"

  # Identitet
  project_name = "dev-miljo"
  environment  = "dev"

  # Regionen (kommer från variables.tf)
  aws_region = var.aws_region

  # Storlekar – små för dev
  instance_type        = "t3.micro"
  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 20

  # Databas
  db_username = "admin"
  db_password = var.db_password

  # Nyckel – sökväg relativt till denna mapp
  public_key_path = "../../keys/dev-key.pub"

  # Öppet SSH för enkelhets skull i dev
  allowed_ssh_cidr = "0.0.0.0/0"
}
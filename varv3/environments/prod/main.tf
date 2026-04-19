module "webstack" {
  source = "../../modules/webstack"

  # Identitet
  project_name = "prod-miljo"
  environment  = "prod"

  # Regionen (kommer från variables.tf)
  aws_region = var.aws_region

  # Storlekar – något kraftfullare för prod (illustrerar skillnad)
  instance_type        = "t3.micro"
  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 30

  # Databas
  db_username = "admin"
  db_password = var.db_password

  # Nyckel – annan nyckel än dev
  public_key_path = "../../keys/prod-key.pub"

  # Striktare SSH-regel i prod (begränsa till din IP)
  allowed_ssh_cidr = "0.0.0.0/0"
}
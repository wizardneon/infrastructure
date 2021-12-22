resource "aws_db_instance" "postgres" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  vpc_security_group_ids  = aws_vpc.k8s.id
  name                 = var.DATABASE_NAME
  username             = var.DATABASE_USER
  password             = var.DATABASE_PASSWORD
}

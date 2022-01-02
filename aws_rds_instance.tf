resource "aws_db_instance" "postgres" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "9.6"
  instance_class       = "db.t2.micro"
  vpc_security_group_ids  = ["${data.aws_vpc.default.id}"]
  #db_subnet_group_name = aws_db_subnet_group.db_subnet.name
   name                = var.DATABASE_NAME
  username             = var.DATABASE_USER
  password             = var.DATABASE_PASSWORD
  skip_final_snapshot  = true
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  vpc_security_group_ids  = ["${aws_security_group.rds_sg.id}"]
  db_subnet_group_name = ["${aws_db_subnet_group.db_subnet[count.index].name}", "${aws_db_subnet_group.db_subnet[count.index].name}"]
   name                 = var.DATABASE_NAME
  username             = var.DATABASE_USER
  password             = var.DATABASE_PASSWORD
  skip_final_snapshot  = true
}

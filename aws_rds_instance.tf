resource "aws_db_instance" "diplomrds" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  vpc_security_group_ids      =["${aws_security_group.rds_sg.id}"]
  name                 = $database_name
  username             = $database_user
  password             = $database_password
  skip_final_snapshot  = true
}

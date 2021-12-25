#VPC
data "aws_availability_zones" "available" {
}
resource "aws_vpc" "k8s" {
  cidr_block = "10.0.0.0/16"

  tags = tomap({
    "Name" = "terraform-eks-k8s-worker-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}

#subnets
resource "aws_subnet" "k8s" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.k8s.id
  map_public_ip_on_launch = true
  tags = tomap({
    "Name" = "terraform-eks-k8s-worker-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}
resource "aws_subnet" "rds" {
  
  availability_zone = data.aws_availability_zones.available.names[2]
  cidr_block        = "10.0.4.0/24"
  vpc_id            = aws_vpc.k8s.id
  map_public_ip_on_launch = true
  tags = tomap({
    "Name" = "terraform-eks-k8s-worker-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "shared",
  })
}



resource "aws_db_subnet_group" "db_subnet" {

name = "db_subnet"
subnet_ids = ["${aws_subnet.k8s[0].id}", "${aws_subnet.rds.id}", "${aws_subnet.k8s[1].id}"]
}

#gateway
resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id

  tags = {
    Name = "terraform-eks-k8s"
  }
}

#aws_route_table
resource "aws_route_table" "k8s" {
  vpc_id = aws_vpc.k8s.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }
}

resource "aws_route_table_association" "k8s" {
  count = 2

  subnet_id      = aws_subnet.k8s.*.id[count.index]
  route_table_id = aws_route_table.k8s.id
}


resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  assign_generated_ipv6_cidr_block = "false"
  enable_classiclink = "false"
  enable_classiclink_dns_support = "false"

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}


resource "aws_subnet" "dmz" {
  vpc_id = aws_vpc.main.id
  availability_zone = "us-west-2a"
  cidr_block = "10.0.10.0/24"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "dmz" {
  vpc_id = aws_vpc.main.id
    
  route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "dmz"{
    subnet_id = aws_subnet.dmz.id
    route_table_id = aws_route_table.dmz.id
}


resource "aws_eip" "eip" {
  vpc = true
  instance = aws_instance.ec2.id
  associate_with_private_ip = "10.0.10.250"
}

resource "aws_instance" "ec2" {
  ami  = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id  = aws_subnet.dmz.id
  availability_zone = "us-west-2a"
  private_ip = "10.0.10.250"
  root_block_device {
    volume_type = "gp3"
    volume_size = 8

  }
}
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/*18.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}



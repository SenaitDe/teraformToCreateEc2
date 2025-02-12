provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "demo-server2" {
  ami           = "ami-04b4f1a9cf54c11d0" 
  instance_type = "t2.micro"              
  key_name = "aws-key" 
  //security_groups = ["Demo-sg" ]
  subnet_id = aws_subnet.dpp-public-subnet-01.id
  for_each = toset(["Jenknis-master", "build-slave", "ansible"])
   tags = {
     Name = "${each.key}"
   }

  # ✅ Attach security Group

  vpc_security_group_ids = [aws_security_group.Demo_sg.id] 
 


  }


  
# ✅ Create Security Group
resource "aws_security_group" "Demo_sg" {
  name        = "Demo-security-group"
  description = "Security group for web servers allowing SSH, HTTP"
  vpc_id = aws_vpc.dpp-vpc.id
  # ✅ Allow SSH Access (Change "0.0.0.0/0" to your IP for better security)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ✅ Allow HTTP (Port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  # ✅ Allow All Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Demo-security-group"
  }
}
resource "aws_vpc" "dpp-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "dpp-vpc"
    
  }
  
}
resource "aws_subnet" "dpp-public-subnet-01" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
  tags = {
    Name = "dpp-public-subnet-01"
  }

}
resource "aws_subnet" "dpp-public-subnet-02" {
  vpc_id = aws_vpc.dpp-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"
  tags = {
    Name = "dpp-public-subnet-02"

  }
}
resource "aws_internet_gateway" "dpp-igw" {
  vpc_id = aws_vpc.dpp-vpc.id
  tags = {
    Name = "dpp-igw"
  }
  
}
resource "aws_route_table" "dpp-public-rt" {
  vpc_id = aws_vpc.dpp-vpc.id
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.dpp-igw.id
  }

}
resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
  subnet_id = aws_subnet.dpp-public-subnet-01.id
  route_table_id = aws_route_table.dpp-public-rt.id 
}

resource "aws_route_table_association" "dpp-public-subnet-02" {
  subnet_id = aws_subnet.dpp-public-subnet-02.id
  route_table_id = aws_route_table.dpp-public-rt.id

  
}
  




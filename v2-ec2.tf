provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "demo-server2" {
  ami           = "ami-0ac4dfaf1c5c0cce9" 
  instance_type = "t2.micro"              
  key_name = "aws-key" 
  }
  
# ✅ Create Security Group
resource "aws_security_group" "Demo_sg" {
  name        = "Demo-security-group"
  description = "Security group for web servers allowing SSH, HTTP, and HTTPS"
  
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




 


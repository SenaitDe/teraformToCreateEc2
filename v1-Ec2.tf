provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "demo-server" {
  ami           = "ami-0ac4dfaf1c5c0cce9" 
  instance_type = "t2.micro"              
 key_name = "aws-key"  
}

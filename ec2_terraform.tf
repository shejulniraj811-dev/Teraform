provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "myEc2instance" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t3.micro"
  key_name = "aws_key.pem"
  vpc_security_group = "sg-0981f1bdf4af6c11d"

  tags = {
    Name = "Niraj"
    name = "Niraj"
    env = "dev"
  }

}
provider "aws" {
    region = "us-east-1"
}

variable "ami" {
  description = "your ami id"
}

variable "instance_type" {
  description = "your instance type i.e t2.micro"
}

resource "aws_instance" "example" {
  ami = var.ami
  instance_type = var.instance_type
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}
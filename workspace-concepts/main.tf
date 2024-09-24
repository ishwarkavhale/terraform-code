

variable "ami" {
  description = "your ami id"
}

variable "instance_type" {
  description = "your instance type i.e t2.micro"
  type = map(string)

    default = {
      "dev" = "t2.micro"
      "stage" = "t2.medium"
      "prod" = "t2.micro"
    }

}

module "ec2_instance" {
  source = "./modules/ec2-instance"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "Error: You have not passed default instance type vslue")
}

output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}
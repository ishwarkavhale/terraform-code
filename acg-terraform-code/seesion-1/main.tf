resource "aws_instance" "web" {
  
  instance_type = "t3.micro"
  ami = data.aws_ami.this.id

  user_data = filebase64("scripts/user_data.sh")
  vpc_security_group_ids = [ aws_security_group.allow_http.id ]
}

data "aws_ami" "this" {
  most_recent = true
   owners = [ "amazon" ]
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "name"
    values = [ "al2023-ami-2023*" ]
  }
}

data "aws_vpc" "this" {
  cidr_block = "172.31.0.0/16"
}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.this.id

  tags = {
    Name = "allow_http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# For Ipv6
# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
#   security_group_id = aws_security_group.allow_http.id
#   cidr_ipv6         = "::/0"
#   ip_protocol       = "-1" # semantically equivalent to all ports
# }

output "public_ip" {
  value = aws_instance.web.public_ip
}
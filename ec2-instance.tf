
# key pair for ssh login
/*resource "aws_key_pair" "terraform-ec2" {
  key_name   = "terraform-ec2"
  public_key = file("./terra-key.pub")
}*/

# default vpc for ec2
resource "aws_default_vpc" "default" {
 
}

# security group
resource "aws_security_group" "terraform-security" {
  name = "terraform-security"
  vpc_id = aws_default_vpc.default.id
}

# security group outbound rule
resource "aws_vpc_security_group_egress_rule" "anywhere" {
  security_group_id = aws_security_group.terraform-security.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# security group inbound rule (ssh)
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.terraform-security.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

# security group inbound rule (http)
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.terraform-security.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

# security group inbound rule (https)
resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.terraform-security.id
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

# ec2 instance 
resource "aws_instance" "ec2-server" {
    ami = "ami-019715e0d74f695be"
    instance_type = "t2.micro"
    # key_name = aws_key_pair.terraform-ec2.key_name
    security_groups = [aws_security_group.terraform-security.name]
    depends_on = [aws_security_group.terraform-security]
    root_block_device {
        volume_size = 8
        volume_type = "gp3"
  }
}


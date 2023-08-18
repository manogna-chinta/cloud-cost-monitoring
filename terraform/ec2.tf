# Ec2 instance resource 

resource "aws_instance" "komiser_instance"{
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh_key.key_name

   vpc_security_group_ids = [
   aws_security_group.allow_tls.id
]

  depends_on =[aws_security_group.allow_tls]
  user_data  = "${file("install.sh")}"
  

  tags = {
        tag-key = "aws-komiser"
    }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0de1ec8ed80e5a61e"

  ingress {
    description = "For ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "For Django"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_key_pair" "ssh_key" {
     key_name = "komiser-ssh-key"
     public_key = file("~/.ssh/komiser-ssh-key.pub")
}
# Elastic Ip
resource "aws_eip" "komiser_instance_ip" {
    instance = "${aws_instance.komiser_instance.id}"
    vpc      = true
}

resource "aws_eip_association" "eip_association"{
   instance_id = "${aws_instance.komiser_instance.id}"
   allocation_id = "${aws_eip.komiser_instance_ip.id}"
}

output "ec2_elastic_ip" {
   value = aws_eip.komiser_instance_ip.public_ip
}
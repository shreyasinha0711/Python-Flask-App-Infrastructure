# Create ansible security group
resource "aws_security_group" "ansible_sg" {
  depends_on = [
    aws_vpc.main_vpc,
  ]
  name        = "ansible_sg"
  description = "security group for Ansible ec2"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.207.210.253/32"]
  }

  ingress {
    description = "allow 8080 for jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow 5000 for flask app"
    from_port   = 5000
    to_port     = 5000
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
    "Name" = "ansible_sg",
    "Environment" = "${var.environment_tag}"
  }
}

#key pair for ssh
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file("key.pub")
}

# Create ansible ec2 instance
resource "aws_instance" "ansible_ec2" {
  depends_on = [
    aws_security_group.ansible_sg,
  ]
  ami                    = var.instance_ami
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  subnet_id              = aws_subnet.main_subnet_public.id
  user_data              = file("userdata_ansible.sh")
  tags = {
    "Name" = "ansible_ec2",
    "Environment" = "${var.environment_tag}"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("key")
    host        = aws_instance.ansible_ec2.public_ip
  }
}

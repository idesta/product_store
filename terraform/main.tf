resource "aws_instance" "mern_ec2" {
  ami                    = var.ubuntu_ami_id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.mern_sg.id]

  tags = {
    Name = "mern-devops-ubuntu-24"
  }
}

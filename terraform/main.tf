# The Brain: Master Node
resource "aws_instance" "k8s_master" {
  ami                    = var.ubuntu_ami_id
  instance_type          = "t3.medium" # Master needs 2 vCPUs/4GB RAM
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.mern_sg.id]

  tags = { Name = "k8s-master", Role = "master" }
}

# The Muscle: Worker Nodes
resource "aws_instance" "k8s_worker" {
  count                  = 2
  ami                    = var.ubuntu_ami_id
  instance_type          = "t3.small"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.mern_sg.id]

  tags = { Name = "k8s-worker-${count.index}", Role = "worker" }
}
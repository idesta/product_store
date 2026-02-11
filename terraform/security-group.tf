resource "aws_security_group" "mern_sg" {
  name        = "mern-app-sg"
  description = "Security group for MERN K8s cluster"

  # --- PUBLIC ACCESS PORTS ---
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "K8s API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Needed for kubectl from your local machine
  }

  # --- INTERNAL CLUSTER COMMUNICATION (The "Magic" Part) ---
  # We allow ALL traffic if it comes from a server using this SAME security group.

  ingress {
    description = "Allow internal cluster traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true 
  }

  # --- KUBE-FLANNEL / CNI NETWORKING ---
  # Flannel needs UDP ports 8285 and 8472 to create the overlay network

  ingress {
    description = "Flannel UDP 1"
    from_port   = 8285
    to_port     = 8285
    protocol    = "udp"
    self        = true
  }

  ingress {
    description = "Flannel UDP 2"
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
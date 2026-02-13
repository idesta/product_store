# 1. Acquire a Public IP address for the cluster
resource "cloudstack_ipaddress" "k8s_public_ip" {
  zone       = var.cs_zone
  network_id = var.cs_network_id
}

# 2. FIREWALL: Open the "Hole" in the Virtual Router
# This allows traffic to reach your Public IP
resource "cloudstack_firewall" "k8s_fw" {
  ip_address_id = cloudstack_ipaddress.k8s_public_ip.id

  rule {
    cidr_list = [var.allowed_ssh_ip]
    protocol  = "tcp"
    ports     = ["22"]
  }

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol  = "tcp"
    ports     = ["6443", "80"]
  }
}

# 3. PORT FORWARDING: Direct traffic from the Public IP to the Master VM
# We map public 6443 to Master 6443 so 'kubectl' works
resource "cloudstack_port_forward" "master_pf" {
  ip_address_id = cloudstack_ipaddress.k8s_public_ip.id

  forward {
    protocol           = "tcp"
    public_port        = 6443
    private_port       = 6443
    virtual_machine_id = cloudstack_instance.k8s_master.id
  }

  forward {
    protocol           = "tcp"
    public_port        = 22
    private_port       = 22
    virtual_machine_id = cloudstack_instance.k8s_master.id
  }
}

# 4. EGRESS: Allow your VMs to reach the internet (Updates/Docker)
# Without this, 'apt-get install' will hang and fail
resource "cloudstack_egress_firewall" "allow_internet" {
  network_id = var.cs_network_id

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol  = "all"
  }
}
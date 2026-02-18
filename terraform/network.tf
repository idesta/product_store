# 1. Look up the existing IP instead of creating a new one
data "cloudstack_ipaddress" "k8s_public_ip" {
  filter {
    name  = "ipaddress"
    value = "196.188.250.157"
  }
}

# 2. Update the Firewall to use the Data Source ID
resource "cloudstack_firewall" "k8s_fw" {
  ip_address_id = data.cloudstack_ipaddress.k8s_public_ip.id
  managed       = true

  rule {
    cidr_list = [var.allowed_ssh_ip]
    protocol  = "tcp"
    ports     = ["2201", "2205", "2206"] # Dedicated SSH ports
  }

  rule {
    cidr_list = ["0.0.0.0/0"]
    protocol  = "tcp"
    ports     = ["6443", "80"]
  }
}

# 3. Update Port Forwarding to use the Data Source ID, Port Forwarding: Map Public Ports to Private Port 22
resource "cloudstack_port_forward" "ssh_forwarding" {
  ip_address_id = data.cloudstack_ipaddress.k8s_public_ip.id
  managed       = true
  depends_on = [cloudstack_firewall.k8s_fw]

  # Master Node
  forward {
    protocol           = "tcp"
    public_port        = 2201
    private_port       = 22
    virtual_machine_id = cloudstack_instance.k8s_master.id
  }

  # Worker 0
  forward {
    protocol           = "tcp"
    public_port        = 2205
    private_port       = 22
    virtual_machine_id = cloudstack_instance.k8s_worker[0].id
  }

  # Worker 1
  forward {
    protocol           = "tcp"
    public_port        = 2206
    private_port       = 22
    virtual_machine_id = cloudstack_instance.k8s_worker[1].id
  }
}

# 4. EGRESS: Allow your VMs to reach the internet (Updates/Docker)
# Without this, 'apt-get install' will hang and fail
#resource "cloudstack_egress_firewall" "allow_internet" {
  #managed = true
  #network_id = var.cs_network_id
  #network_id = "5366de98-c84b-452e-a775-ba2665fe2294"
  
#rule {
    #cidr_list = ["0.0.0.0/0"]
    #protocol  = "all"
  #}
#}

# 1. Declare the Security Group that main.tf is looking for
############################################
# Security Group
############################################

resource "cloudstack_security_group" "k8s_sg" {
  name        = "k8s-cluster-sg"
  description = "Security group for internal K8s cluster communication"
}

############################################
# INTERNAL TCP
############################################

resource "cloudstack_security_group_rule" "internal_tcp" {
  security_group_id = cloudstack_security_group.k8s_sg.id

  rule {
    protocol = "tcp"
    ports = ["1-65535"]
    user_security_group_list = [cloudstack_security_group.k8s_sg.name]
  }
}

############################################
# INTERNAL UDP
############################################

resource "cloudstack_security_group_rule" "internal_udp" {
  security_group_id = cloudstack_security_group.k8s_sg.id

  rule {
    protocol = "udp"
    ports = ["1-65535"]
    user_security_group_list = [cloudstack_security_group.k8s_sg.name]
  }
}

############################################
# INTERNAL ICMP
############################################

resource "cloudstack_security_group_rule" "internal_icmp" {
  security_group_id = cloudstack_security_group.k8s_sg.id

  rule {
    protocol  = "icmp"
    icmp_type = -1
    icmp_code = -1

    user_security_group_list = [
      cloudstack_security_group.k8s_sg.name
    ]
  }
}



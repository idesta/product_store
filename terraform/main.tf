# --- MASTER NODE ---
resource "cloudstack_instance" "k8s_master" {
  name             = "k8s-master-01"
  service_offering = var.master_instance_type 
  template         = var.cloudstack_template    
  zone             = var.cs_zone
  network_id       = var.cs_network_id
  keypair          = var.key_name

  # Crucial: This allows workers to talk to master internally
  security_group_names = [cloudstack_security_group.k8s_sg.name]

  # Bootstraps the Master Node
  user_data = file("./scripts/master-init.sh")
}

# --- WORKER NODES ---
resource "cloudstack_instance" "k8s_worker" {
  count            = 2
  name             = "k8s-worker-${count.index}"
  service_offering = var.worker_instance_type   
  template         = var.cloudstack_template  
  zone             = var.cs_zone
  network_id       = var.cs_network_id
  keypair          = var.key_name


 # Crucial: This allows workers to talk to master internally
  security_group_names = [cloudstack_security_group.k8s_sg.name]
  
  user_data = file("./scripts/worker-init.sh")
}
# Register the Public Key in CloudStack
#resource "cloudstack_ssh_keypair" "k8s_key" {
 # name       = "cloudstack_keypair"
  #public_key = file("../cloudstack_keypair.pub")
#}



data "cloudstack_ssh_keypair" "k8s_key" {
  filter {
    name  = "name"
    value = "cloudstack_keypair"
  }
}



# Master Instance
resource "cloudstack_instance" "k8s_master" {
  name             = "k8s-master-01"
  service_offering = var.master_instance_type
  template         = var.cloudstack_template
  zone             = var.cs_zone
  network_id       = var.cs_network_id
  
  # CRITICAL: Point to the resource above
  keypair          = data.cloudstack_ssh_keypair.k8s_key.name

  security_group_names = [cloudstack_security_group.k8s_sg.name]

  expunge          = true

  user_data = <<-EOT
    #cloud-config
    manage_resolv_conf: true
    resolv_conf:
      nameservers:
        - 8.8.8.8
        - 1.1.1.1
    users:
      - name: root
        ssh_authorized_keys:
          - ${file("../cloudstack_keypair.pub")}
    disable_root: false
  EOT
}

# Worker Instances
resource "cloudstack_instance" "k8s_worker" {
  count            = 2
  name             = "k8s-worker-${count.index}"
  service_offering = var.worker_instance_type
  template         = var.cloudstack_template
  zone             = var.cs_zone
  network_id       = var.cs_network_id
  
  # CRITICAL: Point to the resource above
  keypair          = data.cloudstack_ssh_keypair.k8s_key.name

  security_group_names = [cloudstack_security_group.k8s_sg.name]

  expunge          = true

  user_data = <<-EOT
    #cloud-config
    manage_resolv_conf: true
    resolv_conf:
      nameservers:
        - 8.8.8.8
        - 1.1.1.1
    users:
      - name: root
        ssh_authorized_keys:
          - ${file("../cloudstack_keypair.pub")}
    disable_root: false
  EOT
}
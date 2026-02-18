# 1. Ensure SSH Key Permissions are 0400
resource "null_resource" "fix_key_permissions" {
  provisioner "local-exec" {
    command = "chmod 0400 ${abspath("../cloudstack_keypair")}"
  }

  triggers = {
    key_exists = fileexists("../cloudstack_keypair")
  }
}

# 2. Generate the Ansible Inventory (Direct Public Access)
resource "local_file" "ansible_inventory" {
  content = <<EOT
[masters]
master ansible_host=${data.cloudstack_ipaddress.k8s_public_ip.ip_address} ansible_port=2201 ansible_user=root ansible_ssh_private_key_file=${abspath("../cloudstack_keypair")}

[workers]
worker-0 ansible_host=${data.cloudstack_ipaddress.k8s_public_ip.ip_address} ansible_port=2205 ansible_user=root ansible_ssh_private_key_file=${abspath("../cloudstack_keypair")}
worker-1 ansible_host=${data.cloudstack_ipaddress.k8s_public_ip.ip_address} ansible_port=2206 ansible_user=root ansible_ssh_private_key_file=${abspath("../cloudstack_keypair")}

[k8s:children]
masters
workers

[all:vars]
# Disables host key checking to prevent the "authenticity can't be established" prompt
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOT
  filename = "../ansible/inventory/hosts.ini"
}

# 3. Execute the Ansible Playbook
resource "null_resource" "run_ansible" {
  depends_on = [
    cloudstack_instance.k8s_master,
    cloudstack_instance.k8s_worker,
    cloudstack_port_forward.ssh_forwarding, # Using the new PF resource name from previous step
    local_file.ansible_inventory,
    null_resource.fix_key_permissions
  ]

  provisioner "local-exec" {
    command = <<EOT
      # Clear fingerprints for the specific ports to avoid collisions
      ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[${data.cloudstack_ipaddress.k8s_public_ip.ip_address}]:2201" || true
      ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[${data.cloudstack_ipaddress.k8s_public_ip.ip_address}]:2205" || true
      ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[${data.cloudstack_ipaddress.k8s_public_ip.ip_address}]:2206" || true
      
      # Wait for VMs to be ready
      sleep 60; 

      # Run the main playbook
      export ANSIBLE_HOST_KEY_CHECKING=False;
      ansible-playbook -i ../ansible/inventory/hosts.ini ../ansible/playbooks/site.yml
    EOT
  }
}



# [ansible-playbook -i ../ansible/inventory/hosts.ini ../ansible/playbooks/site.yml]

# 1. Manually ensure your SSH key has the right permissions

# [chmod 400 ../cloudstack_keypair]

# 2. Run the playbook directly from the command line

# [export ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../ansible/inventory/hosts.ini ../ansible/playbooks/site.yml]
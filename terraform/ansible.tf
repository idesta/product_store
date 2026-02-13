# 1. Ensure SSH Key Permissions are 0400 (Required for SSH security)
resource "null_resource" "fix_key_permissions" {
  provisioner "local-exec" {
    command = "chmod 0400 ${abspath("../cloudstack_keypair.key")}"
  }

  triggers = {
    key_exists = fileexists("../cloudstack_keypair.key")
  }
}

# 2. Generate the Ansible Inventory (hosts.ini)
# Uses abspath to ensure the ProxyCommand finds the key regardless of execution directory
resource "local_file" "ansible_inventory" {
  content = <<EOT
[masters]
master ansible_host=${data.cloudstack_ipaddress.k8s_public_ip.ip_address} ansible_user=ubuntu ansible_ssh_private_key_file=${abspath("../cloudstack_keypair.key")}

[workers]
%{ for index, vm in cloudstack_instance.k8s_worker ~}
worker-${index} ansible_host=${vm.ip_address} ansible_user=ubuntu ansible_ssh_private_key_file=${abspath("../cloudstack_keypair.key")} ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i ${abspath("../cloudstack_keypair.key")} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p -q ubuntu@${data.cloudstack_ipaddress.k8s_public_ip.ip_address}"'
%{ endfor ~}

[k8s:children]
masters
workers

[all:vars]
ansible_ssh_extra_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
EOT
  filename = "../ansible/inventory/hosts.ini"
}

# 3. Execute the Ansible Playbook
resource "null_resource" "run_ansible" {
  depends_on = [
    cloudstack_instance.k8s_master,
    cloudstack_instance.k8s_worker,
    cloudstack_port_forward.master_pf,
    local_file.ansible_inventory,
    null_resource.fix_key_permissions
  ]

  provisioner "local-exec" {
    command = <<EOT
      # Automatically clear old SSH fingerprints for this Public IP
      ssh-keygen -f "$HOME/.ssh/known_hosts" -R "${data.cloudstack_ipaddress.k8s_public_ip.ip_address}" || true
      
      # Wait for cloud-init and SSH daemon to fully initialize on the VMs
      sleep 90; 

      # Run the main playbook
      export ANSIBLE_HOST_KEY_CHECKING=False;
      ansible-playbook -i ../ansible/inventory/hosts.ini ../ansible/playbooks/site.yml
    EOT
  }
}
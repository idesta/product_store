resource "local_file" "ansible_inventory" {
  content = <<EOT
[masters]
# We use the Public IP of the CloudStack Virtual Router for the Master
master ansible_host=${cloudstack_ipaddress.k8s_public_ip.ip_address} ansible_user=ubuntu ansible_ssh_private_key_file=../cloudstack_keypair.key

[workers]
%{ for index, vm in cloudstack_instance.k8s_worker ~}
# Workers use internal IPs. Ansible will connect to these via the Master as a Jump Host
worker-${index} ansible_host=${vm.ip_address} ansible_user=ubuntu ansible_ssh_private_key_file=../cloudstack_keypair.key ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q ubuntu@${cloudstack_ipaddress.k8s_public_ip.ip_address} -i ../cloudstack_keypair.key"'
%{ endfor ~}

[k8s:children]
masters
workers
EOT
  filename = "../ansible/inventory/hosts.ini"
}

resource "null_resource" "run_ansible" {
  depends_on = [
    cloudstack_instance.k8s_master,
    cloudstack_instance.k8s_worker,
    cloudstack_port_forward.master_pf, # Crucial: Wait for the SSH port to be open!
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = <<EOT
      sleep 60; 
      export ANSIBLE_HOST_KEY_CHECKING=False;
      ansible-playbook -i ../ansible/inventory/hosts.ini ../ansible/playbooks/site.yml
    EOT
  }
}
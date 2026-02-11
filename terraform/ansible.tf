resource "local_file" "ansible_inventory" {
  content = <<EOT
[masters]
master ansible_host=${aws_instance.k8s_master.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=../product-node-ci-cd-2.pem

[workers]
%{ for index, ip in aws_instance.k8s_worker[*].public_ip ~}
worker-${index} ansible_host=${ip} ansible_user=ubuntu ansible_ssh_private_key_file=../product-node-ci-cd-2.pem
%{ endfor ~}

[k8s:children]
masters
workers
EOT
  filename = "../ansible/inventory/hosts.ini"
}

resource "null_resource" "run_ansible" {
  # This ensures Ansible only runs AFTER the instances are up AND the inventory is written
  depends_on = [
    aws_instance.k8s_master,
    aws_instance.k8s_worker,
    local_file.ansible_inventory
  ]

  provisioner "local-exec" {
    command = <<EOT
      sleep 30;
      export ANSIBLE_HOST_KEY_CHECKING=False;
      ansible-playbook -i ../ansible/inventory/hosts.ini ../ansible/playbooks/site.yml
    EOT
  }
}

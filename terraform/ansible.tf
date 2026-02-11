resource "null_resource" "ansible_provision" {
  depends_on = [aws_instance.mern_ec2]

  provisioner "local-exec" {
    command = <<EOT
      cd ../ansible &&
      ansible-playbook -i inventory/hosts.ini playbooks/site.yml
    EOT
  }
}

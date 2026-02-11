# The IP of your Master Node
output "master_public_ip" {
  description = "Public IP of the Kubernetes Master"
  value       = aws_instance.k8s_master.public_ip
}

# A list of IPs for all your Worker Nodes
output "worker_public_ips" {
  description = "List of public IPs for the Kubernetes Workers"
  value       = aws_instance.k8s_worker[*].public_ip
}

# Helpful for SSH: The Master DNS
output "master_dns" {
  value = aws_instance.k8s_master.public_dns
}
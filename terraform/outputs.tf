# 1. The Public IP of your Master (via the NAT/Port Forwarding)
output "master_public_ip" {
  description = "The Public IP used to access the Kubernetes Master"
  value       = cloudstack_ipaddress.k8s_public_ip.ip_address
}

# 2. The Internal IPs (Useful for internal cluster debugging)
output "master_private_ip" {
  description = "The internal IP of the Master node"
  value       = cloudstack_instance.k8s_master.ip_address
}

output "worker_private_ips" {
  description = "The internal IPs of the Worker nodes"
  value       = cloudstack_instance.k8s_worker[*].ip_address
}

# 3. Reminder for SSH
output "ssh_instructions" {
  value = "SSH into the master using: ssh -i your_key.pem ubuntu@${cloudstack_ipaddress.k8s_public_ip.ip_address}"
}
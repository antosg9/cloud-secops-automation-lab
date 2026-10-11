output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "bastion_public_ip" {
  description = "Public IP of the bastion (the only entry point)."
  value       = aws_instance.bastion.public_ip
}

output "private_vm_private_ip" {
  description = "Private IP of the workload VM (not reachable from the Internet)."
  value       = aws_instance.private_vm.private_ip
}

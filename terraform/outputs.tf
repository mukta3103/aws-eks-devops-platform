output "vpc_id" {
  description = "Provisioned VPC ID"
  value       = aws_vpc.main.id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_endpoint" {
  description = "EKS API server endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "ecr_repository_url" {
  description = "ECR repository URL for the microservice image"
  value       = aws_ecr_repository.app.repository_url
}

output "jenkins_public_ip" {
  description = "Public IP of the Jenkins and Ansible host"
  value       = aws_instance.jenkins.public_ip
}

output "kubeconfig_command" {
  description = "Command to configure local kubectl access"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${aws_eks_cluster.main.name}"
}

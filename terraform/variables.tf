variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project prefix used for naming AWS resources"
  type        = string
  default     = "eks-cloud-platform"
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets across two AZs"
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets across two AZs"
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "eks_version" {
  description = "Kubernetes version for the EKS control plane"
  type        = string
  default     = "1.29"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 4
}

variable "jenkins_instance_type" {
  description = "EC2 instance type for the Jenkins and Ansible host"
  type        = string
  default     = "t3.medium"
}

variable "ssh_key_name" {
  description = "Existing AWS EC2 key pair name for SSH access"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the Jenkins EC2 host"
  type        = string
  default     = "0.0.0.0/0"
}

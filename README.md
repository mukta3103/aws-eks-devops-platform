# AWS EKS Cloud Platform & CI/CD Pipeline

End-to-end cloud infrastructure and automated delivery pipeline built on AWS. The project provisions a custom VPC and Amazon EKS cluster with Terraform, configures a Jenkins + Ansible controller on EC2, containerizes a Python microservice with Docker, and deploys both the application and a Prometheus/Grafana monitoring stack to Kubernetes.

## Tooling Stack

- **Infrastructure & Cloud:** AWS (VPC, EKS, EC2, ECR, IAM), Terraform
- **Configuration & Automation:** Linux, Bash, Ansible
- **Containerization & Orchestration:** Docker, Kubernetes (EKS)
- **CI/CD & Version Control:** Jenkins, Git, GitHub
- **Monitoring:** Prometheus, Grafana

## Repository Layout

```text
aws-eks-devops-platform/
├── app/                        # Containerized Python service + unit tests
│   ├── src/
│   │   └── server.py
│   ├── tests/
│   │   └── test_server.py
│   ├── Dockerfile
│   ├── .dockerignore
│   └── requirements.txt
├── terraform/                  # AWS VPC, IAM, ECR, EC2, and EKS provisioning
│   ├── versions.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── iam.tf
│   ├── security.tf
│   ├── ecr.tf
│   ├── eks.tf
│   ├── ec2-jenkins.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── ansible/                    # EC2 CI/CD host configuration & cluster setup
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts.ini.example
│   └── playbooks/
│       ├── setup-ci-host.yml
│       └── deploy-monitoring.yml
├── kubernetes/                 # Plain Kubernetes manifests (app + monitoring)
│   ├── app/
│   │   ├── namespace.yaml
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── monitoring/
│       ├── namespace.yaml
│       ├── prometheus-config.yaml
│       ├── prometheus-deployment.yaml
│       └── grafana-deployment.yaml
├── jenkins/                    # Declarative CI/CD pipeline
│   └── Jenkinsfile
└── scripts/                    # Linux/Bash helper & lifecycle scripts
    ├── bootstrap-tools.sh
    ├── deploy-infra.sh
    ├── health-check.sh
    └── cleanup.sh
```

## Architecture Overview

1. **Networking & Compute (`terraform/`):** Creates a dedicated VPC across two Availability Zones with public subnets (for the NAT Gateway, Load Balancers, and the Jenkins/Ansible EC2 host) and private subnets (for EKS worker nodes).
2. **Configuration Management (`ansible/`):** Bootstraps the EC2 controller with Java 17, Jenkins, Docker, `kubectl`, Terraform, and AWS CLI v2.
3. **CI/CD (`jenkins/`):** Pulls source code from GitHub, runs unit tests, builds and tags the Docker image, pushes it to Amazon ECR, and performs a rolling update on EKS.
4. **Observability (`kubernetes/monitoring/`):** Deploys Prometheus (scraping pods annotated with `prometheus.io/scrape: "true"`) and Grafana pre-configured with the Prometheus datasource.

## Quick Start

### 1. Prerequisites

Ensure AWS credentials are configured (`aws configure`) and verify local CLI tools:

```bash
chmod +x scripts/*.sh
./scripts/bootstrap-tools.sh
```

### 2. Provision AWS Infrastructure

Copy the example variables file and update it with your key pair name and allowed SSH CIDR:

```bash
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
./scripts/deploy-infra.sh
```

### 3. Configure the Jenkins Host with Ansible

Copy the inventory template, add the `jenkins_public_ip` output from Terraform, and run the playbook:

```bash
cp ansible/inventory/hosts.ini.example ansible/inventory/hosts.ini
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/setup-ci-host.yml
```

### 4. Deploy Monitoring & Verify Cluster Health

```bash
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy-monitoring.yml
./scripts/health-check.sh
```

### 5. Configure Jenkins Pipeline

1. Open Jenkins at `http://<jenkins_public_ip>:8080` and complete initial setup.
2. Add AWS credentials (`aws-credentials`) and update `AWS_ACCOUNT_ID` / `ECR_REPO` in `jenkins/Jenkinsfile` or Jenkins environment variables.
3. Create a Pipeline job pointing to your GitHub repository and `jenkins/Jenkinsfile`.

### 6. Teardown

Always remove Kubernetes LoadBalancer services before destroying Terraform resources so AWS ENIs and security groups detach cleanly:

```bash
./scripts/cleanup.sh
```

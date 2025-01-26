# Terraform Infrastructure Project

This project manages infrastructure using Terraform. It leverages modules for reusable components and supports Kubernetes deployments through Helm charts.

## Features

- **Modular Terraform Code**: Reusable modules for networking, EKS, and Helm.
- **Environment Support**: Dedicated configurations for different environments (e.g., `dev`).
- **Helm Integration**: Deploy Kubernetes applications with custom Helm values.
- **State Management**: Remote state configuration via `backend.tf`.

## Prerequisites

Ensure the following tools are installed:

- [Terraform](https://www.terraform.io/downloads.html) (version 1.0 or above)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://helm.sh/)

## Project Structure

```plaintext
application/
├── main.tf               # Core Terraform configuration
├── providers.tf          # Providers setup (e.g., AWS, Kubernetes, Helm)
├── variables.tf          # Input variables
├── outputs.tf            # Output variables
├── backend.tf            # Remote state configuration
├── env/                  # Environment-specific variables
│   └── dev.tfvars
├── modules/              # Reusable Terraform modules
│   ├── network/          # Networking configurations
│   ├── eks/              # EKS cluster setup
│   └── helm/             # Helm chart deployments
└── .terraform/           # Terraform state and provider files
```

## Usage

### Initialize Terraform

Run the following command to initialize the Terraform environment:
```bash
terraform init
```

### Plan Changes

Generate and review the execution plan:
```bash
terraform plan -var-file=env/dev.tfvars
```

### Apply Changes

Apply the changes to your infrastructure:
```bash
terraform apply -var-file=env/dev.tfvars
```

### Destroy Infrastructure

To clean up and remove all resources:
```bash
terraform destroy -var-file=env/dev.tfvars
```

## Modules

### Network Module
Manages VPC, subnets, and other networking resources.

### EKS Module
Creates and manages an AWS EKS cluster.

### Helm Module
Deploys Kubernetes applications using Helm charts with predefined values.

## Environments

Environment-specific variables are stored in the `env/` directory. Use appropriate `.tfvars` files for different deployments.
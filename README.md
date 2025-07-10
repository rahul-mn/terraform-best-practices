# Terraform Infrastructure

This repository contains the Infrastructure as Code (IaC) for the project, managed by Terraform. It follows a structured layout to manage multiple environments and components effectively.

## Directory Structure

The repository is organized to promote code reuse and clear separation of concerns:

-   `live/`: Contains the top-level configurations for each environment (e.g., `stage`, `prod`). These are the primary entry points for executing Terraform commands.
-   `modules/`: (Recommended) This directory would contain reusable, modular Terraform code that defines specific parts of the infrastructure, such as a VPC, a database, or an application service.

## Getting Started

To deploy or update an environment, navigate to the specific environment's directory within `live/` and run the standard Terraform workflow.

```sh
cd live/stage/data-stores/mysql
terraform init
terraform plan
terraform apply
```
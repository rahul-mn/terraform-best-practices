# Staging: MySQL RDS Instance

This Terraform configuration provisions and manages a MySQL database instance in the **staging** environment.

## Overview

The `test.json` file in this directory is a Terraform plan file, which shows that this configuration manages an `aws_db_instance` for MySQL.

## Resources Managed

-   `aws_db_instance`: The core RDS database instance.
-   `aws_kms_key` and `aws_kms_alias`: A customer-managed KMS key for encrypting data at rest.

## Usage

To apply changes to the staging database, run Terraform commands from this directory.

```sh
terraform plan
terraform apply
```
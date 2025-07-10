# Live Environments

This directory contains the Terraform configurations for all deployed environments. Each subdirectory corresponds to a unique environment, ensuring isolation between them.

## Environments

-   **stage/**: The staging environment, used for pre-production testing and validation.
-   **prod/**: The production environment, serving live traffic.

Each environment is configured independently by composing reusable modules and setting environment-specific variables. This structure allows for safe and predictable infrastructure management.
# Staging Environment

This directory holds all Terraform configurations for the **staging** environment.

The infrastructure defined here is intended for testing, quality assurance, and validation before changes are promoted to production. It should ideally be a close replica of the production setup.

## Component Groups

-   `data-stores/`: Manages stateful resources like databases and caches.
# Azure Terraform Secure Baseline

Terraform baseline on Azure with:
- Remote state (Azure Storage backend)
- Key Vault (RBAC mode)
- Storage Account (Standard/LRS)
- User Assigned Managed Identity + RBAC role assignments
- GitHub Actions: fmt/validate/plan (PR) and apply (main) (optional)

## Bootstrap remote state (one-time)
```bash
cd bootstrap
./00-bootstrap-state.sh
cp backend.hcl ../infra/backend.hcl


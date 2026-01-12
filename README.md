# Azure Terraform Secure Baseline

Production-minded Azure infrastructure baseline built with **Terraform** and validated using **GitHub Actions**.  
This repository demonstrates a clean, modular, and review-based Infrastructure as Code (IaC) workflow.

---

## ✨ What This Project Covers

- Modular Terraform project structure
- Azure Resource Group baseline
- Terraform module usage (`modules/baseline`)
- CI validation with GitHub Actions
- Formatting & validation checks on Pull Requests
- Safe backend handling (no state in CI)
- Ready for real Azure deployment via CLI or VPS

> ⚠️ This project intentionally avoids running `terraform apply` in CI to prevent accidental costs.

---

## 🏗 Repository Structure

```
.
├── README.md
├── .gitignore
├── .github/
│   └── workflows/
│       ├── terraform_plan.yml
│       └── terraform_apply.yml
├── bootstrap/
│   └── 00-bootstrap-state.sh
└── infra/
    ├── backend.tf
    ├── main.tf
    ├── providers.tf
    ├── variables.tf
    ├── outputs.tf
    └── modules/
        └── baseline/
            ├── main.tf
            ├── variables.tf
            └── outputs.tf
```

## 🔁 CI / GitHub Actions Flow
Pull Request

When a Pull Request is opened:

- terraform fmt -check

- terraform init -backend=false

- terraform validate

This ensures:

- Code is properly formatted

- Syntax and configuration are valid

- No Azure resources are created

Main Branch

- terraform apply is intentionally disabled

- Deployment is done manually from a trusted environment (VPS / local)

## 🚀 Deployment (Manual & Safe)

Deployment is performed manually from a VPS or local machine with Azure access.

### 1. Bootstrap Terraform Remote State

```
cd bootstrap
./00-bootstrap-state.sh
cp backend.hcl ../infra/backend.hcl
```

This creates:

Resource Group for state

Storage Account

Blob container for Terraform state

### 2. Initialize Terraform
```
cd infra
terraform init -backend-config=backend.hcl
```
### 3. Apply Infrastructure
```
terraform apply \
  -var="tenant_id=$(az account show --query tenantId -o tsv)" \
  -var="object_id=$(az ad signed-in-user show --query id -o tsv)"
```
## 🧹 Cleanup

To avoid unnecessary Azure costs:
```
terraform destroy
```

## 🔐 Security Considerations

- Terraform state is stored remotely (Azure Storage)

- No secrets committed to Git

- No cloud credentials stored in CI

- CI runs validation only (no apply)


## 📌 Why This Project Matters

- This repository reflects real-world DevOps practices:

- Pull Request driven infrastructure changes

- Separation of validation and deployment

- Modular Terraform design

- Cost-aware cloud usage

- GitHub Actions as CI gatekeeper


##👤 Author

Alperen Etlik

DevOps / Platform Engineering focused

Terraform · Azure · GitHub Actions




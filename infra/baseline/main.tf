locals {
  rg_name = "rg-${var.workload_name}"
  kv_name = substr(replace("kv-${var.workload_name}-${random_string.suffix.result}", "/[^a-zA-Z0-9-]/", ""), 0, 24)
  sa_name = lower(substr(replace("st${var.workload_name}${random_string.suffix.result}", "/[^a-zA-Z0-9]/", ""), 0, 24))
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

# Storage Account (data/artifact)
resource "azurerm_storage_account" "sa" {
  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version            = "TLS1_2"
  allow_nested_items_to_be_public = false

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

# User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "uami" {
  name                = "id-${var.workload_name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Key Vault (secret store)
resource "azurerm_key_vault" "kv" {
  name                       = local.kv_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  # RBAC mode (policy yerine) - daha modern
  enable_rbac_authorization = true
}

# RBAC: Sen KV üzerinde Admin ol (lab için)
resource "azurerm_role_assignment" "kv_admin_me" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.object_id
}

# RBAC: Managed identity KV secrets okuyabilsin (örnek)
resource "azurerm_role_assignment" "kv_secrets_user_uami" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}

# RBAC: Managed identity Storage Blob Data Contributor olsun
resource "azurerm_role_assignment" "sa_blob_contrib_uami" {
  scope                = azurerm_storage_account.sa.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}

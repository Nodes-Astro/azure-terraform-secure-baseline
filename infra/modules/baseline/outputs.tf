output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.uami.client_id
}

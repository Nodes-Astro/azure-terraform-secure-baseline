output "resource_group_name" {
  value = module.baseline.resource_group_name
}

output "key_vault_name" {
  value = module.baseline.key_vault_name
}

output "storage_account_name" {
  value = module.baseline.storage_account_name
}

output "managed_identity_client_id" {
  value = module.baseline.managed_identity_client_id
}

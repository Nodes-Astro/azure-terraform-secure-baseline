variable "location" {
  type    = string
  default = "northeurope"
}

variable "workload_name" {
  type    = string
  default = "devops-baseline"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id (az account show -> tenantId)"
}

variable "object_id" {
  type        = string
  description = "Your user object id (az ad signed-in-user show -> id)"
}

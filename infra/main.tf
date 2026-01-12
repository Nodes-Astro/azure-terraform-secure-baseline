module "baseline" {
  source        = "./modules/baseline"
  location      = var.location
  workload_name = var.workload_name
  tenant_id     = var.tenant_id
  object_id     = var.object_id
}

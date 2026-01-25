locals {
  tenant_id   = "90d27970-b92c-43dc-9935-1ed557d8e20e"
  environment = "dev"
  common_tags = {
    environment = local.environment
    managed_by  = "opentofu"
    project     = "levendaal"
    layer       = "platform-management"
    owner       = "kvdb"
    cost_center = "platform"
  }
}

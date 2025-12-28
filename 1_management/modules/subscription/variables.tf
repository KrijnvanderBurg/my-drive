variable "name" {
  description = "The name of the subscription (follows naming convention: sub-<workload>-<env>-<region>-<instance>)"
  type        = string
}

variable "billing_scope_id" {
  description = "The billing scope ID from the billing module (module.billing.scope_id)"
  type        = string
}

variable "management_group_id" {
  description = "The fully qualified ID of the management group to associate the subscription with"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the subscription"
  type        = map(string)
}

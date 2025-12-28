variable "management_group_id" {
  description = "The fully qualified ID of the management group to associate the subscription with"
  type        = string
}

variable "subscription_id" {
  description = "The subscription GUID to associate with the management group"
  type        = string
}

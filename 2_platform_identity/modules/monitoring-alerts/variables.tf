variable "environment" {
  description = "Environment name (dev, test, accp, prod)"
  type        = string
}

variable "location" {
  description = "Azure region for the resource group"
  type        = string
}

variable "region" {
  description = "Short region code for naming (e.g., gwc for germanywestcentral)"
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID to monitor"
  type        = string
}

variable "alert_email" {
  description = "Email address for security alerts"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

output "subscription_id" {
  description = "The subscription GUID"
  value       = azurerm_subscription.this.subscription_id
}

output "name" {
  description = "The name of the subscription"
  value       = azurerm_subscription.this.subscription_name
}

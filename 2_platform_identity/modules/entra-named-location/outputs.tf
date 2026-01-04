output "id" {
  description = "The ID of the named location"
  value       = azuread_named_location.this.id
}

output "display_name" {
  description = "The display name of the named location"
  value       = azuread_named_location.this.display_name
}

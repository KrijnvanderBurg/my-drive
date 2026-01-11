output "id" {
  description = "The object ID of the group"
  value       = azuread_group.this.id
}

output "display_name" {
  description = "The display name of the group"
  value       = azuread_group.this.display_name
}

output "object_id" {
  description = "The object ID of the group (same as id)"
  value       = azuread_group.this.object_id
}
